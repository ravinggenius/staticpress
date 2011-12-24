require_relative '../test_case'

class SettingsTest < TestCase
  def test_default
    refute Staticpress::Settings.instance.verbose
  end

  def test_set!
    assert_equal nil, Staticpress::Settings.instance.favorite_number
    Staticpress::Settings.set! :favorite_number => 42
    assert_equal 42, Staticpress::Settings.instance.favorite_number
  end
end
