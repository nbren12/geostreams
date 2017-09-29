#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <hiredis.h>

// Global Variables
const int     num_buffer = 100;
const char    global_counter[] = "GeostreamsCTR";
int           first_run = 1;
redisContext *globalconn;

/******************************************************************************
 * @brief    TODO
 *****************************************************************************/
void getenv_d(char *str,
              char *key,
              char *def)
{
    char *val;
    val = getenv(key);
    if (val != NULL) {
        strcpy(str, val);
        return;
    }
    strcpy(str, def);
}

/******************************************************************************
 * @brief    TODO
 *****************************************************************************/
redisContext *setupConnection()
{
    redisContext *c;
    redisReply   *reply;
    char          hostname[256], sport[256];
    char         *pass;

    getenv_d(hostname, "REDIS_URL", "127.0.0.1");
    getenv_d(sport, "REDIS_PORT", "6379");

    int port = atoi(sport);

    printf("redis-wrapper.c: Connecting to Redis Server at %s %d\n", hostname,
           port);

    struct timeval timeout = {
        1, 500000
    };                                          // 1.5 seconds
    c = redisConnectWithTimeout(hostname, port, timeout);
    if (c == NULL || c->err) {
        if (c) {
            printf("Connection error: %s\nptr", c->errstr);
            redisFree(c);
        }
        else {
            printf("Connection error: can't allocate redis context\nptr");
        }
        exit(1);
    }


    // Authenticate
    pass = getenv("REDIS_PW");
    if (pass != NULL) {
        redisCommand(c, "AUTH %s", pass);
    }

    redisCommand(c, "DEL A");

    return c;
}


/******************************************************************************
 * @brief    TODO
 *****************************************************************************/
void make_dimspec(char*dimstr,
                  int *dims,
                  int  ndims)
{
    int  i, offset;
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

size_t prod(int  init,
            int *arr,
            int  n)
{
    int    i;
    size_t len = (size_t) init;
    for (i = 0; i < n; i++) {
        len *= (size_t) arr[i];
    }

    return len;
}


/******************************************************************************
 * @brief    TODO

   @note     use const ints for dtypes because enum isn't interopable with fortran
 *****************************************************************************/
void Redis_push(redisContext *c,
                char         *KEY,
                void         *f,
                const char   *dtype,
                int          *dims,
                int           ndims)
{
    // dtype is in form <i4, <f8, <f4, etc

    // get length of the array
    char        digit[3] = "";
    digit[0] = dtype[2];
    int         bytesize = (size_t)atoi(digit);
    size_t      len = prod(bytesize, dims, ndims);

    // form dim string
    char        dimspec[100];
    make_dimspec(dimspec, dims, ndims);

    redisReply *reply;

    printf("redis_wrapper.c: HMSETTNG %s dtype %s dim %s\n", KEY, dtype,
           dimspec);
    reply = redisCommand(c, "HMSET %s dtype %s messages %b dimensions %s",
                         KEY, dtype, f, len, dimspec);

    freeReplyObject(reply);
}

long long Redis_incr(redisContext *c, const char *key){
  long long out;
  redisReply *reply;
  reply = redisCommand(c, "INCR %s", key);

  out =  reply->integer;
  freeReplyObject(reply);
  return out;
}

long long Redis_uniq(redisContext *c){
  return Redis_incr(c, global_counter);
}

/******************************************************************************
 * @brief    TODO
 *****************************************************************************/
void redisTestSet(redisContext *c)
{
    printf("Attempting to set A to 1\n");
    redisCommand(c, "SET A 1");
}
