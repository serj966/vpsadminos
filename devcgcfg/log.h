#ifndef __LOG_H
#define __LOG_H

#ifndef _GNU_SOURCE
#define _GNU_SOURCE 1
#endif
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <sys/time.h>
#include <string.h>
#include <strings.h>
#include <stdbool.h>

#define TRACE(format, ...) do {                            \
       fprintf(stderr, format "\n", ##__VA_ARGS__);        \
} while (0)

#define SYSERROR(format, ...)  do {                        \
       fprintf(stderr, format "\n", ##__VA_ARGS__);        \
} while (0)

#define log_error_errno(__ret__, __errno__, format, ...)      \
        ({                                                    \
                typeof(__ret__) __internal_ret__ = (__ret__); \
                errno = (__errno__);                          \
                SYSERROR(format, ##__VA_ARGS__);              \
                __internal_ret__;                             \
        })

#define log_trace(__ret__, format, ...)                       \
        ({                                                    \
                typeof(__ret__) __internal_ret__ = (__ret__); \
                TRACE(format, ##__VA_ARGS__);                 \
                __internal_ret__;                             \
        })

#endif /* __LOG_H */
