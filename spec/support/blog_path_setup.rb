module BlogPathSetup
  def set_temporary_blog_path(path = 'test_blog')
    before :each do
      Staticpress.blog_path = (Staticpress.root + '..' + 'tmp' + path).expand_path
      test_blog_public = Staticpress.blog_path + 'public'
      FileUtils.rm_rf test_blog_public if test_blog_public.directory?
    end

    after :each do
      Staticpress.blog_path = '.'
    end
  end
end
