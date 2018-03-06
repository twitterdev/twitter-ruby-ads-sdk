# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class PromotedAccount

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence
      include TwitterAds::Analytics

      attr_reader :account

      property :id, read_only: true
      property :approval_status, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true
      property :deleted, type: :bool, read_only: true

      property :line_item_id
      property :user_id
      property :paused, type: :bool

      RESOURCE_COLLECTION  = "/#{TwitterAds::API_VERSION}/" +
                             'accounts/%{account_id}/promoted_accounts'.freeze # @api private
      RESOURCE_STATS       = "/#{TwitterAds::API_VERSION}/" +
                             'stats/accounts/%{account_id}'.freeze # @api private
      RESOURCE_ASYNC_STATS = "/#{TwitterAds::API_VERSION}/" +
                             'stats/jobs/accounts/%{account_id}'.freeze # @api private
      RESOURCE_INSIGHTS    = "/#{TwitterAds::API_VERSION}/" +
                             'insights/accounts/%{account_id}'.freeze # @api private
      RESOURCE             = "/#{TwitterAds::API_VERSION}/" +
                             'accounts/%{account_id}/promoted_accounts/%{id}'.freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
