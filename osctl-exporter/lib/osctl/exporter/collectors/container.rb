require 'osctl/exporter/collectors/base'
require 'osctl/cli'
require 'osctl/cli/cgroup_params'

module OsCtl::Exporter
  class Collectors::Container < Collectors::Base
    include OsCtl::Cli::CGroupParams

    def setup
      @running = registry.gauge(
        :osctl_container_running,
        docstring: 'Marks running containers',
        labels: [:pool, :id],
      )
      @memory_used_bytes = registry.gauge(
        :osctl_container_memory_used_bytes,
        docstring: 'Memory used by containers',
        labels: [:pool, :id],
      )
      @cpu_ns_total = registry.gauge(
        :osctl_container_cpu_nanoseconds_total,
        docstring: 'Container CPU usage',
        labels: [:pool, :id, :mode],
      )
    end

    def collect(client)
      cg_init_subsystems(client.client)
      cts = client.list_containers
      cg_add_stats(
        cts,
        lambda { |ct| ct[:group_path] },
        [:memory, :cpu_user_time, :cpu_sys_time],
        true
      )

      cts.each do |ct|
        running.set(
          ct[:state] == 'running' ? 1 : 0,
          labels: {pool: ct[:pool], id: ct[:id]},
        )
        memory_used_bytes.set(
          ct[:memory].nil? ? 0 : ct[:memory].raw,
          labels: {pool: ct[:pool], id: ct[:id]},
        )
        cpu_ns_total.set(
          ct[:cpu_user_time].nil? ? 0 : ct[:cpu_user_time].raw,
          labels: {pool: ct[:pool], id: ct[:id], mode: 'user'},
        )
        cpu_ns_total.set(
          ct[:cpu_sys_time].nil? ? 0 : ct[:cpu_sys_time].raw,
          labels: {pool: ct[:pool], id: ct[:id], mode: 'system'},
        )
      end
    end

    protected
    attr_reader :running, :memory_total_bytes, :memory_used_bytes, :cpu_ns_total
  end
end
