# frozen_string_literal: true

require_relative "lib/heroicons/view_component/version"

Gem::Specification.new do |spec|
  spec.name = "heroicons-view-components"
  spec.version = Heroicons::ViewComponent::VERSION
  spec.authors = ["Kobus Post"]
  spec.email = ["me@kobuspost.dev"]

  spec.summary = "ViewComponent wrapper for Heroicons SVG icons"
  spec.description = "A Rails gem that provides ViewComponent components for Heroicons, " \
    "making it easy to use Heroicons in your Rails applications."
  spec.homepage = "https://github.com/kpost/heroicons-view-components"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(["git", "ls-files", "-z"], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?("bin/", "Gemfile", ".gitignore", ".rubocop.yml")
    end
  end
  spec.files += Dir["vendor/**/*"] if Dir.exist?("vendor")

  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("view_component", ">= 4.0")

  # Development and test dependencies
  spec.add_development_dependency("minitest", "~> 6.0")
  spec.add_development_dependency("minitest-reporters", "~> 1.6")
end
