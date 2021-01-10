#ifndef __MEMORY_H
#define __MEMORY_H

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

#define define_cleanup_function(type, cleaner)           \
        static inline void cleaner##_function(type *ptr) \
        {                                                \
                if (*ptr)                                \
                        cleaner(*ptr);                   \
        }

#define call_cleaner(cleaner) __attribute__((__cleanup__(cleaner##_function)))

#define close_prot_errno_disarm(fd) \
        if (fd >= 0) {              \
                int _e_ = errno;    \
                close(fd);          \
                errno = _e_;        \
                fd = -EBADF;        \
        }

static inline void close_prot_errno_disarm_function(int *fd)
{
       close_prot_errno_disarm(*fd);
}
#define __do_close call_cleaner(close_prot_errno_disarm)

define_cleanup_function(FILE *, fclose);
#define __do_fclose call_cleaner(fclose)

#define free_disarm(ptr)    \
        ({                  \
                free(ptr);  \
                ptr = NULL; \
        })


static inline void free_disarm_function(void *ptr)
{
        free_disarm(*(void **)ptr);
}

#define __do_free call_cleaner(free_disarm)

#define zalloc(__size__) (calloc(1, __size__))

#endif /* __MEMORY_H */
