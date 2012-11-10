require 'spec_helper'

describe Staticpress::Helpers do
  include Staticpress::Helpers

  describe '#extensionless_basename' do
    it '...' do
      assert_equal 'extensionless', extensionless_basename(Pathname('extensionless'))
      assert_equal '.htaccess', extensionless_basename(Pathname('.htaccess'))
      assert_equal 'tyrannasaurus_rex', extensionless_basename(Pathname('tyrannasaurus_rex.rb'))
      assert_equal 'stegosaurus', extensionless_basename(Pathname('dinosaurs/stegosaurus.rb'))
      assert_equal 'stegosaurus', extensionless_basename(Pathname('/dinosaurs/stegosaurus.rb'))
    end
  end

  describe '#extensionless_path' do
    it '...' do
      assert_equal Pathname('extensionless'), extensionless_path(Pathname('extensionless'))
      assert_equal Pathname('.htaccess'), extensionless_path(Pathname('.htaccess'))
      assert_equal Pathname('tyrannasaurus_rex'), extensionless_path(Pathname('tyrannasaurus_rex.rb'))
      assert_equal Pathname('dinosaurs/stegosaurus'), extensionless_path(Pathname('dinosaurs/stegosaurus.rb'))
      assert_equal Pathname('/dinosaurs/stegosaurus'), extensionless_path(Pathname('/dinosaurs/stegosaurus.rb'))
    end
  end

  describe '#hash_from_empty_array' do
    it '...' do
      actual = hash_from_array [] {}
      assert_equal({}, actual)
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

      assert_equal expected, actual
    end
  end

  describe '#paginate' do
    it '...' do
      # a == oldest, z == newest
      assert_equal 3, paginate(:a..:z).count
      assert_equal (:a..:j).to_a, paginate(:a..:z)[0] # page 1 lists oldest, with oldest at top
      assert_equal (:k..:t).to_a, paginate(:a..:z)[1]
      assert_equal (:u..:z).to_a, paginate(:a..:z)[2] # page 3 lists newest, with newest at bottom (default page)
      assert_equal [], paginate(:a..:z)[5], 'Accessing an invalid index on anything that has been paginated should return an empty array'
    end
  end

  describe '#titleize' do
    it '...' do
      assert_equal '', titleize('')
      assert_equal '', titleize('/')
      assert_equal 'Foo -> Bar -> Baz', titleize('/foo/bar/baz')
      assert_equal 'Blogging With Staticpress', titleize('blogging-with-staticpress')
    end
  end
end
