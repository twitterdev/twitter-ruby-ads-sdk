# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  module Creative

    class LeadGenCard

      include TwitterAds::DSL
      include TwitterAds::Resource
      include TwitterAds::Persistence

      attr_reader :account

      property :id, read_only: true
      property :preview_url, read_only: true
      property :deleted, type: :bool, read_only: true
      property :created_at, type: :time, read_only: true
      property :updated_at, type: :time, read_only: true

      property :name
      property :image_media_id
      property :cta
      property :fallback_url
      property :privacy_policy_url
      property :title
      property :submit_url
      property :submit_method
      property :custom_destination_url
      property :custom_destination_text
      property :custom_key_screen_name
      property :custom_key_name
      property :custom_key_email

      RESOURCE_COLLECTION = "/#{TwitterAds::API_VERSION}/accounts/%{account_id}/cards/lead_gen".freeze # @api private
      RESOURCE            = "/#{TwitterAds::API_VERSION}/accounts/%{account_id}/cards/lead_gen/%{id}".freeze # @api private

      def initialize(account)
        @account = account
        self
      end

    end

  end
end
