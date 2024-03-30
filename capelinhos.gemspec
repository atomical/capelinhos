# frozen_string_literal: true

require_relative "lib/capelinhos/version"

Gem::Specification.new do |spec|
  spec.name = "capelinhos"
  spec.version = Capelinhos::VERSION
  spec.authors = ["Adam Hallett"]
  spec.email = ["adam.t.hallett@gmail.com"]

  spec.summary = "Gracefully shutdown Phusion Passenger Ruby processes when they exceed specified memory usage."
  spec.homepage = "https://github.com/atomical/capelinhos"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "passenger", ">= 5.0"

  spec.add_development_dependency "byebug"
end
