#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif
#include <stdio.h>
#include <string.h>

#include "bpf.h"
#include "log.h"

static void usage(const char *prog)
{
	printf("Usage: %s <command>\n\n", prog);
	printf("Commands:\n");
	printf("  test\n");
	printf("  set <cgroup> <device> [device...]\n");
}

static int set_cgroup_devices(const char *cgroup_path, int cnt, char *argv[])
{
	__do_bpf_program_free struct bpf_program *devices = NULL;
	int ret;

	devices = bpf_program_new(BPF_PROG_TYPE_CGROUP_DEVICE);
        if (!devices)
                return log_error_errno(false, ENOMEM, "Failed to create new bpf program");

        ret = bpf_program_init(devices);
        if (ret)
                return log_error_errno(false, ENOMEM, "Failed to initialize bpf program");

	for (int i = 0; i < cnt; i++) {
		printf("device: '%s'\n", argv[i]);

		int n;
		char type;
		int major, minor;
		char access[4];
		access[0] = '\0';
		
		n = sscanf(argv[i], "%c:%d:%d:%3s", &type, &major, &minor, access);

		if (n < 3) {
			printf("invalid device %d\n", n);
			continue;
		}

		printf("n = %d, type = '%c', major = '%d', minor = '%d', access = '%s'\n", n, type, major, minor, access);

		ret = bpf_program_append_device(devices, type, major, minor, access);
		if (ret)
			return log_error_errno(false, ENOMEM, "Failed to add new rule to bpf device program: type %c, major %d, minor %d, access %s", type, major, minor, access);
	}

	ret = bpf_program_finalize(devices);
        if (ret)
                return log_error_errno(false, ENOMEM, "Failed to finalize bpf program");

        ret = bpf_program_cgroup_attach(devices, BPF_CGROUP_DEVICE,
                                        cgroup_path,
                                        BPF_F_ALLOW_MULTI);
        if (ret)
                return log_error_errno(false, ENOMEM, "Failed to attach bpf program");

	devices = NULL;
}

int main(int argc, char *argv[])
{
	if (argc < 2) {
		usage(argv[0]);
		return 1;
	}

	if (strcmp(argv[1], "test") == 0) {
		if (bpf_devices_cgroup_supported()) {
			printf("ok\n");
			return 0;
		} else {
			printf("error\n");
			return 1;
		}
	} else if (strcmp(argv[1], "set") == 0) {
		if (argc < 3) {
			usage(argv[0]);
			return 1;
		}

		set_cgroup_devices(argv[2], argc - 3, &argv[3]);
		getchar();
	} else {
		usage(argv[0]);
		return 1;
	}

	return 0;
}

