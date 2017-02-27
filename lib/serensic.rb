require 'serensic/version'
require 'serensic/params'
require 'serensic/errors/error'
require 'serensic/errors/client_error'
require 'serensic/errors/server_error'
require 'serensic/errors/authentication_error'
require 'net/http'
require 'json'

module Serensic
  class Client
    attr_accessor :user, :secret
    def initialize(options = {})
      @user = options.fetch(:user) { ENV.fetch('SERERNSIC_USER') }
      @secret = options.fetch(:secret) { ENV.fetch('SERENSIC_SECRET') }
      @host = options.fetch(:host) { 'http://app.serensic.com/app' }
      @user_agent = "serensic-ruby/#{VERSION} ruby/#{RUBY_VERSION}"
    end
    def send_message(params)
      post(@host, '/index.php?app=ws&op=pv&', params)
    end
    private
    def get(host, request_uri, params = {})
      uri = URI(host + request_uri + Params.encode(params.merge(u: @user, h: @secret)))
      message = Net::HTTP::Get.new(uri.request_uri)
      request(uri, message)
    end
    def post(host, request_uri, params)
      uri = URI(host + request_uri + Params.encode(params.merge(u: @user, h: @secret)))
      message = Net::HTTP::Post.new(uri.request_uri)
      request(uri, message)
    end
   def put(host, request_uri, params)
      uri = URI(host + request_uri + Params.encode(params.merge(u: @user, h: @secret)))
      message = Net::HTTP::Put.new(uri.request_uri)
      request(uri, message)
    end
    def delete(host, request_uri)
      uri = URI(host + request_uri + Params.encode(params.merge(u: @user, h: @secret)))
      message = Net::HTTP::Delete.new(uri.request_uri)
      request(uri, message)
    end

    def request(uri, message)
      http = Net::HTTP.new(uri.host, Net::HTTP.http_default_port)
      message['User-Agent'] = @user_agent
      http_response = http.request(message)
      case http_response
      when Net::HTTPNoContent
        :no_content
      when Net::HTTPSuccess
        if http_response['Content-Type'].split(';').first == 'application/json'
          JSON.parse(http_response.body)
        else
          http_response.body
     end
      when Net::HTTPUnauthorized
        fail AuthenticationError, "#{http_response.code} response from #{uri.host}"
      when Net::HTTPClientError
        fail ClientError, "#{http_response.code} response from #{uri.host}"
      when Net::HTTPServerError
        fail ServerError, "#{http_response.code} response from #{uri.host}"
      else
        fail Error, "#{http_response.code} response from #{uri.host}"
      end
    end
  end
end
