# Copyright 2009 Alexander E. Fischer <aef@raxys.net>
#
# This file is part of FileTransferMatchers.
#
# FileTransferMatchers is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require 'fileutils'
require 'tmpdir'

require 'lib/file_transfer_matchers'

describe Aef::FileTransferMatchers do
  include Aef::FileTransferMatchers

  before(:each) do
    # Before ruby 1.8.7, the tmpdir standard library had no method to create
    # a temporary directory (mktmpdir).
    if Gem::Version.new(RUBY_VERSION) < Gem::Version.new('1.8.7')
      @folder_path = File.join(Dir.tmpdir, 'file_transfer_matcher_spec')
      Dir.mkdir(@folder_path)
    else
      @folder_path = Dir.mktmpdir('file_transfer_matcher_spec')
    end
  end

  after(:each) do
    FileUtils.rm_rf(@folder_path)
  end

  it "should positively recognize a file deletion" do
    file = File.join(@folder_path, 'toDelete')

    FileUtils.touch(file)

    action = lambda {
      FileUtils.rm(file)
    }
    
    matcher = delete(file)
    matcher.matches?(action).should be_true
    matcher.negative_failure_message.should eql(
      "File #{file} was deleted")

  end

  it "should positively recognize a file movement" do
    file = File.join(@folder_path, 'toMove')
    target = file + '.bak'

    FileUtils.touch(file)

    action = lambda {
      FileUtils.mv(file, target)
    }
    
    matcher = move(file, :to => target)
    matcher.matches?(action).should be_true
    matcher.negative_failure_message.should eql(
      "File #{file} was moved to #{target}")
  end

  it "should positively recognize a file copying" do
    file = File.join(@folder_path, 'toCopy')
    target = file + '.bak'

    FileUtils.touch(file)

    action = lambda {
      FileUtils.cp(file, target)
    }
    
    matcher = copy(file, :to => target)
    matcher.matches?(action).should be_true
    matcher.negative_failure_message.should eql(
      "File #{file} was copied to #{target}")
  end

  it "should negatively recognize a failed file deletion" do
    file = File.join(@folder_path, 'toDelete')

    action = lambda {}
    
    matcher = delete(file)
    matcher.matches?(action).should be_false
    matcher.failure_message.should eql(
      "File #{file} could not be deleted, as it does not exist")
  end

  it "should negatively recognize if a move source is not existent" do
    file = File.join(@folder_path, 'toMove')
    target = file + '.bak'

    action = lambda {}
    
    matcher = move(file, :to => target)
    matcher.matches?(action).should be_false
    matcher.failure_message.should eql(
      "File #{file} could not be moved, as it does not exist")
  end

  it "should negatively recognize if a copy source is not existent" do
    file = File.join(@folder_path, 'toCopy')
    target = file + '.bak'

    action = lambda {}
    
    matcher = copy(file, :to => target)
    matcher.matches?(action).should be_false
    matcher.failure_message.should eql(
      "File #{file} could not be copied, as it does not exist")
  end

  it "should negativly recognize if a move target already exists" do
    file = File.join(@folder_path, 'toMove')
    target = file + '.bak'

    FileUtils.touch(file)
    FileUtils.touch(target)

    action = lambda {
      FileUtils.mv(file, target)
    }

    matcher = move(file, :to => target)
    matcher.matches?(action).should be_false
    matcher.failure_message.should eql(
      "File #{file} could not be moved, as target #{target} already exists")
  end

  it "should positively recognize if a move target already exists but overwrite is active" do
    file = File.join(@folder_path, 'toMove')
    target = file + '.bak'

    FileUtils.touch(file)
    FileUtils.touch(target)

    action = lambda {
      FileUtils.mv(file, target)
    }

    matcher = move(file, :to => target, :overwrite => true)
    matcher.matches?(action).should be_true
  end

  it "should negativly recognize if a copy target already exists" do
    file = File.join(@folder_path, 'toCopy')
    target = file + '.bak'

    FileUtils.touch(file)
    FileUtils.touch(target)

    action = lambda {
      FileUtils.cp(file, target)
    }

    matcher = copy(file, :to => target)
    matcher.matches?(action).should be_false
    matcher.failure_message.should eql(
      "File #{file} could not be copied, as target #{target} already exists")
  end

  it "should positively recognize if a copy target already exists but overwrite is active" do
    file = File.join(@folder_path, 'toCopy')
    target = file + '.bak'

    FileUtils.touch(file)
    FileUtils.touch(target)

    action = lambda {
      FileUtils.cp(file, target)
    }

    matcher = copy(file, :to => target, :overwrite => true)
    matcher.matches?(action).should be_true
  end

  it "should negatively recognize if a move target doesn't get created" do
    file = File.join(@folder_path, 'toMove')
    target = file + '.bak'

    FileUtils.touch(file)

    action = lambda {}

    matcher = move(file, :to => target)
    matcher.matches?(action).should be_false
    matcher.failure_message.should eql(
      "File #{file} should have been moved to #{target}, but target wasn't created")
  end

  it "should negatively recognize if a copy target doesn't get created" do
    file = File.join(@folder_path, 'toCopy')
    target = file + '.bak'

    FileUtils.touch(file)

    action = lambda {}

    matcher = copy(file, :to => target)
    matcher.matches?(action).should be_false
    matcher.failure_message.should eql(
      "File #{file} should have been copied to #{target}, but target wasn't created")
  end

  it "should negatively recognize if a move source doesn't get deleted" do
    file = File.join(@folder_path, 'toCopy')
    target = file + '.bak'

    FileUtils.touch(file)

    action = lambda {
      FileUtils.cp(file, target)
    }

    matcher = move(file, :to => target)
    matcher.matches?(action).should be_false
    matcher.failure_message.should eql(
      "File #{file} should have been moved, but source file still exists")
  end

  it "should negatively recognize if a file doesn't get deleted" do
    file = File.join(@folder_path, 'toCopy')
    target = file + '.bak'

    FileUtils.touch(file)

    action = lambda {
      FileUtils.cp(file, target)
    }

    matcher = delete(file)
    matcher.matches?(action).should be_false
    matcher.failure_message.should eql(
      "File #{file} should have been deleted, but source file still exists")
  end
end
