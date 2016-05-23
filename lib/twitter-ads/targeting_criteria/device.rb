# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class Device

    include TwitterAds::DSL
    include TwitterAds::Resource

    property :id, read_only: true
    property :name, read_only: true
    property :targeting_type, read_only: true
    property :targeting_value, read_only: true
    property :platform, read_only: true
    property :manufacturer, read_only: true

    RESOURCE_COLLECTION = '/1/targeting_criteria/devices'.freeze # @api private

    def initialize(account)
      @account = account
      self
    end
  end
end
