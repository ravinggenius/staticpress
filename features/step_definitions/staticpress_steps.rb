Given /^a blog exists$/ do
  Staticpress::CLI.new.new('tmp/aruba/temporary_blog', 'Transient Thoughts')
  cd('temporary_blog')
end

Given /^a blog with content exists$/ do
  step('a blog exists')
  Staticpress::CLI.new.create_page('about')
  Staticpress::CLI.new.create('hello-goodbye')
end

Given /^the blog has been previously built$/ do
  Staticpress::CLI.new.build
end

Given /^I require "([^"]*)"$/ do |library|
  require library
end


Then /^a post named "([^"]*)" should exist$/ do |post_title|
  now = Time.now.utc
  filename = [
    now.year,
    ('%02d' % now.month),
    ('%02d' % now.day),
    "#{post_title}.markdown"
  ].join('-')
  step("a file named \"content/_posts/#{filename}\" should exist")
end
