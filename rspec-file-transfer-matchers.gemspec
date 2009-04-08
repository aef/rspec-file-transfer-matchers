# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rspec-file-transfer-matchers}
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alexander E. Fischer"]
  s.date = %q{2009-04-09}
  s.description = %q{FileTransferMatchers are able to verify file movement, copying and deletion in RSpec based automated tests.}
  s.email = ["aef@raxys.net"]
  s.extra_rdoc_files = ["History.txt", "Manifest.txt", "README.rdoc"]
  s.files = ["History.txt", "Manifest.txt", "README.rdoc", "Rakefile", "lib/file_transfer_matchers.rb", "lib/file_transfer_matchers/file_transfer_matchers.rb", "lib/file_transfer_matchers/file_transfer_matcher.rb", "spec/file_transfer_matchers_spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{https://rubyforge.org/projects/aef/}
  s.rdoc_options = ["--main", "README.rdoc", "--inline-source", "--line-numbers", "--title", "FileTransferMatchers"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{aef}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{FileTransferMatchers are able to verify file movement, copying and deletion in RSpec based automated tests.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>, [">= 0"])
      s.add_development_dependency(%q<hoe>, [">= 1.11.0"])
    else
      s.add_dependency(%q<rspec>, [">= 0"])
      s.add_dependency(%q<hoe>, [">= 1.11.0"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 0"])
    s.add_dependency(%q<hoe>, [">= 1.11.0"])
  end
end
