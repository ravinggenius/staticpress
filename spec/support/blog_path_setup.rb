module BlogPathSetup
  FIXTURES_PATH = (Staticpress.root + '..' + 'spec' + 'fixtures').expand_path
  TEMP_PATH = (Staticpress.root + '..' + 'tmp').expand_path

  def set_temporary_blog_path(path = 'test_blog')
    source_path = FIXTURES_PATH + path
    temp_path = TEMP_PATH + path

    before :each do
      FileUtils.rm_rf temp_path if temp_path.directory?
      FileUtils.cp_r source_path, temp_path

      Staticpress.blog_path = temp_path.clone
    end

    after :each do
      Staticpress.blog_path = '.'
    end
  end
end
