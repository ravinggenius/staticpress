require 'spec_helper'

describe Staticpress::Metadata do
  let(:meta) { Staticpress::Metadata.new }
  let(:another_meta) { Staticpress::Metadata.new :layout => 'post_index', :categories => %w[programming], :tags => %w[code tutorial] }

  describe '#inspect' do
    assert_equal '#<Staticpress::Metadata>', meta.inspect
    assert_equal '#<Staticpress::Metadata categories=["programming"], layout="post_index", tags=["code", "tutorial"]>', another_meta.inspect
  end
end
