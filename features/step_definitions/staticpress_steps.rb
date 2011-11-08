require 'staticpress/cli'


Given /^a blog exists$/ do
  Staticpress::CLI.new.new('tmp/aruba/temporary_blog', 'Transient Thoughts')
  cd('temporary_blog')
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
