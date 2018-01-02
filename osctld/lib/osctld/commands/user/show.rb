module OsCtld
  class Commands::User::Show < Commands::Base
    handle :user_show

    def execute
      u = DB::Users.find(opts[:name])
      return error('user not found') unless u

      ok({
        name: u.name,
        username: u.sysusername,
        groupname: u.sysgroupname,
        ugid: u.ugid,
        ugid_offset: u.offset,
        ugid_size: u.size,
        dataset: u.dataset,
        homedir: u.homedir,
        registered: u.registered?,
      })
    end
  end
end
