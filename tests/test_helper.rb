$:.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'

require 'octopress'

SAMPLE_SITES = (Octopress.root + '..' + 'tests' + 'sample_sites').expand_path
