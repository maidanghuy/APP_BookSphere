package com.booksphere.book.config;

import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.cache.RedisCacheManagerBuilderCustomizer;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext;

@Configuration
@EnableCaching
public class CacheConfig {

    public static final String BOOKS_ACTIVE_CACHE = "booksActive";
    public static final String BOOK_DETAIL_CACHE = "bookDetail";
    public static final String CATEGORIES_ACTIVE_CACHE = "categoriesActive";

    @Bean
    public RedisCacheConfiguration redisCacheConfiguration(
            @Value("${booksphere.cache.default-ttl-minutes:10}") long defaultTtlMinutes,
            GenericJackson2JsonRedisSerializer redisJsonSerializer
    ) {
        return baseCacheConfiguration(Duration.ofMinutes(defaultTtlMinutes), redisJsonSerializer);
    }

    @Bean
    public RedisCacheManagerBuilderCustomizer redisCacheManagerBuilderCustomizer(
            @Value("${booksphere.cache.books-active-ttl-minutes:5}") long booksActiveTtl,
            @Value("${booksphere.cache.book-detail-ttl-minutes:10}") long bookDetailTtl,
            @Value("${booksphere.cache.categories-active-ttl-minutes:30}") long categoriesActiveTtl,
            GenericJackson2JsonRedisSerializer redisJsonSerializer
    ) {
        Map<String, RedisCacheConfiguration> configs = new HashMap<>();
        configs.put(BOOKS_ACTIVE_CACHE, baseCacheConfiguration(Duration.ofMinutes(booksActiveTtl), redisJsonSerializer));
        configs.put(BOOK_DETAIL_CACHE, baseCacheConfiguration(Duration.ofMinutes(bookDetailTtl), redisJsonSerializer));
        configs.put(CATEGORIES_ACTIVE_CACHE, baseCacheConfiguration(Duration.ofMinutes(categoriesActiveTtl), redisJsonSerializer));

        return builder -> builder.withInitialCacheConfigurations(configs);
    }

    private RedisCacheConfiguration baseCacheConfiguration(
            Duration ttl,
            GenericJackson2JsonRedisSerializer redisJsonSerializer
    ) {
        return RedisCacheConfiguration.defaultCacheConfig()
                .entryTtl(ttl)
                .disableCachingNullValues()
                .prefixCacheNameWith("book-service:")
                .serializeValuesWith(
                        RedisSerializationContext.SerializationPair.fromSerializer(redisJsonSerializer)
                );
    }
}
