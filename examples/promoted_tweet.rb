# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.

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

# load up the account instance, campaign and line item
account   = client.accounts(ADS_ACCOUNT)
campaign  = account.campaigns.first
line_item = account.line_items(nil, params: { campaign_id: campaign.id }).first

# create request for a simple nullcasted tweet
tweet1 = TwitterAds::Tweet.create(account, 'There can be only one...')

# promote the tweet using our line item
promoted_tweet = TwitterAds::Creative::PromotedTweet.new(account)
promoted_tweet.line_item_id = line_item.id
promoted_tweet.tweet_id     = tweet1.body[:data][:id]
promoted_tweet.save

# create request for a nullcasted tweet with a website card
website_card = TwitterAds::Creative::WebsiteCard.all(account).first
tweet2 = TwitterAds::Tweet.create(account, "Fine. There can be two. #{website_card.preview_url}")

# promote the tweet using our line item
promoted_tweet = TwitterAds::Creative::PromotedTweet.new(account)
promoted_tweet.line_item_id = line_item.id
promoted_tweet.tweet_id     = tweet2.body[:data][:id]
promoted_tweet.save
