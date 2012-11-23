module Fixtures
  FIXTURES_PATH = (Staticpress.root + '..' + 'spec' + 'fixtures').expand_path
  TEMP_PATH = (Staticpress.root + '..' + 'tmp').expand_path

  def basic_blog
    setup_blog 'test_blog'
  end

  def setup_blog(name)
    source_path = FIXTURES_PATH + name
    temp_path = TEMP_PATH + name

    before :each do
      FileUtils.rm_rf temp_path if temp_path.directory?
      FileUtils.cp_r source_path, temp_path

      Staticpress.blog_path = temp_path.clone
    end

    after :each do
      Staticpress.blog_path = '.'
    end
  end

  def create_sample_blog(title = 'Transient Thoughts')
    before :each do
      blog_title = title ? "'#{title}'" : nil
      run_simple "staticpress new temporary_blog #{blog_title}"
      cd('temporary_blog')
      append_to_file 'Gemfile', <<-RUBY
gem 'staticpress', :path => '../../..'
      RUBY
    end
  end
end
