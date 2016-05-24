# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Analytics

    ANALYTICS_MAP = {
      'TwitterAds::LineItem' => 'LINE_ITEM'.freeze,
      'TwitterAds::OrganicTweet' => 'ORGANIC_TWEET'.freeze,
      'TwitterAds::Creative::PromotedTweet' => 'PROMOTED_TWEET'.freeze
    }.freeze

    def self.included(klass)
      klass.send :include, InstanceMethods
      klass.extend ClassMethods
    end

    module InstanceMethods

      # Pulls a list of metrics for the current object instance.
      #
      # @example
      #   metric_groups = [:promoted_tweet_timeline_clicks, :promoted_tweet_search_clicks]
      #   object.stats(metrics)
      #
      # @param metric_groups [Array] A collection of metric groups to fetch.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Time] :start_time The starting time to use (default: 7 days ago).
      # @option opts [Time] :end_time The end time to use (default: now).
      # @option opts [Symbol] :granularity The granularity to use (default: :hour).
      #
      # @return [Array] The collection of stats requested.
      #
      # @see https://dev.twitter.com/ads/analytics/metrics-and-segmentation
      # @since 0.1.0
      def stats(metric_groups, opts = {})
        self.class.stats(account, [id], metric_groups, opts)
      end

    end

    module ClassMethods

      # Pulls a list of metrics for a specified set of object IDs.
      #
      # @example
      #   ids = ['7o4em', 'oc9ce', '1c5lji']
      #   metric_groups = [MetricGroups.MOBILE_CONVERSION, MetricGroups.ENGAGEMENT]
      #   object.stats(account, ids, metric_groups)
      #
      # @param account [Account] The Account object instance.
      # @param ids [Array] A collection of object IDs being targeted.
      # @param metric_groups [Array] A collection of metric_groups to be fetched.
      # @param opts [Hash] An optional Hash of extended options.
      # @option opts [Time] :start_time The starting time to use (default: 7 days ago).
      # @option opts [Time] :end_time The end time to use (default: now).
      # @option opts [Symbol] :granularity The granularity to use (default: :hour).
      # @option opts [Symbol] :placement The placement of entity (default: ALL_ON_TWITTER).
      #
      # @return [Array] The collection of stats requested.
      #
      # @see https://dev.twitter.com/ads/analytics/metrics-and-segmentation
      # @since 0.1.0

      def stats(account, ids, metric_groups, opts = {})
        # set default metric values
        end_time          = opts.fetch(:end_time, (Time.now - Time.now.sec - (60 * Time.now.min)))
        start_time        = opts.fetch(:start_time, end_time - 604_800) # 7 days ago
        granularity       = opts.fetch(:granularity, :hour)
        placement         = opts.fetch(:placement, Placement::ALL_ON_TWITTER)

        params = {
          metric_groups: metric_groups.join(','),
          start_time: TwitterAds::Utils.to_time(start_time, granularity),
          end_time: TwitterAds::Utils.to_time(end_time, granularity),
          granularity: granularity.to_s.upcase,
          entity: ANALYTICS_MAP[name],
          placement: placement
        }

        params['entity_ids'] = ids.join(',')

        resource = self::RESOURCE_STATS % { account_id: account.id }
        response = Request.new(account.client, :get, resource, params: params).perform
        response.body[:data]
      end

    end

  end
end
