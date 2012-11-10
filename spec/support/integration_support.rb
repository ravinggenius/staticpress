module IntegrationSupport
  def create_sample_blog(title = 'Transient Thoughts')
    blog_title = title ? "'#{title}'" : nil
    run_simple "staticpress new temporary_blog #{blog_title}"
    cd('temporary_blog')
    append_to_file 'Gemfile', <<-RUBY
gem 'staticpress', :path => '../../..'
    RUBY
  end

  def run_one_of(*commands)
    run_simple commands.shuffle.first
  end

  def verify_directory_contains_file(directory, file)
    check_directory_presence [directory], true
    check_file_presence ["#{directory}/#{file}"], true
  end

  def samples_path
    Pathname("#{__FILE__}/../fixtures").expand_path
  end
end
