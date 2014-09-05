#--
# *** This code is copyright 2004 by Gavin Kistner
# *** It is covered under the license viewable at http://phrogz.net/JS/_ReuseLicense.txt
# *** Reuse or modification is free provided you abide by the terms of that license.
# *** (Including the first two lines above in your source code usually satisfies the conditions.)
#++
# Author::      Gavin Kistner (mailto:!@phrogz.net)
# Copyright::   Copyright (c)2004 Gavin Kistner
# License::     See http://Phrogz.net/JS/_ReuseLicense.txt for details
# Version::     0.9.6, 2004-Oct-11
# Full Code::   link:../DirectoryWatcher.rb
#
# This file covers the Dir::DirectoryWatcher class; see its documentation for more information.
#
# =Version History
#   20041011  v0.9.6   Close file reference after passing to onadd/onmodify
#   20040928  v0.9.5   Minor documentation cleanup
#   20040923  v0.9.4   onadd/onmodify get passed stats, too
#   20040922  v0.9     onadd_for_existing, name_regexp added
#   20040922  v0.8     Initial release

# ToDo:
# CRC

# Namespace for directory-related classes.
class Dir

# The DirectoryWatcher class keeps an eye on all files in a directory, and calls
# methods of your making when files are added to, modified in, and/or removed from
# that directory.
#
# The +on_add+, +on_modify+ and +on_remove+ callbacks should be Proc instances
# that should be called when a file is added to, modified in, or removed from 
# the watched directory.
#
# The +on_add+ and +on_modify+ Procs will be passed a File instance pointing to
# the file added/changed, as well as a Hash instance. The hash contains some
# saved statistics about the file (modification date (<tt>:date</tt>),
# file size (<tt>:size</tt>), and original path (<tt>:path</tt>)) and may also
# be used to store additional information about the file.
#
# The +on_remove+ Proc will only be passed the hash that was passed to +on_add+
# and +on_modify+ (since the file no longer exists in a way that the watcher
# knows about it). By storing your own information in the hash, you may do
# something intelligent when the file disappears.
#
# The first time the directory is scanned, the +on_add+ callback will be invoked
# for each file in the directory (since it's the first time they've been seen).
#
# Use the +onmodify_checks+ and +onmodify_requiresall+ properties to control
# what is required for the +on_modify+ callback to occur.
#
# If you do not set a Proc for any one of these callbacks; they'll simply
# be ignored.
#
# Use the +autoscan_delay+ property to set how frequently the directory is
# automatically checked, or use the #scan_now method to force it to look
# for changes.
#
# <b>You must call the #start_watching method after you create a DirectoryWatcher
# instance</b> (and after you have set the necessary callbacks) <b>to start the
# automatic scanning.</b>
#
# The DirectoryWatcher does not process sub-directories of the watched
# directory. Any item in the directory which returns +false+ for <tt>File.file?</tt>
# is ignored.
#
# Example:
#
#    device_manager = Dir::DirectoryWatcher.new( 'plugins/devices', 2 )
#    device_manager.name_regexp = /^[^.].*\.rb$/
#    
#    device_manager.on_add = Proc.new{ |the_file, stats_hash|
#       puts "Hey, just found #{the_file.inspect}!"
#
#       # Store something custom
#       stats_hash[:blorgle] = the_file.foo 
#    }
#    
#    device_manager.on_modify = Proc.new{ |the_file, stats_hash|
#       puts "Hey, #{the_file.inspect} just changed."
#    }
#    
#    device_manager.on_remove = Proc.new{ |stats_hash|
#       puts "Whoa, the following file just disappeared:"
#       stats_hash.each_pair{ |k,v|
#          puts "#{k} : #{v}"
#       }
#    }
#    
#    device_manager.start_watching
class DirectoryWatcher
   # How long (in seconds) to wait between checks of the directory for changes.
   attr_accessor :autoscan_delay
   
   # The Dir instance or path to the directory to watch.
   attr_accessor :directory
   def directory=( dir ) #:nodoc:
      @directory = dir.is_a?(Dir) ? dir : Dir.new( dir )
   end

   # Proc to call when files are added to the watched directory.
   attr_accessor :on_add
   
   # Proc to call when files are modified in the watched directory
   # (see +onmodify_checks+).
   attr_accessor :on_modify
   
   # Proc to call when files are removed from the watched directory.
   attr_accessor :on_remove
   
   # Array of symbols which specify which attribute(s) to check for changes.
   # Valid symbols are <tt>:date</tt> and <tt>:size</tt>.
   # Defaults to <tt>:date</tt> only.
   attr_accessor :onmodify_checks
   
   # If more than one symbol is specified for +onmodify_checks+, should
   # +on_modify+ be called only when *all* specified values change
   # (value of +true+), or when any *one* value changes (value of +false+)?
   # Defaults to +false+.
   attr_accessor :onmodify_requiresall
   
   # Should files which exist in the directory fire the +on_add+ callback
   # the first time the directory is scanned? Defaults to +true+.
   attr_accessor :onadd_for_existing
   
   # Regular expression to match against file names. If +nil+, all files
   # will be included, otherwise only those whose name match the regexp
   # will be passed to the +on_add+/+on_modify+/+on_remove+ callbacks.
   # Defaults to <tt>/^[^.].*$/</tt> (files which do not begin with a period).
   attr_accessor :name_regexp
   
   # Creates a new directory watcher.
   #
   # _dir_::    The path (relative to the current working directory) of the
   #            directory to watch, or a Dir instance.
   # _delay_::  The +autoscan_delay+ value to use; defaults to 10 seconds.
   def initialize( dir, delay = 10 )
      self.directory = dir
      @autoscan_delay = delay
      @known_file_stats = {}
      @onmodify_checks = [ :date ]
      @onmodify_requiresall = false
      @onadd_for_existing = true
      @scanned_once = false
      @name_regexp = /^[^.].*$/
   end 

   # Starts the automatic scanning of the directory for changes,
   # repeatedly calling #scan_now and then waiting +autoscan_delay+
   # seconds before calling it again.
   #
   # Automatic scanning is *not* turned on when you create a new
   # DirectoryWatcher; you must invoke this method (after setting
   # the +on_add+/+on_modify+/+on_remove+ callbacks).
   def start_watching
      @thread = Thread.new{ 
         while true
            self.scan_now
            sleep @autoscan_delay
         end
      }
   end

   # Stops the automatic scanning of the directory for changes.
   def stop_watching
      @thread.kill
   end

   # Scans the directory for additions/modifications/removals,
   # calling the +on_add+/+on_modify+/+on_remove+ callbacks as
   # appropriate.
   def scan_now
      #Check for add/modify
      scan_dir(@directory)
      
      # Check for removed files
      if @on_remove.respond_to?( :call )
         @known_file_stats.each_pair{ |path,stats|
            next if File.file?( path )
            stats[:path] = path
            @on_remove.call( stats )
            @known_file_stats.delete(path)
         }
      end
      
      @scanned_once = true
   end

   def add_all
     scan_dir(@directory, true)
   end

   def scan_dir(directory, override = false)
    # Setup the checks
    # ToDo: CRC
    checks = {
       :date => {
          :use=>false,
          :proc=>Proc.new{ |file,stats| stats.mtime }
       },
       :size => {
          :use=>false,
          :proc=>Proc.new{ |file,stats| stats.size }
       },
       :crc => {
          :use=>false,
          :proc=>Proc.new{ |file,stats| 1 }
       }
    }
    checks.each_pair{ |check_name,check|
       check[:use] = (@onmodify_checks == check_name) || ( @onmodify_checks.respond_to?( :include? ) && @onmodify_checks.include?( check_name ) )
    }
      
    directory.rewind
    directory.each{ |fname|
       next if fname.start_with? '.'
       file_path = "#{directory.path}/#{fname}"
       scan_dir(Dir.new(file_path), override) unless fname == "." || fname == ".." || File.file?(file_path)
       next if (@name_regexp.respond_to?( :match ) && !@name_regexp.match( fname )) || !File.file?( file_path )
       the_file = File.new( file_path )
       file_stats = File.stat( file_path )
       
       saved_stats = @known_file_stats[file_path]
       new_stats = {}
       checks.each_pair{ |check_name,check|
          new_stats[check_name] = check[:proc].call( the_file, file_stats )
       }
       
       @on_add.call(the_file, new_stats) if override
       if saved_stats
          if @on_modify.respond_to?( :call )
             sufficiently_modified = @onmodify_requiresall
             saved_stats = @known_file_stats[file_path]
             checks.each_pair{ |check_name,check|
                stat_changed = check[:use] && ( saved_stats[check_name] != new_stats[check_name] )
                if @onmodify_requiresall
                   sufficiently_modified &&= stat_changed
                else
                   sufficiently_modified ||= stat_changed
                end
                saved_stats[check_name] = new_stats[check_name]
             }
             @on_modify.call( the_file, saved_stats ) if sufficiently_modified 
          end
       elsif @on_add.respond_to?( :call ) && (@scanned_once || @onadd_for_existing)
          @known_file_stats[file_path] = new_stats
          @on_add.call( the_file, new_stats )
       end
       
       the_file.close
    }
   end

end

end
