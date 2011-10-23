# -*- encoding: utf-8 -*-

require File.expand_path('../lib/staticpress/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'staticpress'
  s.version     = Staticpress::Version.to_s
  s.authors     = ['Raving Genius']
  s.email       = ['rg+code@ravinggenius.com']
  s.summary     = %q{...}
  s.license     = 'MIT'

  s.rubyforge_project = 'staticpress'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.signing_key = '/home/thomas/Code/___/certificates/gem-private_key.pem'
  s.cert_chain = [
    '/home/thomas/Code/___/certificates/gem-public_cert.pem'
  ]

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'ruby-debug19'

  s.add_runtime_dependency 'bundler'
  s.add_runtime_dependency 'rack'
  s.add_runtime_dependency 'thor'
  s.add_runtime_dependency 'tilt'
end
