/* rfap header file to be included by client code. 
 *
 * No changes may be made to this file.
 *
 */

#define open  rfa_open
#define read  rfa_read
#define write rfa_write
#define close rfa_close

/* prototypes */

int rfa_open(const char *path, int flags, mode_t mode);
ssize_t rfa_read(int d, void *buf, size_t nbytes);
ssize_t  rfa_write(int d, const void *buf, size_t nbytes);
int rfa_close(int d);
