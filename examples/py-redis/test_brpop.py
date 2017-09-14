import redis

c = redis.StrictRedis()


while True:
    key, item = [it.decode("utf-8") for it in c.brpop("A")]
    print(f"{key}: {item}")
