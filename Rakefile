require 'bundler/gem_tasks'

task :console do
  require 'irb'
  require 'irb/completion'
  require 'zendesk_automator'
  ARGV.clear
  IRB.start
end

# GEM
GEMSPEC_FILE = Dir['*.gemspec'].first
GEMSPEC = eval(File.read(GEMSPEC_FILE))
GEMSPEC.validate

desc %q{
  build the gem and place it in pkg/
}
task :build do
  sh "gem build #{GEMSPEC_FILE}"
  sh "mkdir -p pkg"
  sh "mv #{GEMSPEC.name}-#{GEMSPEC.version}.gem pkg/"
end
