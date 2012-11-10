require 'spec_helper'

describe Staticpress::Metadata do
  let(:meta) { Staticpress::Metadata.new }
  let(:another_meta) { Staticpress::Metadata.new :layout => 'post_index', :categories => %w[programming], :tags => %w[code tutorial] }

  describe '#inspect' do
    it '...' do
      expect(meta.inspect).to eq('#<Staticpress::Metadata>')
      expect(another_meta.inspect).to eq('#<Staticpress::Metadata categories=["programming"], layout="post_index", tags=["code", "tutorial"]>')
    end
  end
end
