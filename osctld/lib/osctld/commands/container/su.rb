module OsCtld
  class Commands::Container::Su < Commands::Base
    handle :ct_su

    include Utils::Log
    include Utils::SwitchUser

    def execute
      ct = DB::Containers.find(opts[:id])
      return error('container not found') unless ct

      ok(ct_exec(ct, 'bash', '--rcfile', File.join(ct.lxc_dir, '.bashrc')))
    end
  end
end
