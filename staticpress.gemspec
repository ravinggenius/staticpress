# -*- encoding: utf-8 -*-

require File.expand_path('../lib/staticpress/version', __FILE__)

# http://timelessrepo.com/use-the-gemspec
Gem::Specification.new do |s|
  s.name        = 'staticpress'
  s.version     = Staticpress::Version
  s.authors     = ['Raving Genius']
  s.email       = ['rg+code@ravinggenius.com']
  s.summary     = 'Blog-centric static site builder'
  s.description = <<-DESCRIPTION
Staticpress is a blog-focused static site generator. It uses Tilt for rendering nearly any template you can think of and come with a built-in Rack server for easy development previews.
  DESCRIPTION
  s.license     = 'MIT'

  s.rubyforge_project = 'staticpress'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,feature}{,s}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.signing_key = '/home/thomas/Code/___/certificates/gem-private_key.pem'
  s.cert_chain = [
    '/home/thomas/Code/___/certificates/gem-public_cert.pem'
  ]

  s.add_development_dependency 'aruba'
  s.add_development_dependency 'compass'
  s.add_development_dependency 'cucumber'
  s.add_development_dependency 'haml'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'ruby-debug19'
  s.add_development_dependency 'sass'

  s.add_runtime_dependency 'bundler'
  #s.add_runtime_dependency 'hike' # look into this for template inheritance https://github.com/sstephenson/hike
  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'tilt'
end
