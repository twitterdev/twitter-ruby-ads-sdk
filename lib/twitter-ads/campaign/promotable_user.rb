# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class PromotableUser

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    property :id, read_only: true
    property :promotable_user_type, read_only: true
    property :user_id, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    RESOURCE_COLLECTION = '/1/accounts/%{account_id}/promotable_users'.freeze # @api private
    RESOURCE            = '/1/accounts/%{account_id}/promotable_users/%{id}'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end

  end
end
