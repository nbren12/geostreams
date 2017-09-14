import redis

c = redis.StrictRedis()

p = c.pubsub()
p.subscribe("A")
for item in p.listen():
    print(item['data'])
