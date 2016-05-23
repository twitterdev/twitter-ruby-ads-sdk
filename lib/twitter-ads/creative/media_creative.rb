# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class MediaCreative

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :id, read_only: true
      property :deleted, type: :bool, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true
      property :approval_status, read_only: true
      property :serving_status, read_only: true

      property :line_item_id
      property :account_media_id
      property :landing_url

      RESOURCE_COLLECTION = '/1/accounts/%{account_id}/media_creatives'.freeze # @api private
      RESOURCE = '/1/accounts/%{account_id}/media_creatives/%{id}'.freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
