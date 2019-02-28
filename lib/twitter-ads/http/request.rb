# frozen_string_literal: true
# Copyright (C) 2015 Twitter, Inc.

module TwitterAds

  # Generic container for API requests.
  class Request

    attr_reader :client, :method, :resource, :options

    HTTP_METHOD = {
      get:    Net::HTTP::Get,
      post:   Net::HTTP::Post,
      put:    Net::HTTP::Put,
      delete: Net::HTTP::Delete
    }.freeze

    DEFAULT_DOMAIN = 'https://ads-api.twitter.com'
    SANDBOX_DOMAIN = 'https://ads-api-sandbox.twitter.com'

    private_constant :DEFAULT_DOMAIN, :SANDBOX_DOMAIN, :HTTP_METHOD

    # Creates a new Request object instance.
    #
    # @example
    #   request = Request.new(client, :get, "/#{TwitterAds::API_VERSION}/accounts")
    #
    # @param client [Client] The Client object instance.
    # @param method [Symbol] The HTTP method to be used.
    # @param resource [String] The resource path for the request.
    #
    # @param opts [Hash] An optional Hash of extended options.
    # @option opts [String] :domain Forced override for default domain to use for the request. This
    #   value will also override :sandbox mode on the client.
    #
    # @since 0.1.0
    #
    # @return [Request] The Request object instance.
    def initialize(client, method, resource, opts = {})
      @client   = client
      @method   = method
      @resource = resource
      @options  = opts
      self
    end

    # Executes the current Request object.
    #
    # @example
    #   request = Request.new(client, :get, "/#{TwitterAds::API_VERSION}/accounts")
    #   request.perform
    #
    # @since  0.1.0
    #
    # @return [Response] The Response object instance generated by the Request.
    def perform
      handle_error(oauth_request)
    end

    private

    def domain
      @domain ||= begin
        @options[:domain] || (@client.options[:sandbox] ? SANDBOX_DOMAIN : DEFAULT_DOMAIN)
      end
    end

    def oauth_request
      request  = http_request
      consumer = OAuth::Consumer.new(@client.consumer_key, @client.consumer_secret, site: domain)
      token    = OAuth::AccessToken.new(consumer, @client.access_token, @client.access_token_secret)
      request.oauth!(consumer.http, consumer, token)

      write_log(request) if @client.options[:trace]
      response = consumer.http.request(request)
      write_log(response) if @client.options[:trace]

      Response.new(response.code, response.each {}, response.body)
    end

    def http_request
      request_url = @resource

      if @options[:params] && !@options[:params].empty?
        request_url += "?#{URI.encode_www_form(@options[:params])}"
      end

      request      = HTTP_METHOD[@method].new(request_url)
      request.body = @options[:body] if @options[:body]

      @options[:headers]&.each { |header, value| request[header] = value }
      request['user-agent'] = user_agent

      request
    end

    def user_agent
      "twitter-ads version: #{TwitterAds::VERSION} " \
      "platform: #{RUBY_ENGINE} #{RUBY_VERSION} (#{RUBY_PLATFORM})"
    end

    def write_log(object)
      if object.respond_to?(:code)
        @client.logger.info("Status: #{object.code} #{object.message}")
      else
        @client.logger.info("Send: #{object.method} #{domain}#{@resource} #{@options[:params]}")
      end

      object.each { |header| @client.logger.info("Header: #{header}: #{object[header]}") }

      # suppresses body content for non-Ads API domains (eg. upload.twitter.com)
      unless object.body&.empty?
        if @domain == SANDBOX_DOMAIN || @domain == DEFAULT_DOMAIN
          @client.logger.info("Body: #{object.body}")
        else
          @client.logger.info('Body: **OMITTED**')
        end
      end
    end

    def handle_error(response)
      raise TwitterAds::Error.from_response(response) unless response.code < 400
      response
    end

  end

end
