URLCacheTest
============

Simple iOS UI to test NSURLCache reaction to the `Accept` header. Mostly to find out if the `Accept` header is included in the cache key. The answer is no, it is not, as this log shows:

    2013-11-12 14:05:35.555 URLCacheTest[13227:70b] Requesting URL: https://abs.twimg.com/errors/twitter_web_sprite_icons.png
    2013-11-12 14:05:35.556 URLCacheTest[13227:70b] Sending accept header value: api/v2
    2013-11-12 14:05:35.558 URLCacheTest[13227:70b] CACHED: Non-error response code with 65084 bytes of data: 0.000851 sec
    2013-11-12 14:05:39.404 URLCacheTest[13227:70b] Requesting URL: https://abs.twimg.com/errors/twitter_web_sprite_icons.png
    2013-11-12 14:05:39.404 URLCacheTest[13227:70b] Sending accept header value: api/v3
    2013-11-12 14:05:39.407 URLCacheTest[13227:70b] CACHED: Non-error response code with 65084 bytes of data: 0.001124 sec

When hitting a page that returns a `Vary: *` header the results are the same:

    2013-11-12 14:19:28.061 URLCacheTest[13478:70b] Requesting URL: http://stackoverflow.com/questions/1975416/trying-to-understand-the-vary-http-header
    2013-11-12 14:19:28.062 URLCacheTest[13478:70b] Sending accept header value: text/xml
    2013-11-12 14:19:28.229 URLCacheTest[13478:70b] CACHED: Non-error response code with 61495 bytes of data: 0.166509 sec
    2013-11-12 14:19:35.301 URLCacheTest[13478:70b] Requesting URL: http://stackoverflow.com/questions/1975416/trying-to-understand-the-vary-http-header
    2013-11-12 14:19:35.302 URLCacheTest[13478:70b] Sending accept header value: text/json
    2013-11-12 14:19:35.475 URLCacheTest[13478:70b] CACHED: Non-error response code with 61495 bytes of data: 0.173358 sec
