package storage

import (
	"github.com/redis/go-redis/v9"
)

var RedisClient *redis.Client

func RedisInit() {
	RedisClient = redis.NewClient(&redis.Options{
		Addr:     "localhost:6380",
		Password: "",
		DB:       0,
	})
	
	// ctx := context.Background()

	// err := RedisClient.Set(ctx, "foo", "bar", 1000*time.Second).Err()
	// if err != nil {
	// 	panic(err)
	// }

	// val, err := RedisClient.Get(ctx, "foo").Result()
	// if err != nil {
	// 	panic(err)
	// }
	// fmt.Println("foo", val)
}
