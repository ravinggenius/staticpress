module UnitSupport
  def env(path)
    {
      'REQUEST_PATH' => path
    }
  end

  def with_config(options, &block)
    original = self.config

    begin
      self.config.merge(options).save
      block.call
    ensure
      original.save
    end
  end
end
