Given /^a blog exists$/ do
  create_sample_blog
end


When /^I create a new post$/ do
  run_simple 'staticpress create \'Hello World\''
end

When /^I create a new page$/ do
  run_simple 'staticpress create_page about'
end

When /^I fork a plugin$/ do
  run_simple 'staticpress fork_plugin blockquote'
end

When /^I fork and rename a plugin$/ do
  run_simple 'staticpress fork_plugin blockquote pullquote'
end

When /^I fork the default theme$/ do
  run_simple 'staticpress fork_theme'
end


Then /^I can edit the post$/ do
  now = Time.now.utc
  filename = [
    now.year,
    ('%02d' % now.month),
    ('%02d' % now.day),
    'hello-world.markdown'
  ].join('-')
  verify_directory_contains_file 'content/_posts', filename
end

Then /^I can edit the page$/ do
  verify_directory_contains_file 'content', 'about.markdown'
end

Then /^I can edit the forked plugin$/ do
  verify_directory_contains_file 'plugins', 'blockquote.rb'
end

Then /^I can edit my plugin$/ do
  verify_directory_contains_file 'plugins', 'pullquote.rb'
end

Then /^I can edit the theme files$/ do
  check_directory_presence ['themes/basic'], true
end
