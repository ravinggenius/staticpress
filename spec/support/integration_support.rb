module IntegrationSupport
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

  def ask_for_help
    commands = [
      'staticpress',
      'staticpress help',
      'staticpress -h',
      'staticpress --help'
    ]
    run_one_of *commands
  end

  def check_the_version
    commands = [
      'staticpress version',
      'staticpress -v',
      'staticpress --version'
    ]
    run_one_of *commands
  end

  def see_helpful_tips
    assert_exit_status 0
    assert_partial_output 'Usage', all_output
  end

  def see_the_version
    assert_exit_status 0
    assert_partial_output 'Staticpress', all_output
  end

  def confirm_minimal_files
    files = [
      'config.ru',
      'config.yml',
      'Gemfile',
      'README.markdown'
    ]
    check_file_presence files, true
  end

  def confirm_settings_saved
    check_file_content 'config.yml', <<-YAML, true
---
:title: This is my blog
    YAML
  end

  def create_post
    run_simple 'staticpress create \'Hello World\''
  end

  def create_page
    run_simple 'staticpress create_page about'
  end

  def fork_plugin(new_name = nil)
    run_simple "staticpress fork_plugin blockquote #{new_name}"
  end

  def fork_theme
    run_simple 'staticpress fork_theme'
  end

  def edit_post
    now = Time.now.utc
    filename = [
      now.year,
      ('%02d' % now.month),
      ('%02d' % now.day),
      'hello-world.markdown'
    ].join('-')
    verify_directory_contains_file 'content/_posts', filename
  end

  def edit_page
    verify_directory_contains_file 'content', 'about.markdown'
  end

  def confirm_plugin_editable(name)
    verify_directory_contains_file 'plugins', "#{name}.rb"
  end

  def confirm_theme_is_local(name)
    check_directory_presence ["themes/#{name}"], true
  end

  def confirm_site_not_built_or_deployed
    files = [
      'public/index.html',
      'public/about/index.html',
      '../deployed/index.html',
      '../deployed/about/index.html'
    ]
    check_file_presence files, false
  end

  def add_multi_format_page
    write_file 'content/formats.markdown.erb', 'hello world'
  end

  def build_site
    run_simple 'staticpress build'
  end

  def push_site
    run_simple 'staticpress build'
  end

  def list_urls
    run_simple 'staticpress list url_path'
  end

  def build_site_verbosely
    run_simple 'staticpress build --verbose'
  end

  def create_custom_home_page
    write_file 'content/index.markdown', <<-MARKDOWN
---
title: Custom Home Page
---

in custom page
    MARKDOWN
  end

  def add_custom_deploy_strategy
    append_to_file 'config.yml', <<-YAML
:deployment_strategies:
  :custom: 'cp -R public ../deployed'
    YAML
  end

  def confirm_formats_page_contains_markup
    check_exact_file_content 'public/formats/index.html', <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8' />
    <title>Formats | Transient Thoughts</title>
    <link href='/assets/basic/styles/all.css' rel='stylesheet' type='text/css' />
    <script src='http://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js'></script>
    <script src='/assets/basic/scripts/application.js'></script>
  </head>
  <body>
    <header>
      <div class='site-title'>Transient Thoughts</div>
      <div class='site-subtitle'>A blogging framework for hackers</div>
    </header>
    <nav></nav>
    <section><p>hello world</p></section>
    <section></section>
    <a class='github-ribbon' href='https://github.com/ravinggenius/staticpress' style='position: absolute; top: 0; right: 0;'>
  <img alt='Fork me on GitHub' src='https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png' />
</a>
  </body>
</html>
    HTML
  end

  def confirm_static_pages_present
    assert_partial_output '/', all_output
    assert_partial_output '/about', all_output
    assert_partial_output '/hello-goodbye', all_output
  end

  def confirm_output_directory_contains_expected_files
    files = [
      'public/index.html',
      'public/about/index.html'
    ]
    check_file_presence files, true
  end

  def confirm_filenames_output
    assert_partial_output "    page public/about/index.html", all_output
  end

  def confirm_built_home_page
    check_exact_file_content 'public/index.html', <<-HTML
<!DOCTYPE html>
<html>
  <head>
    <meta charset='utf-8' />
    <title>Custom Home Page | Transient Thoughts</title>
    <link href='/assets/basic/styles/all.css' rel='stylesheet' type='text/css' />
    <script src='http://ajax.googleapis.com/ajax/libs/jquery/1.7.0/jquery.min.js'></script>
    <script src='/assets/basic/scripts/application.js'></script>
  </head>
  <body>
    <header>
      <div class='site-title'>Transient Thoughts</div>
      <div class='site-subtitle'>A blogging framework for hackers</div>
    </header>
    <nav></nav>
    <section><p>in custom page</p></section>
    <section></section>
    <a class='github-ribbon' href='https://github.com/ravinggenius/staticpress' style='position: absolute; top: 0; right: 0;'>
  <img alt='Fork me on GitHub' src='https://s3.amazonaws.com/github/ribbons/forkme_right_darkblue_121621.png' />
</a>
  </body>
</html>
    HTML
  end

  def confirm_site_deployed
    files = [
      '../deployed/index.html',
      '../deployed/about/index.html'
    ]
    check_file_presence files, true
  end
end
