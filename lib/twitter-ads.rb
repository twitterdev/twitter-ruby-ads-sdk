# rubocop:disable Naming/FileName
# frozen_string_literal: true
# Copyright (C) 2019 Twitter, Inc.
# rubocop:enable Naming/FileName

require 'time'
require 'oauth'
require 'multi_json'
require 'forwardable'
require 'logger'

require 'twitter-ads/version'
require 'twitter-ads/utils'
require 'twitter-ads/error'
require 'twitter-ads/enum'
require 'twitter-ads/resources/dsl'

require 'twitter-ads/client'
require 'twitter-ads/cursor'
require 'twitter-ads/account'

require 'twitter-ads/resources/resource'
require 'twitter-ads/resources/persistence'
require 'twitter-ads/resources/analytics'
require 'twitter-ads/resources/batch'

require 'twitter-ads/http/request'
require 'twitter-ads/http/response'

require 'twitter-ads/restapi.rb'

require 'twitter-ads/audiences/tailored_audience'

require 'twitter-ads/campaign/app_list'
require 'twitter-ads/campaign/campaign'
require 'twitter-ads/campaign/funding_instrument'
require 'twitter-ads/campaign/line_item'
require 'twitter-ads/campaign/promotable_user'
require 'twitter-ads/campaign/targeting_criteria'
require 'twitter-ads/campaign/tweet'
require 'twitter-ads/campaign/organic_tweet'
require 'twitter-ads/campaign/iab_category'
require 'twitter-ads/campaign/advertiser_business_categories'
require 'twitter-ads/campaign/content_categories'

require 'twitter-ads/targeting_criteria/tv_market'
require 'twitter-ads/targeting_criteria/tv_show'
require 'twitter-ads/targeting_criteria/event'
require 'twitter-ads/targeting_criteria/device'
require 'twitter-ads/targeting_criteria/conversation'
require 'twitter-ads/targeting_criteria/platform'
require 'twitter-ads/targeting_criteria/platform_version'
require 'twitter-ads/targeting_criteria/network_operator'
require 'twitter-ads/targeting_criteria/location'
require 'twitter-ads/targeting_criteria/interest'
require 'twitter-ads/targeting_criteria/language'
require 'twitter-ads/targeting_criteria/app_store_category'

require 'twitter-ads/creative/account_media'
require 'twitter-ads/creative/cards_fetch'
require 'twitter-ads/creative/image_app_download_card'
require 'twitter-ads/creative/image_conversation_card'
require 'twitter-ads/creative/media_creative'
require 'twitter-ads/creative/media_library'
require 'twitter-ads/creative/promoted_account'
require 'twitter-ads/creative/promoted_tweet'
require 'twitter-ads/creative/scheduled_tweet'
require 'twitter-ads/creative/draft_tweet'
require 'twitter-ads/creative/video_app_download_card'
require 'twitter-ads/creative/video_conversation_card'
require 'twitter-ads/creative/video_website_card'
require 'twitter-ads/creative/website_card'
require 'twitter-ads/creative/poll_cards'
require 'twitter-ads/creative/tweet_previews'
require 'twitter-ads/creative/tweets'

require 'twitter-ads/targeting/audience_summary'

require 'twitter-ads/measurement/web_event_tag'
require 'twitter-ads/measurement/app_event_tag'

require 'twitter-ads/settings/user'
require 'twitter-ads/settings/tax'

require 'twitter-ads/legacy.rb'
