# encoding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'iso_bsd-i18n/version'

Gem::Specification.new do |s|
  s.name = %q{iso_bsd-i18n}
  s.version = IsoBsdI18n::VERSION
  s.homepage = "http://freeridepg.org/"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = [%q{William Wedler}]
  s.date = %q{2012-11-09}
  s.description = %q{Text describing bicycle wheel size information.}
  s.email = %q{wedler.w@freeridepgh.org}
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = `git ls-files`.split("\n")
  s.licenses = [%q{MIT}]
  s.require_paths = [%q{lib}]
  s.rubygems_version = %q{1.8.6}
  s.summary = %q{Text describing bicycle wheel size information. The purpose of this information is to assist in understanding and identifying a bicycle wheel size.}

  s.add_development_dependency(%q<rake>, [">= 0"])
  s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
  s.add_development_dependency(%q<i18n-spec>, [">= 0"])

  s.add_runtime_dependency(%q<bundler>, ["~> 1.2"], ["~> 1.2"])
  s.add_dependency(%q<i18n>, [">= 0"], [">= 0"])

end

