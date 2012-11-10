require 'spec_helper'

describe Staticpress::Settings do
  describe '.default' do
    it '...' do
      expect(Staticpress::Settings.instance.verbose).to be_false
    end
  end

  describe '.set!' do
    it '...' do
      expect(Staticpress::Settings.instance.favorite_number).to be_nil
      Staticpress::Settings.set! :favorite_number => 42
      expect(Staticpress::Settings.instance.favorite_number).to eq(42)
    end
  end
end
