require 'json'
require 'libosctl'

module OsCtl::Cli
 class Command
    include OsCtl::Utils::Humanize

    def self.run(klass, method, method_args = [])
      Proc.new do |global_opts, opts, args|
        cmd = klass.new(global_opts, opts, args)
        cmd.method(method).call(*method_args)
      end
    end

    attr_reader :gopts, :opts, :args

    def initialize(global_opts, opts, args)
      @gopts = global_opts
      @opts = opts
      @args = args
    end

    # @param v [Array] list of required arguments
    def require_args!(*v)
      if v.count == 1 && v.first.is_a?(Array)
        required = v.first
      else
        required = v
      end

      return if args.count >= required.count

      arg = required[ args.count ]
      raise GLI::BadCommandLine, "missing argument <#{arg}>"
    end

    def osctld_open
      c = OsCtl::Client.new
      c.open
      c
    end

    def osctld_call(cmd, opts = {}, &block)
      c = osctld_open
      opts[:cli] ||= cli_opt
      ret = c.cmd_data!(cmd, opts, &block)
      c.close
      ret
    end

    def osctld_resp(cmd, opts = {}, &block)
      c = osctld_open
      opts[:cli] ||= cli_opt
      ret = c.cmd_response(cmd, opts, &block)
      c.close
      ret
    end

    def osctld_fmt(cmd, opts = {}, cols = nil, fmt_opts = {}, &block)
      opts[:cli] ||= cli_opt

      if block
        ret = osctld_call(cmd, opts, &block)
      else
        ret = osctld_call(cmd, opts) { |msg| puts msg unless gopts[:quiet] }
      end

      if ret.is_a?(String)
        puts ret
      elsif ret
        format_output(ret, cols, **fmt_opts)
      end

      ret
    end

    def format_output(data, cols = nil, **fmt_opts)
      if gopts[:json]
        puts data.to_json

      else
        OsCtl::Lib::Cli::OutputFormatter.print(data, cols, **fmt_opts)
      end
    end

    protected
    def cli_opt
      "#{File.basename($0)} #{ARGV.join(' ')}"
    end
  end
end
