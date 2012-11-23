module CustomMatchers
  def assert_eql(expected, actual, message = nil)
    assert actual.eql?(expected), (message || "Expected #{actual} to have same content as #{expected}")
  end

  def refute_raises(exception, &block)
    begin
      block.call
      assert true
    rescue Exception => e
      refute e.is_an?(exception), exception_details(e, "Expected #{e} not to be raised")
      raise e
    end
  end
end
