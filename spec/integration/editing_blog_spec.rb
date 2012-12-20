require 'spec_helper'

describe 'Editing blog' do
  create_sample_blog

  it 'Creating a new blog post' do
    create_post
    edit_post
  end

  it 'Creating a static page' do
    create_page
    edit_page
  end

  context 'without any custom plugins' do
    before :each do
      run_simple 'rm -fR plugins'
    end

    it 'Copying a built-in plugin' do
      fork_plugin
      confirm_plugin_editable 'blockquote'
    end

    it 'Copying and \'renaming a built-in plugin' do
      fork_plugin 'pullquote'
      confirm_plugin_editable 'pullquote'
    end
  end

  it 'Copying the default theme' do
    fork_theme
    confirm_theme_is_local 'basic'
  end
end
