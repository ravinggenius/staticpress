Given /^a blog with content exists$/ do
  create_sample_blog
  run_simple 'staticpress create_page about'
  run_simple 'staticpress create hello-goodbye'
end

Given /^the site is not built or deployed$/ do
  files = [
    'public/index.html',
    'public/about/index.html',
    '../deployed/index.html',
    '../deployed/about/index.html'
  ]
  check_file_presence files, false
end


When /^I create a simple page with multiple formats$/ do
  write_file 'content/formats.markdown.erb', 'hello world'
end

When /^(I )?(\w+) the site$/ do |ignored, action|
  run_simple "staticpress #{action}"
end

When /^I list my blog's URLs$/ do
  run_simple 'staticpress list url_path'
end

When /^I build the site verbosely$/ do
  run_simple 'staticpress build --verbose'
end

When /^I create a custom home page$/ do
  write_file 'content/index.markdown', <<-MARKDOWN
---
title: Custom Home Page
---

in custom page
  MARKDOWN
end

When /^I add a custom deployment strategy$/ do
  append_to_file 'config.yml', <<-YAML
:deployment_strategies:
  :custom: 'cp -R public ../deployed'
  YAML
end


Then /^the formats page only contains markup$/ do
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

Then /^the static pages are present$/ do
  assert_partial_output '/', all_output
  assert_partial_output '/about', all_output
  assert_partial_output '/hello-goodbye', all_output
end

Then /^the output directory does not exist$/ do
  check_directory_presence ['public'], false
end

Then /^the output directory contains some markup files$/ do
  files = [
    'public/index.html',
    'public/about/index.html'
  ]
  check_file_presence files, true
end

Then /^I see each output file$/ do
  assert_partial_output "    page public/about/index.html", all_output
end

Then /^the build homepage looks good$/ do
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

Then /^the site is deployed$/ do
  files = [
    '../deployed/index.html',
    '../deployed/about/index.html'
  ]
  check_file_presence files, true
end
