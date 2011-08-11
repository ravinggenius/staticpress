require_relative '../../test_helper'

require 'pathname'

require 'staticpress/helpers'

class HelpersTest < TestHelper
  include Staticpress::Helpers

  def test_extensionless_basename
    assert_equal 'extensionless', extensionless_basename(Pathname.new('extensionless'))
    assert_equal '.htaccess', extensionless_basename(Pathname.new('.htaccess'))
    assert_equal 'tyrannasaurus_rex', extensionless_basename(Pathname.new('tyrannasaurus_rex.rb'))
    assert_equal 'stegosaurus', extensionless_basename(Pathname.new('dinosaurs/stegosaurus.rb'))
    assert_equal 'stegosaurus', extensionless_basename(Pathname.new('/dinosaurs/stegosaurus.rb'))
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
end
