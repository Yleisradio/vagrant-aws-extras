# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'vagrant-aws-extras/version'

Gem::Specification.new do |spec|
  spec.name          = "vagrant-aws-extras"
  spec.version       = VagrantPlugins::AWS::Extras::VERSION
  spec.authors       = ["Jaakko Suutarla"]
  spec.email         = ["jaakko.suutarla@yle.fi"]
  spec.description   = %q{Enables Vagrant to update dns records when using AWS Route53}
  spec.summary       = %q{Enables Vagrant to update dns records when using AWS Route53}
  spec.homepage      = "https://github.com/yle/vagrant-aws-extras"
  spec.license       = "MIT"

  # The following block of code determines the files that should be included
  # in the gem. It does this by reading all the files in the directory where
  # this gemspec is, and parsing out the ignored files from the gitignore.
  # Note that the entire gitignore(5) syntax is not supported, specifically
  # the "!" syntax, but it should mostly work correctly.
  root_path      = File.dirname(__FILE__)
  all_files      = Dir.chdir(root_path) { Dir.glob("**/{*,.*}") }
  all_files.reject! { |file| [".", ".."].include?(File.basename(file)) }
  gitignore_path = File.join(root_path, ".gitignore")
  gitignore      = File.readlines(gitignore_path)
  gitignore.map!    { |line| line.chomp.strip }
  gitignore.reject! { |line| line.empty? || line =~ /^(#|!)/ }

  unignored_files = all_files.reject do |file|
    # Ignore any directories, the gemspec only cares about files
    next true if File.directory?(file)

    # Ignore any paths that match anything in the gitignore. We do
    # two tests here:
    #
    #   - First, test to see if the entire path matches the gitignore.
    #   - Second, match if the basename does, this makes it so that things
    #     like '.DS_Store' will match sub-directories too (same behavior
    #     as git).
    #
    gitignore.any? do |ignore|
      File.fnmatch(ignore, file, File::FNM_PATHNAME) ||
        File.fnmatch(ignore, File.basename(file), File::FNM_PATHNAME)
    end
  end

  spec.files         = unignored_files
  spec.executables   = unignored_files.map { |f| f[/^bin\/(.*)/, 1] }.compact
  spec.require_path = "lib"

  spec.required_rubygems_version = ">= 1.3"

  spec.add_runtime_dependency "vagrant-aws", "~> 0.3"
  
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-core", "~> 2.12.2"
  spec.add_development_dependency "rspec-expectations", "~> 2.12.1"
  spec.add_development_dependency "rspec-mocks", "~> 2.12.1"
end