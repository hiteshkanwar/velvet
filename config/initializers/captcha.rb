
# uri = URI.parse(ENV["REDISCLOUD_URL"])
# REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)
# # REDIS = Redis.new
# redis = REDIS

# redis = Redis::Namespace.new('express:captcha', redis: redis)
# #redis=Redis.new
# SimpleCaptcha.setup do |sc|
#   # Redis instance
#   sc.redis = redis

#   # expire time for redis
#   sc.expire = 3600

#   # default: 100x28
#   sc.image_size = '80x34'

#   # default: 5
#   sc.length = 5

#   # default: simply_blue
#   # possible values:
#   # 'embosed_silver',
#   # 'simply_red',
#   # 'simply_green',
#   # 'simply_blue',
#   # 'distorted_black',
#   # 'all_black',
#   # 'charcoal_grey',
#   # 'almost_invisible'
#   # 'random'
#   sc.image_style = 'random'

#   # default: low
#   # possible values: 'low', 'medium', 'high', 'random'
#   sc.distortion = 'low'
# end