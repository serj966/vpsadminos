#ifndef __MACRO_H
#define __MACRO_H

#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif
#include <errno.h>
#include <fcntl.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <unistd.h>

#define move_ptr(ptr)                                 \
        ({                                            \
                typeof(ptr) __internal_ptr__ = (ptr); \
                (ptr) = NULL;                         \
                __internal_ptr__;                     \
        })

#define ret_set_errno(__ret__, __errno__)                     \
        ({                                                    \
                typeof(__ret__) __internal_ret__ = (__ret__); \
                errno = (__errno__);                          \
                __internal_ret__;                             \
        })

#define ret_errno(__errno__)         \
        ({                           \
                errno = (__errno__); \
                -(__errno__);        \
        })

#define free_move_ptr(a, b)          \
        ({                           \
                free(a);             \
                (a) = move_ptr((b)); \
        })

#define ARRAY_SIZE(x)                                                        \
        (__builtin_choose_expr(!__builtin_types_compatible_p(typeof(x),      \
                                                             typeof(&*(x))), \
                               sizeof(x) / sizeof((x)[0]), ((void)0)))

#define PTR_TO_UINT64(p) ((uint64_t)((intptr_t)(p)))

#endif /* __MACRO_H */
