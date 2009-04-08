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

module Aef::FileTransferMatchers
  VERSION = '1.0.0'

  def move(from, options = {}, &block)
    options[:copy_mode] = false
    Aef::FileTransferMatcher.new(from, options, &block)
  end

  def copy(from, options = {}, &block)
    options[:copy_mode] = true
    Aef::FileTransferMatcher.new(from, options, &block)
  end

  def delete(file, &block)
    Aef::FileTransferMatcher.new(file, :copy_mode => false, &block)
  end
end
