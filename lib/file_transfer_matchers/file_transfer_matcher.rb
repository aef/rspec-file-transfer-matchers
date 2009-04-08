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

module Aef
  class FileTransferMatcherError < StandardError; nil end
  class SourceNotExistentError < FileTransferMatcherError; nil end
  class TargetAlreadyExistentError < FileTransferMatcherError; nil end
  class TargetNotExistentError < FileTransferMatcherError; nil end
  class SourceStillExistentError < FileTransferMatcherError; nil end

  class FileTransferMatcher
    def initialize(from, options)
      @from = from
      @to = options[:to]
      @copy_mode = options[:copy_mode]
      @overwrite = options[:overwrite]

      raise 'A target must be given in copy mode' if @copy_mode and not @to
    end

    def matches?(event_proc)
      raise_block_syntax_error if block_given?

      raise SourceNotExistentError unless File.exist?(@from)
      raise TargetAlreadyExistentError if @to and File.exist?(@to) and not @overwrite

      event_proc.call

      raise TargetNotExistentError if @to and not File.exist?(@to)
      raise SourceStillExistentError if not @copy_mode and File.exist?(@from)

      true
    rescue FileTransferMatcherError
      @error = $!
      false
    end

    def raise_block_syntax_error
      raise MatcherError.new(<<-MESSAGE
  block passed to should or should_not move/copy/delete must use {} instead of do/end
        MESSAGE
      )
    end

    def failure_message
      case @error
      when SourceNotExistentError
        if @copy_mode
          "File #{@from} could not be copied, as it does not exist"
        elsif @to
          "File #{@from} could not be moved, as it does not exist"
        else
          "File #{@from} could not be deleted, as it does not exist"
        end
      when TargetAlreadyExistentError
        if @copy_mode
          "File #{@from} could not be copied, as target #{@to} already exists"
        else
          "File #{@from} could not be moved, as target #{@to} already exists"
        end
      when TargetNotExistentError
        if @copy_mode
          "File #{@from} should have been copied to #{@to}, but target wasn't created"
        else
          "File #{@from} should have been moved to #{@to}, but target wasn't created"
        end
      when SourceStillExistentError
        if @to
          "File #{@from} should have been moved, but source file still exists"
        else
          "File #{@from} should have been deleted, but source file still exists"
        end
      end
    end

    def negative_failure_message
      if @copy_mode
        "File #{@from} was copied to #{@to}"
      elsif @to
        "File #{@from} was moved to #{@to}"
      else
        "File #{@from} was deleted"
      end
    end
  end
end
