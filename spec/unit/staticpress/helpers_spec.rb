require 'spec_helper'

describe Staticpress::Helpers do
  include Staticpress::Helpers

  set_temporary_blog_path

  describe '#extensionless_basename' do
    it '...' do
      expect(extensionless_basename(Pathname('extensionless'))).to eq('extensionless')
      expect(extensionless_basename(Pathname('.htaccess'))).to eq('.htaccess')
      expect(extensionless_basename(Pathname('tyrannasaurus_rex.rb'))).to eq('tyrannasaurus_rex')
      expect(extensionless_basename(Pathname('dinosaurs/stegosaurus.rb'))).to eq('stegosaurus')
      expect(extensionless_basename(Pathname('/dinosaurs/stegosaurus.rb'))).to eq('stegosaurus')
    end
  end

  describe '#extensionless_path' do
    it '...' do
      expect(extensionless_path(Pathname('extensionless'))).to eq(Pathname('extensionless'))
      expect(extensionless_path(Pathname('.htaccess'))).to eq(Pathname('.htaccess'))
      expect(extensionless_path(Pathname('tyrannasaurus_rex.rb'))).to eq(Pathname('tyrannasaurus_rex'))
      expect(extensionless_path(Pathname('dinosaurs/stegosaurus.rb'))).to eq(Pathname('dinosaurs/stegosaurus'))
      expect(extensionless_path(Pathname('/dinosaurs/stegosaurus.rb'))).to eq(Pathname('/dinosaurs/stegosaurus'))
    end
  end

  describe '#hash_from_empty_array' do
    it '...' do
      actual = hash_from_array [] {}
      expect(actual).to eq({})
    end
  end

  describe '#hash_from_array' do
    it '...' do
      expected = {
        1 => { :key => 1 },
        2 => { :key => 2 },
        3 => { :key => 3 }
      }

      actual = hash_from_array [
        { :key => 1 },
        { :key => 2 },
        { :key => 3 }
      ] { |hash| hash[:key] }

      expect(actual).to eq(expected)
    end
  end

  describe '#paginate' do
    it '...' do
      # a == oldest, z == newest
      expect(paginate(:a..:z).count).to eq(3)
      expect(paginate(:a..:z)[0]).to eq((:a..:j).to_a) # page 1 lists oldest, with oldest at top
      expect(paginate(:a..:z)[1]).to eq((:k..:t).to_a)
      expect(paginate(:a..:z)[2]).to eq((:u..:z).to_a) # page 3 lists newest, with newest at bottom (default page)
      expect(paginate(:a..:z)[5]).to eq([]), 'Accessing an invalid index on anything that has been paginated should return an empty array'
    end
  end

  describe '#titleize' do
    it '...' do
      expect(titleize('')).to eq('')
      expect(titleize('/')).to eq('')
      expect(titleize('/foo/bar/baz')).to eq('Foo -> Bar -> Baz')
      expect(titleize('blogging-with-staticpress')).to eq('Blogging With Staticpress')
    end
  end
end
