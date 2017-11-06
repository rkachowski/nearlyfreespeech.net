require 'digest'
require 'securerandom'


module Nfsn
  class Api
    include HTTParty
    base_uri "https://api.nearlyfreespeech.net"

    def initialize api_key, username

      @validator = ->(body = '', request_uri){
        timestamp = Time.now.to_i
        salt = SecureRandom.hex(16)
        body_hash = Digest::SHA1.hexdigest body
        hash = DDigest::SHA1.hexdigest "#{username};#{timestamp};#{salt};#{api_key};#{request_uri};#{body_hash}"

        "#{username};#{timestamp};#{salt}#{hash}"
      }
    end


    def addRR site, name, type, data=3600

      
    end
  end
end