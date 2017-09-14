#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <hiredis.h>
// did brew install hiredis

const int num_buffer = 100;

int first_run = 1;
redisContext *c;

void setupConnection(){

  redisReply *reply;
  const char *hostname = "127.0.0.1";
  char*  pass;
  int port = 6379;


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


  // Authenticate
  pass = getenv("PASS");
  if (pass == NULL){
    pass = "";
    redisCommand(c, "AUTH %s", pass);
  }
}

void publish_to_redis_(int* f, int* nptr , int* mptr){
  redisReply *reply;
  char * buf;

  size_t  n, m;
  n = *nptr;
  m = *mptr;

  // connect
  if (first_run == 1) {
    printf("Setting up redis connection\n");
    setupConnection();
    first_run = 0;
  } 


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
  // redisFree(c);

}

void make_dimspec(char* dimstr, int * dims, int ndims){
  int i, offset;
  char k[64];

  offset = 0;

  i = 0;
  sprintf(k, "%d", dims[i]);
  strcat(dimstr, k);

  for (i = 1; i < ndims; i++) {
    sprintf(k, ",%d", dims[i]);
    strcat(dimstr, k);
  }
}

void iarray_to_redis(int *f, int* dims, int* ndims_ptr){

  redisReply *reply;
  char * buf;
  int ndims = *ndims_ptr;
  int i;


  // compute length of the array
  buf = (void *) f;
  size_t len;
  len = sizeof(f[0]);
  for (i=0; i < ndims; i++) {
    len *= (size_t) dims[i];
  }

  // form dim string
  char dimspec[100];
  make_dimspec(dimspec, dims, ndims);

  if (first_run == 1) {
    printf("Setting up redis connection\n");
    setupConnection();
    first_run = 0;
  } 


  // write message
  reply = redisCommand(c,"HMSET A:1  messages %b dimensions %s", buf, len, dimspec);

  // trim data
  freeReplyObject(reply);
  /* redisFree(c); */
}
