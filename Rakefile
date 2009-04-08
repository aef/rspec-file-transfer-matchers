# -*- ruby -*-

require 'rubygems'
require 'hoe'
require './lib/file_transfer_matchers.rb'

Hoe.new('rspec-file-transfer-matchers', Aef::FileTransferMatchers::VERSION) do |p|
  p.rubyforge_name = 'aef'
  p.developer('Alexander E. Fischer', 'aef@raxys.net')
  p.extra_deps = %w{rspec}
  p.url = 'https://rubyforge.org/projects/aef/'
  p.readme_file = 'README.rdoc'
  p.extra_rdoc_files = %w{README.rdoc}
  p.spec_extras = {
    :rdoc_options => ['--main', 'README.rdoc', '--inline-source', '--line-numbers', '--title', 'FileTransferMatchers']
  }
end

# vim: syntax=Ruby
