# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class PlatformVersion

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :name, read_only: true
    property :targeting_type, read_only: true
    property :targeting_value, read_only: true
    property :number, read_only: true
    property :platform, read_only: true

    RESOURCE_COLLECTION = '/1/targeting_criteria/platform_versions'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
