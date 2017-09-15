#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <hiredis.h>
// did brew install hiredis

const int num_buffer = 100;

int first_run = 1;
redisContext *c;

void getenv_d(char* str, char* key, char * def)
{
  char *val;
  val = getenv(key);
  if (val != NULL) {
    strcpy(str, val);
    return;
  }
  strcpy(str, def);
}

void setupConnection(){

  redisReply *reply;
  char hostname[256], sport[256];
  char* pass;

  getenv_d(hostname, "REDIS_URL", "127.0.0.1");
  getenv_d(sport, "REDIS_PORT", "6379");
  
  int port = atoi(sport);

  printf("redis-wrapper.c: Connecting to Redis Server at %s %d\n", hostname, port);

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
  pass = getenv("REDIS_PW");
  if (pass != NULL){
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
  dimstr[0] = '\0';
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
  reply = redisCommand(c,"HMSET B:1  messages %b dimensions %s", buf, len, dimspec);
  printf("wrapper-c: %s\n", reply->str);

  // trim data
  freeReplyObject(reply);
  /* redisFree(c); */
}
