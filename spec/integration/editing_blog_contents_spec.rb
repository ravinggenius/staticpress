require 'spec_helper'

describe 'Editing blog contents', :blur do
  create_sample_blog

  before :each do
    run_simple 'staticpress create_page about'
    run_simple 'staticpress create hello-goodbye'
  end

  it 'Creating a static page with multiple formats' do
    add_multi_format_page
    build_site
    confirm_formats_page_contains_markup
  end

  it 'Listing all routes' do
    list_urls
    confirm_static_pages_present
  end

  it 'Building a site' do
    build_site
    confirm_output_directory_contains_expected_files
  end

  it 'Building a site (verbose)' do
    build_site_verbosely
    confirm_filenames_output
  end

  it 'Building a site with a custom home page' do
    create_custom_home_page
    build_site
    confirm_built_home_page
  end

  it 'Pushing a compiled site to a remote location' do
    build_site
    add_custom_deploy_strategy
    push_site
    confirm_site_deployed
  end

  it 'Deploying site (build and push in one step)' do
    add_custom_deploy_strategy
    confirm_site_not_built_or_deployed
    deploy_site
    confirm_output_directory_contains_expected_files
    confirm_site_deployed
  end
end
