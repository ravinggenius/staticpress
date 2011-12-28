require_relative '../test_case'

require 'pathname'

require 'staticpress/helpers'

class HelpersTest < TestCase
  include Staticpress::Helpers

  def test_extensionless_basename
    assert_equal 'extensionless', extensionless_basename(Pathname('extensionless'))
    assert_equal '.htaccess', extensionless_basename(Pathname('.htaccess'))
    assert_equal 'tyrannasaurus_rex', extensionless_basename(Pathname('tyrannasaurus_rex.rb'))
    assert_equal 'stegosaurus', extensionless_basename(Pathname('dinosaurs/stegosaurus.rb'))
    assert_equal 'stegosaurus', extensionless_basename(Pathname('/dinosaurs/stegosaurus.rb'))
  end

  def test_extensionless_path
    assert_equal Pathname('extensionless'), extensionless_path(Pathname('extensionless'))
    assert_equal Pathname('.htaccess'), extensionless_path(Pathname('.htaccess'))
    assert_equal Pathname('tyrannasaurus_rex'), extensionless_path(Pathname('tyrannasaurus_rex.rb'))
    assert_equal Pathname('dinosaurs/stegosaurus'), extensionless_path(Pathname('dinosaurs/stegosaurus.rb'))
    assert_equal Pathname('/dinosaurs/stegosaurus'), extensionless_path(Pathname('/dinosaurs/stegosaurus.rb'))
  end

  def test_hash_from_empty_array
    actual = hash_from_array [] {}
    assert_equal({}, actual)
  end

  def test_hash_from_array
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

  def test_paginate
    # a == oldest, z == newest
    assert_equal 3, paginate(:a..:z).count
    assert_equal (:a..:j).to_a, paginate(:a..:z)[0] # page 1 lists oldest, with oldest at top
    assert_equal (:k..:t).to_a, paginate(:a..:z)[1]
    assert_equal (:u..:z).to_a, paginate(:a..:z)[2] # page 3 lists newest, with newest at bottom (default page)
    assert_equal [], paginate(:a..:z)[5], 'Accessing an invalid index on anything that has been paginated should return an empty array'
  end

  def test_spider_directory
  end

  def test_titleize
    assert_equal '', titleize('')
    assert_equal '', titleize('/')
    assert_equal 'Foo -> Bar -> Baz', titleize('/foo/bar/baz')
    assert_equal 'Blogging With Staticpress', titleize('blogging-with-staticpress')
  end
end
