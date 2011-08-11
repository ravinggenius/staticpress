# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)

require 'staticpress/version'

Gem::Specification.new do |s|
  s.name        = 'staticpress'
  s.version     = Staticpress::Version.to_s
  s.authors     = ['Raving Genius']
  s.email       = ['rg+code@ravinggenius.com']
  s.summary     = %q{...}

  s.rubyforge_project = 'staticpress'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.signing_key = '/home/thomas/Code/___/certificates/gem-private_key.pem'
  s.cert_chain = [
    '/home/thomas/Code/___/certificates/gem-public_cert.pem'
  ]

  s.add_dependency 'minitest'
  s.add_dependency 'rack'
  s.add_dependency 'thor'
  s.add_dependency 'tilt'
end