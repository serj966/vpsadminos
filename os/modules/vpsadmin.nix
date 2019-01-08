{ config, lib, pkgs, utils, ... }:

with utils;
with lib;

let

  cfg = config.vpsadmin;

  vmArgs = pkgs.writeText "vm.args" ''
    -name vpsadmin@${config.networking.hostName}
    -setcookie ${cfg.cookie}
  '';

  appConfig = pkgs.writeText "config.exs" ''
    use Mix.Config

    config :vpsadmin_queue, :queues, [
      {:default, 4}
    ]

    config :vpsadmin_transactional, :supervisor_node, :"${cfg.supervisorNode}"
  '';

  coreNode = pkgs.vpsadmin.core.node {
    releaseConfig = pkgs.writeText "rel-config.exs" ''
      environment :node do
        set include_erts: true
        set include_src: false
        set vm_args: "${vmArgs}"
        set config_providers: [
          {Mix.Releases.Config.Providers.Elixir, ["''${RELEASE_ROOT_DIR}/etc/config.exs"]}
        ]
        set overlays: [
          {:copy, "${appConfig}", "etc/config.exs"}
        ]
      end

      release :node do
        set version: current_version(:vpsadmin_base)
        set applications: [
          :runtime_tools,
          :vpsadmin_base,
          :vpsadmin_queue,
          :vpsadmin_transactional,
          :vpsadmin_worker,
          :vpsadmin_node
        ]
      end
    '';
    releaseName = "node";
    releaseEnv = "node";
  };

in

{

  ###### interface

  options = {
    vpsadmin = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Enable vpsAdmin integration, i.e. include nodectld and nodectl
        '';
      };

      db = mkOption {
        type = types.submodule {
          options = {
            host = mkOption {
              type = types.str;
              description = "Database hostname";
            };

            user = mkOption {
              type = types.str;
              description = "Database user";
            };

            password = mkOption {
              type = types.str;
              description = "Database password";
            };

            name = mkOption {
              type = types.str;
              description = "Database name";
            };
          };
        };
        default = {
          host = "";
          user = "";
          password = "";
          name = "";
        };
        description = ''
          Database credentials. Don't use this for production deployments, as
          the credentials would be world readable in the Nix store.
          Pass the database credentials through deployment.keys.nodectld-config
          in NixOps.
        '';
      };

      nodeId = mkOption {
        type = types.int;
        description = "Node ID";
      };

      netInterfaces = mkOption {
        type = types.listOf types.str;
        description = "Network interfaces";
      };

      consoleHost = mkOption {
        type = types.str;
        description = "Address for console server to listen on";
      };

      cookie = mkOption {
        type = types.str;
        description = ''
          Cookie for Erlang VM. Has to be set to the same value on all nodes
          within the cluster.
        '';
      };

      supervisorNode = mkOption {
        type = types.str;
        description = ''
          Long name of the supervisor node.
        '';
      };
    };
  };

  ###### implementation

  config = mkMerge [
    (mkIf cfg.enable {
      environment.etc."vpsadmin/nodectld.yml".source = pkgs.writeText "nodectld-conf" ''
        ${lib.optionalString (cfg.db.host != "") ''
        :db:
          :host: ${cfg.db.host}
          :user: ${cfg.db.user}
          :pass: ${cfg.db.password}
          :name: ${cfg.db.name}
        ''}
        :vpsadmin:
          :node_id: ${toString cfg.nodeId}
          :net_interfaces: [${lib.concatStringsSep ", " cfg.netInterfaces}]

        :console:
          :host: ${cfg.consoleHost}
      '';

      runit.services.nodectld.run = ''
        ulimit -c unlimited
        export HOME=${config.users.extraUsers.root.home}
        exec 2>&1
        exec ${pkgs.nodectld}/bin/nodectld --log syslog --log-facility local3 --export-console
      '';

      environment.systemPackages = [ pkgs.nodectl ];

      # environment.etc."core-node".source = pkgs.vpsadmin.core.node {};
      environment.etc."core-node".source = coreNode;

      runit.services.vpsadmin-node = {
        run = ''
          user=node
          dataDir=/var/vpsadmin/core-node
          overlay=$dataDir/.overlay
          release=$dataDir/release
          cgroup=/sys/fs/cgroup/systemd/vpsadmin/node

          export HOME=$dataDir
          export LOCALE_ARCHIVE="${pkgs.glibcLocales}/lib/locale/locale-archive"
          export LANG=${config.i18n.defaultLocale}

          chmod og+rx /var/vpsadmin

          if [ -d $cgroup ] ; then
            kill -SIGTERM `cat $cgroup/cgroup.procs`
            sleep 5

            if [ `cat $cgroup/cgroup.procs | wc -l` -gt 0 ] ; then
              kill -SIGKILL `cat $cgroup/cgroup.procs`
            fi

            sleep 3
            rmdir $cgroup || exit 1
          fi

          mkdir -p $cgroup
          echo $$ > $cgroup/cgroup.procs

          for dir in $overlay $release ; do
            if [ -d "$dir" ] ; then
              mountpoint -q $dir && umount -f $dir
              mountpoint -q $dir && exit 1

              rm -rf $dir
            fi
          done

          mkdir -p $overlay $release
          mount -t tmpfs -osize=256M tmpfs $overlay
          mkdir -p $overlay/rw $overlay/work
          mount \
            -t overlay \
            -olowerdir=${coreNode},upperdir=$overlay/rw,workdir=$overlay/work \
            overlay $release
          mkdir $release/var
          chown $user $release/var

          exec chpst -u $user:nogroup $release/bin/node foreground
        '';

        log.enable = true;
        log.sendTo = "127.0.0.1";
      };

      users.users.node = {
        isSystemUser = true;
        createHome = true;
        home = "/var/vpsadmin/core-node";
      };
    })
  ];
}
