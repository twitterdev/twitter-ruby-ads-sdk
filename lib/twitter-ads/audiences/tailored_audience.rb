# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds
  class TailoredAudience

    include TwitterAds::DSL
    include TwitterAds::Resource

    attr_reader :account

    property :id, read_only: true
    property :created_at, type: :time, read_only: true
    property :updated_at, type: :time, read_only: true
    property :deleted, type: :bool, read_only: true

    property :name
    property :list_type

    property :audience_size, read_only: true
    property :audience_type, read_only: true
    property :metadata, read_only: true
    property :partner_source, read_only: true
    property :reasons_not_targetable, read_only: true
    property :targetable, type: :bool, read_only: true
    property :targetable_types, read_only: true

    RESOURCE_COLLECTION = '/1/accounts/%{account_id}/tailored_audiences'.freeze # @api private
    RESOURCE = '/1/accounts/%{account_id}/tailored_audiences/%{id}'.freeze # @api private
    RESOURCE_UPDATE = '/1/accounts/%{account_id}/tailored_audience_changes'.freeze # @api private
    GLOBAL_OPT_OUT =
      '/1/accounts/%{account_id}/tailored_audiences/global_opt_out'.freeze # @api private

    LIST_TYPES = %w(
      EMAIL
      DEVICE_ID
      TWITTER_ID
      HANDLE
      PHONE_NUMBER
    ).freeze

    OPERATIONS = %w(
      ADD
      REMOVE
      REPLACE
    ).freeze

    def initialize(account)
      @account = account
      self
    end

    class << self

      # Creates a new tailored audience.
      #
      # @example
      #   audience = TailoredAudience.create(account, '/path/to/file', 'my list', 'EMAIL')
      #
      # @param account [Account] The account object instance.
      # @param file_path [String] The path to the file to be uploaded.
      # @param name [String] The tailored audience name.
      # @param list_type [String] The tailored audience list type.
      #
      # @since 0.3.0
      #
      # @return [TailoredAudience] The newly created tailored audience instance.
      def create(account, file_path, name, list_type)
        upload = TwitterAds::TONUpload.new(account.client, file_path)

        audience = new(account)
        audience.send(:create_audience, name, list_type)

        begin
          audience.send(:update_audience, audience, upload.perform, list_type, 'ADD')
          audience.reload!
        rescue TwitterAds::ClientError => e
          audience.delete!
          raise e
        end
      end

      # Updates the global opt-out list for the specified advertiser account.
      #
      # @example
      #   TailoredAudience.opt_out(account, '/path/to/file', 'EMAIL')
      #
      # @param account [Account] The account object instance.
      # @param file_path [String] The path to the file to be uploaded.
      # @param list_type [String] The tailored audience list type.
      #
      # @since 0.3.0
      #
      # @return [Boolean] The result of the opt-out update.
      def opt_out(account, file_path, list_type)
        upload   = TwitterAds::TONUpload.new(account.client, file_path)
        params   = { input_file_path: upload.perform, list_type: list_type }
        resource = GLOBAL_OPT_OUT % { account_id: account.id }
        Request.new(account.client, :put, resource, params: params).perform
        true
      end

    end

    # Updates the current tailored audience instance.
    #
    # @example
    #   audience = account.tailored_audiences('xyz')
    #   audience.update('/path/to/file', 'EMAIL', 'REPLACE')
    #
    # @param file_path [String] The path to the file to be uploaded.
    # @param list_type [String] The tailored audience list type.
    # @param operation [String] The update operation type (Default: 'ADD').
    #
    # @since 0.3.0
    #
    # @return [TailoredAudience] [description]
    def update(file_path, list_type, operation = 'ADD')
      upload = TwitterAds::TONUpload.new(account.client, file_path)
      update_audience(self, upload.perform, list_type, operation)
      reload!
    end

    # Deletes the current tailored audience instance.
    #
    # @example
    #   audience.delete!
    #
    # Note: calls to this method are destructive and irreverisble.
    #
    # @since 0.3.0
    #
    # @return [self] Returns the tailored audience instance refreshed from the API.
    def delete!
      resource = RESOURCE % { account_id: account.id, id: id }
      response = Request.new(account.client, :delete, resource).perform
      from_response(response.body[:data])
    end

    # Returns the status of all changes for the current tailored audience instance.
    #
    # @example
    #   audience.status
    #
    # @since 0.3.0
    #
    # @return [Hash] Returns a hash object representing the tailored audience status.
    def status
      return nil unless id
      resource = RESOURCE_UPDATE % { account_id: account.id }
      request = Request.new(account.client, :get, resource, params: to_params)
      Cursor.new(nil, request).to_a.select { |change| change[:tailored_audience_id] == id }
    end

    private

    def create_audience(name, list_type)
      params = { name: name, list_type: list_type }
      resource = RESOURCE_COLLECTION % { account_id: account.id }
      response = Request.new(account.client, :post, resource, params: params).perform
      from_response(response.body[:data])
    end

    def update_audience(audience, location, list_type, operation)
      params = {
        tailored_audience_id: audience.id,
        input_file_path: location,
        list_type: list_type,
        operation: operation
      }

      resource = RESOURCE_UPDATE % { account_id: audience.account.id }
      Request.new(audience.account.client, :post, resource, params: params).perform
    end

  end
end
