# config/initializers/geocoder.rb
if Rails.env.production? or Rails.env.staging?
  Geocoder.configure(
    # caching (see below for details):
    :cache => AutoexpireCache.new(Redis.new)
  )
end