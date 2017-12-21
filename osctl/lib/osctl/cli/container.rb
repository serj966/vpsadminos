require 'ipaddress'
require 'tempfile'

module OsCtl::Cli
  class Container < Command
    FIELDS = %i(
      id
      user
      dataset
      rootfs
      lxc_path,
      lxc_dir,
      distribution
      version
      state
      init_pid
      veth
    )

    FILTERS = %i(
      user
      distribution
      version
      state
    )

    DEFAULT_FIELDS = %i(
      id
      user
      distribution
      version
      state
      init_pid
    )

    def list
      if opts[:list]
        puts FIELDS.join("\n")
        return
      end

      cmd_opts = {}
      fmt_opts = {layout: :columns}

      FILTERS.each do |v|
        next unless opts[v]
        cmd_opts[v] = opts[v].split(',')
      end

      cmd_opts[:ids] = args if args.count > 0
      fmt_opts[:header] = false if opts['hide-header']

      osctld_fmt(
        :ct_list,
        cmd_opts,
        opts[:output] ? opts[:output].split(',').map(&:to_sym) : DEFAULT_FIELDS,
        fmt_opts
      )
    end

    def show
      if opts[:list]
        puts FIELDS.join("\n")
        return
      end

      raise "missing argument" unless args[0]

      fmt_opts = {layout: :rows}

      fmt_opts[:header] = false if opts['no-header']

      osctld_fmt(
        :ct_show,
        {id: args[0]},
        opts[:output] ? opts[:output].split(',').map(&:to_sym) : nil,
        fmt_opts
      )
    end

    def create
      raise "missing argument" unless args[0]

      osctld_fmt(
        :ct_create,
        id: args[0],
        user: opts[:user],
        template: File.absolute_path(opts[:template]),
      )
    end

    def delete
      raise "missing argument" unless args[0]

      osctld_fmt(:ct_delete, id: args[0])
    end

    def start
      raise "missing argument" unless args[0]
      return osctld_fmt(:ct_start, id: args[0]) unless opts[:foreground]

      open_console(args[0], 0) do |sock|
        unless osctld_fmt(:ct_start, id: args[0])
          sock.close
        end
      end
    end

    def stop
      raise "missing argument" unless args[0]
      return osctld_fmt(:ct_stop, id: args[0]) unless opts[:foreground]

      open_console(args[0], 0) do |sock|
        unless osctld_fmt(:ct_stop, id: args[0])
          sock.close
        end
      end
    end

    def restart
      raise "missing argument" unless args[0]
      return osctld_fmt(:ct_restart, id: args[0]) unless opts[:foreground]

      open_console(args[0], 0) do |sock|
        unless osctld_fmt(:ct_restart, id: args[0])
          sock.close
        end
      end
    end

    def console
      raise "missing argument" unless args[0]

      open_console(args[0], opts[:tty])
    end

    def attach
      raise "missing argument" unless args[0]

      ret = osctld(:ct_attach, id: args[0])

      unless ret[:status]
        warn "Error: #{ret[:message]}"
        return
      end

      cmd = ret[:response]

      pid = Process.fork do
        cmd[:env].each do |k, v|
          ENV[k.to_s] = v
        end

        Process.exec(*cmd[:cmd])
      end

      Process.wait(pid)
    end

    def exec
      raise "missing argument" unless args[0]
      raise "missing command to execute" if args.count < 2

      c = osctld_open
      c.cmd(:ct_exec, id: args[0], cmd: args[1..-1])
      ret = c.reply

      if !ret[:status] || ret[:response] != 'continue'
        warn "exec not available: #{ret[:message]}"
        exit(false)
      end

      r_in, w_in = IO.pipe
      r_out, w_out = IO.pipe
      r_err, w_err = IO.pipe

      c.send_io(r_in)
      c.send_io(w_out)
      c.send_io(w_err)

      r_in.close
      w_out.close
      w_err.close

      loop do
        rs, ws, = IO.select([STDIN, r_out, r_err, c.socket])

        rs.each do |r|
          case r
          when r_out
            data = r.read_nonblock(4096)
            STDOUT.write(data)
            STDOUT.flush

          when r_err
            data = r.read_nonblock(4096)
            STDERR.write(data)
            STDERR.flush

          when STDIN
            data = r.read_nonblock(4096)
            w_in.write(data)

          when c.socket
            r_out.close
            r_err.close

            c.reply
            return
          end
        end
      end
    end

    def su
      raise "missing argument" unless args[0]

      # TODO: error handling
      cmd = osctld(:ct_su, id: args[0])[:response]
      pid = Process.fork do
        cmd[:env].each do |k, v|
          ENV[k.to_s] = v
        end

        Process.exec(*cmd[:cmd])
      end

      Process.wait(pid)
    end

    def set
      raise "missing argument" unless args[0]
      params = {id: args[0]}
      raise "nothing to do" if params.empty?

      osctld_fmt(:ct_set, params)
    end

    def cd
      raise "missing argument" unless args[0]

      ret = osctld(:ct_show, id: args[0])

      unless ret[:status]
        warn "Error: #{ret[:message]}"
        return
      end

      ct = ret[:response]

      if opts[:runtime]
        raise "container not running" unless ct[:init_pid]
        path = File.join('/proc/', ct[:init_pid].to_s, 'root', '/')

      elsif opts[:lxc]
        path = ct[:lxc_dir]

      else
        path = ct[:rootfs]
      end

      file = Tempfile.new('osctl-rcfile')
      file.write(<<-END
        export PS1="(CT #{ret[:response][:id]}) $PS1"
        cd "#{path}"
        END
      )
      file.close

      puts "Spawning a new shell, exit when done"
      pid = Process.spawn(ENV['SHELL'] || 'bash', '--rcfile', file.path)
      Process.wait(pid)

      file.unlink
    end

    def open_console(ctid, tty)
      c = osctld_open
      c.cmd(:ct_console, id: ctid, tty: tty)
      ret = c.reply

      unless ret[:status]
        warn "Error: #{ret[:message]}"
        return
      end

      puts "Press Ctrl+a q to detach the console"
      puts

      state = `stty -g`
      `stty raw -echo -icanon -isig`

      pid = Process.fork do
        OsCtl::Console.open(c.socket, STDIN, STDOUT)
      end

      yield(c) if block_given?

      Process.wait(pid)

      `stty #{state}`
      puts
    end
  end
end
