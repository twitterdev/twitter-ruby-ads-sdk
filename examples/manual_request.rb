require 'twitter-ads'

CONSUMER_KEY        = 'your consumer key'
CONSUMER_SECRET     = 'your consumer secret'
ACCESS_TOKEN        = 'user access token'
ACCESS_TOKEN_SECRET = 'user access token secret'
ADS_ACCOUNT         = 'ads account id'

# initialize the twitter ads api client
client = TwitterAds::Client.new(
  CONSUMER_KEY,
  CONSUMER_SECRET,
  ACCESS_TOKEN,
  ACCESS_TOKEN_SECRET
)

# load up the account instance
account = client.accounts(ADS_ACCOUNT)

# using the TwitterAds::Request object you can manually request any
# twitter ads api resource that you want.

resource = "/0/accounts/#{account.id}/features"
params   = { feature_keys: 'AGE_TARGETING,CPI_CHARGING' }
request  = TwitterAds::Request.new(client, :get, resource, params: params)

# execute the request
response = request.perform

# you can also manually construct requests to be
# used in TwitterAds::Cursor object.

resource = '/0/targeting_criteria/locations'
params   = { location_type: 'CITY', q: 'port' }
request  = TwitterAds::Request.new(client, :get, resource, params: params)
cursor   = TwitterAds::Cursor.new(nil, request)

# execute requests and iterate cursor until exhausted
cursor.each do |item|
  # do something
end
