lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require './lib/zendesk_automator'

Gem::Specification.new do |g|
  g.name          = 'zendesk_automator'
  g.version       = ZendeskAutomator::VERSION
  g.authors       = ['Andreas Lindh']
  g.email         = ['andreas@superblock.se']
  g.description   = %q{Automate generation of Zendesk tickets}
  g.summary       = "#{g.description}"
  g.homepage      = 'https://github.com/ondmagi/zendesk_automator'
  g.license       = 'MIT'

  g.files         = `git ls-files`.split($/)
  g.executables   = g.files.grep(%r{^bin/}) { |f| File.basename(f) }
  g.test_files    = g.files.grep(%r{^(test|spec|features)/})
  g.require_paths = ['lib']

  g.add_development_dependency 'bundler'
  g.add_development_dependency 'rake'

  g.add_runtime_dependency 'zendesk_api'
  g.add_runtime_dependency 'rufus-scheduler'
  g.add_runtime_dependency 'erb'
end
