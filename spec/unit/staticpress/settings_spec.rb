require 'spec_helper'

describe Staticpress::Settings do
  describe '.default' do
    it '...' do
      refute Staticpress::Settings.instance.verbose
    end
  end

  describe '.set!' do
    it '...' do
      assert_equal nil, Staticpress::Settings.instance.favorite_number
      Staticpress::Settings.set! :favorite_number => 42
      assert_equal 42, Staticpress::Settings.instance.favorite_number
    end
  end
end
