#ifndef __BPF_H
#define __BPF_H

#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#include <linux/bpf.h>
#include <linux/filter.h>

#include "memory.h"
#include "macro.h"

#ifndef __NR_bpf
        #if defined __i386__
                #define __NR_bpf 357
        #elif defined __x86_64__
                #define __NR_bpf 321
        #elif defined __arm__
                #define __NR_bpf 386
        #elif defined __aarch64__
                #define __NR_bpf 386
        #elif defined __s390__
                #define __NR_bpf 351
        #elif defined __powerpc__
                #define __NR_bpf 361
        #elif defined __riscv
                #define __NR_bpf 280
        #elif defined __sparc__
                #define __NR_bpf 349
        #elif defined __ia64__
                #define __NR_bpf (317 + 1024)
        #elif defined _MIPS_SIM
                #if _MIPS_SIM == _MIPS_SIM_ABI32        /* o32 */
                        #define __NR_bpf 4355
                #endif
                #if _MIPS_SIM == _MIPS_SIM_NABI32       /* n32 */
                        #define __NR_bpf 6319
                #endif
                #if _MIPS_SIM == _MIPS_SIM_ABI64        /* n64 */
                        #define __NR_bpf 5315
                #endif
        #else
                #define -1
                #warning "__NR_bpf not defined for your architecture"
        #endif
#endif

union bpf_attr;

static inline int missing_bpf(int cmd, union bpf_attr *attr, size_t size)
{
        return syscall(__NR_bpf, cmd, attr, size);
}

#define bpf missing_bpf

struct bpf_program {
	int device_list_type;
	int kernel_fd;
	uint32_t prog_type;

	size_t n_instructions;
	struct bpf_insn *instructions;

	char *attached_path;
	int attached_type;
	uint32_t attached_flags;
};

struct bpf_program *bpf_program_new(uint32_t prog_type);
int bpf_program_init(struct bpf_program *prog);
int bpf_program_append_device(struct bpf_program *prog, char type, int major, int minor, char *access);
int bpf_program_finalize(struct bpf_program *prog);
int bpf_program_cgroup_attach(struct bpf_program *prog, int type, const char *path,
					      uint32_t flags);
int bpf_program_cgroup_detach(struct bpf_program *prog);
int bpf_program_cgroup_detach_path(const char *path, int type);
void bpf_program_free(struct bpf_program *prog);
//void bpf_device_program_free(struct cgroup_ops *ops);
bool bpf_devices_cgroup_supported(void);

static inline void __auto_bpf_program_free__(struct bpf_program **prog)
{
	if (*prog) {
		bpf_program_free(*prog);
		*prog = NULL;
	}
}

#define __do_bpf_program_free \
	__attribute__((__cleanup__(__auto_bpf_program_free__)))


#endif /* __BPF_H */
