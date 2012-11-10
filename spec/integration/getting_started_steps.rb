Given /^I ask for help$/ do
  commands = [
    'staticpress',
    'staticpress help',
    'staticpress -h',
    'staticpress --help'
  ]
  run_one_of *commands
end

Given /^I want Staticpress' version$/ do
  commands = [
    'staticpress version',
    'staticpress -v',
    'staticpress --version'
  ]
  run_one_of *commands
end


When /^I make a new blog( called "(.+)")?$/ do |ignored, title|
  create_sample_blog title
end


Then /^I am pointed in the right direction$/ do
  assert_exit_status 0
  assert_partial_output 'Usage', all_output
end

Then /^I see the version$/ do
  assert_exit_status 0
  assert_partial_output 'Staticpress', all_output
end

Then /^the minimal files are present$/ do
  files = [
    'config.ru',
    'config.yml',
    'Gemfile',
    'README.markdown'
  ]
  check_file_presence files, true
end

Then /^Staticpress should remember my blog title$/ do
  check_file_content 'config.yml', <<-YAML, true
---
:title: This is my blog
  YAML
end
