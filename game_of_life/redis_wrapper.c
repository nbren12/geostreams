#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <hiredis.h>
// did brew install hiredis


void publish_to_redis_(int* f, int* n , int* m){
  printf("Hello from C'");



  unsigned int j;
  redisContext *c;
  redisReply *reply;
  const char *hostname = "127.0.0.1";
  int port = 6379;
  char * buf;

  struct timeval timeout = { 1, 500000 }; // 1.5 seconds
  c = redisConnectWithTimeout(hostname, port, timeout);
  if (c == NULL || c->err) {
    if (c) {
      printf("Connection error: %s\n", c->errstr);
      redisFree(c);
    } else {
      printf("Connection error: can't allocate redis context\n");
    }
    exit(1);
  }

  // Add data to redis list
  printf("Pushing array to redis");
  buf = (void *) f;
  size_t len;
  len = sizeof(f) * ((size_t) *n) * ((size_t) *m);
  printf("Len is  %i", (int) len);
  reply = redisCommand(c,"LPUSH A %b", buf, len);
  freeReplyObject(reply);

}
