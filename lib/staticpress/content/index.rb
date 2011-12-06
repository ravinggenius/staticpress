require 'staticpress'
require 'staticpress/content/base'
require 'staticpress/content/collection_content'

module Staticpress::Content
  class Index < Base
    extend CollectionContent

    def optional_param_defaults
      { :number => 1 }
    end

    def sub_content
      paginate(Staticpress::Content::Post.all)[params[:number] - 1]
    end

    def template_path
      self.class.template_path
    end

    def self.all
      [
        new(:number => '1')
      ]
    end
  end
end
