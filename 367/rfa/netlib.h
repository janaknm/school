/* netlib.h :  prototypes for netlib
 *
 * 9/29/08 -- Phil Nelson
 *
 */

#include <arpa/inet.h>
#include <sys/socket.h>

int tcp4_server (in_addr_t ip, int port, int qsize );  
  // ip in network order, port in host byte order
  // Returns connection (socket fd) for use by accept or -1 for an error
  // accept(2) is not called.

int tcp4_connect (in_addr_t ip, int port ); 
  // ip number in network order, port in host byte order
  // Returns a connection (socket fd) for use by send/recv, -1 for an error

in_addr_t dns_lookup ( char *name ); 
  // name is NUL terminated
  // returns ip number in network order, 0 if an error.

void dns_rlookup (in_addr_t ip, char* name, int name_len);
  // Give the ip address in network byte order, lookup
  // the name of that host.  "name" is a pointer to an
  // array of characters that has "name_len" locations in the
  // array.  In case of an error, return the empty string.

int recv_line (int conn, char* str, int str_len);
  // Receives a line, tosses chars that won't fit into str.
  // str_len is the size of the str array.
  // Zero terminates line at the \r of the \r\n
  // Returns the number of characters in the string str.
  // Returns -2 if it finds the end-of-file

int send_line (int conn, char* str );
  // Sends a line of NETASCII to the socket.  str is
  // NUL terminated and does not end in \r\n (send_line adds them)
  // Returns the number of characters sent.

in_addr_t peer_ip (int conn);
  // Returns the ip number of the remote machine connected
  // on the socket.   The ip number is in network byte order.
  // Returns 0 on error.
