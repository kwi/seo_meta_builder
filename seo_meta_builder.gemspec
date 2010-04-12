Gem::Specification.new do |s|
  s.name = "seo_meta_builder"
  s.version = "0.1.0"
  s.author = "Guillaume Luccisano"
  s.email = "guillaume.luccisano@gmail.com"
  s.homepage = "http://github.com/kwi/seo_meta_builder"
  s.summary = "Manage easily your meta titles and descriptions with Ruby On Rails"
  s.description = "Seo Meta Builder is a plugin for Ruby on Rails that lets you easily manage your meta titles and descriptions."

  s.files = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"]
  s.require_path = "lib"

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end