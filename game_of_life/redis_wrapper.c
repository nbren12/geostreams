#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <hiredis.h>
// did brew install hiredis

const int num_buffer = 100;

redisContext * setupConnection(){

  redisContext *c;
  redisReply *reply;
  const char *hostname = "127.0.0.1";
  char*  pass;
  int port = 6379;

  pass = getenv("PASS");

  struct timeval timeout = { 1, 500000 }; // 1.5 seconds
  c = redisConnectWithTimeout(hostname, port, timeout);
  if (c == NULL || c->err) {
    if (c) {
      printf("Connection error: %s\nptr", c->errstr);
      redisFree(c);
    } else {
      printf("Connection error: can't allocate redis context\nptr");
    }
    exit(1);
  }
  redisCommand(c, "AUTH %s", pass);
  

  return c;
}

void publish_to_redis_(int* f, int* nptr , int* mptr){
  redisContext *c;
  redisReply *reply;
  char * buf;

  size_t  n, m;
  n = *nptr;
  m = *mptr;

  // connect
  c = setupConnection();


  // push data onto redis list
  // printf("Pushing array to redis\n");
  buf = (void *) f;
  size_t len;
  len = sizeof(f[0]) * m * n;
  // printf("Len is  %i", (int) len);
  reply = redisCommand(c,"LPUSH A %b", buf, len);

  // trim data
  reply = redisCommand(c, "LTRIM A 0 %d", num_buffer-1);
  // printf("%s\n",  reply->str);
  freeReplyObject(reply);
  redisFree(c);

}
