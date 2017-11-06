require 'httparty'
require 'digest'
require 'securerandom'

module Nfsn
  class Api
    include HTTParty
    base_uri "https://api.nearlyfreespeech.net"

    def initialize api_key, username

      @validator = ->( request_uri,body = ''){
        timestamp = Time.now.to_i
        salt = SecureRandom.hex(16)
        body_hash = Digest::SHA1.hexdigest body
        hash = Digest::SHA1.hexdigest "#{username};#{timestamp};#{salt};#{api_key};#{request_uri};#{body_hash}"

        { "X-NFSN-Authentication" => "#{username};#{timestamp};#{salt};#{hash}"}
      }
    end

    def add_resource_record site, name, type, data, ttl=3600
      uri = "/dns/#{site}/addRR"

      body = {
          name:name,
          type:type,
          data:data,
          ttl:ttl
      }

      headers = @validator.call uri,HTTParty::HashConversions.to_params(body)

      self.class.post(uri, body: body, headers: headers)
    end
    alias_method :addRR, :add_resource_record

    def list_resource_records site, name='', type='', data=''
      uri = "/dns/#{site}/listRRs"
      body = {}

      %w( name type data ).each {|d| body[d.to_sym] = eval(d) unless eval(d).empty? }

      headers = @validator.call uri, HTTParty::HashConversions.to_params(body)

      self.class.post(uri, query: body, headers: headers)
    end
  end
end