require 'staticpress'
require 'staticpress/error'
require 'staticpress/helpers'

module Staticpress
  class Pusher
    extend Staticpress::Helpers
    include Staticpress::Helpers

    def custom
      system config.deployment_strategies.custom
    end

    def self.push
      pusher = new

      raise Staticpress::Error, 'Nothing to deploy' unless (Staticpress.blog_path + config.destination_path).directory?
      raise Staticpress::Error, 'Deployment strategy not found' unless pusher.respond_to? config.deployment_strategy

      pusher.send config.deployment_strategy
    end
  end
end
