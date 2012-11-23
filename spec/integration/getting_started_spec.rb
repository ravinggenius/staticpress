require 'spec_helper'

describe 'Getting started' do
  it 'Getting help' do
    ask_for_help
    see_helpful_tips
  end

  it 'Finding the version' do
    check_the_version
    see_the_version
  end

  context 'generic blog' do
    create_sample_blog

    it 'Creating a new blog' do
      confirm_minimal_files
    end
  end

  context do
    create_sample_blog 'This is my blog'

    it 'Creating a new blog with a custum title' do
      confirm_settings_saved
    end
  end
end
