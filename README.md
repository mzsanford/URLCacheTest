URLCacheTest
============

Simple iOS UI to test NSURLCache reaction to the `Accept` header. Mostly to find out if the `Accept` header is included in the cache key. The answer is no, it is not, as this log shows:

    2013-11-12 14:05:35.555 URLCacheTest[13227:70b] Requesting URL: https://abs.twimg.com/errors/twitter_web_sprite_icons.png
    2013-11-12 14:05:35.556 URLCacheTest[13227:70b] Sending accept header value: api/v2
    2013-11-12 14:05:35.558 URLCacheTest[13227:70b] CACHED: Non-error response code with 65084 bytes of data: 0.000851 sec
    2013-11-12 14:05:39.404 URLCacheTest[13227:70b] Requesting URL: https://abs.twimg.com/errors/twitter_web_sprite_icons.png
    2013-11-12 14:05:39.404 URLCacheTest[13227:70b] Sending accept header value: api/v3
    2013-11-12 14:05:39.407 URLCacheTest[13227:70b] CACHED: Non-error response code with 65084 bytes of data: 0.001124 sec
