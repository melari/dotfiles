#!/usr/bin/env ruby
require 'net/ftp'
require 'terrun'
require 'timeout'
require_relative 'directory_watcher.rb'

class Harmony < TerminalRunner
  name "Harmony"

  param "server", "The FTP server to connect to"
  param "user", "The FTP user to use."
  param "password", "Password for the given user."
  param "directory", "The directory to watch."

  option "--help", 0, "", "Show this help document."
  option "--remote", 1, "path", "Remote path to use."
  option "--timeout", 1, "seconds", "Length of time to allow files to transfer. (default 2)"
  option "--coffee", 1, "target", "Automatically compile saved coffeescript files to the given directory."
  option "--eco", 2, "target identifier", "Automatically compile saved eco files to the given directory."
  option "--auto", 0, "", "Start up auto mode automatically."

  help ""

  def self.run
    if @@options.include? "--help"
      show_usage
      exit
    end

    @modified = []
    @active = false

    @server = @@params["server"]
    @user = @@params["user"]
    @password = @@params["password"]
    @directory = Dir.new(@@params["directory"])
    @remote_path = @@options.include?("--remote") ? @@options["--remote"][0] : ""
    @timeout = @@options.include?("--timeout") ? @@options["--timeout"][0].to_i : 2
    @compile_coffeescript = @@options.include?("--coffee") ? @@options["--coffee"][0] : nil

    @compile_eco = nil
    if @@options.include?("--eco")
      @compile_eco = @@options["--eco"][0]
      @eco_ident = @@options["--eco"][1]
    end

    @watcher = Dir::DirectoryWatcher.new(@directory)

    @modified_proc = Proc.new do |file, info|
      @modified << file.path
      if @active
        if file.path.end_with?(".coffee") && @compile_coffeescript
          `coffee -o #{@compile_coffeescript} -c #{file.path}`
        end
        if file.path.end_with?(".eco") && @compile_eco
          `eco -i #{@eco_ident} -o #{@compile_eco} #{file.path}`
        end
      end
    end

    @watcher.on_add = @modified_proc
    @watcher.on_modify = @modified_proc
    #@watcher.on_remove = @modified_proc

    @watcher.scan_now
    self.clear
    @active = true

    puts " ## Harmony is now running".red

    self.start_auto if @@options.include?("--auto")

    begin
      while true
        break if self.get_command
      end
    rescue => e
      puts e.to_s.red
      puts " ## FATAL ERROR OCCURRED. SHUTTING DOWN.".red
    end
    @thread.kill if @thread
    self.close_connection
  end

  def self.get_command
    print "Harmony:: ".yellow
    command, arg = gets.chomp.split(' ')
    return true if command == "exit" || command == "quit"
    self.show_help if command == "help"
    self.send_to_remote if command == "send" || command == "s"
    self.clear if command == "clear"
    self.show_status if command == "status" || command == "st"
    self.deploy if command == "deploy"
    self.start_auto if command == "auto"
    self.stop_auto if command == "stop"
    @modified_proc.call(File.new(arg), nil) if command == "mark"
    self.ftp if command == "ftp"
    false
  end

  def self.ftp
    `ftp ftp://#{@user}:#{@password}@#{@server}`
  end

  def self.start_auto
    puts " ## Auto upload has been started. Type 'stop' to kill the thread.".red
    @thread = Thread.new do
      begin
        while true
          self.send_to_remote
          sleep 2
        end
      rescue => e
        puts e.to_s.red
        puts " ## FATAL ERROR OCCURRED IN AUTO THREAD. SHUTTING DOWN.".red
        self.stop_auto
      end
    end
  end

  def self.stop_auto
    return unless @thread
    @thread.kill
    puts " ## Auto upload thread has been killed.".red
  end

  def self.deploy
    @watcher.add_all
    self.send_to_remote
  end

  def self.send_to_remote
    @watcher.scan_now
    return if @modified.empty?
    failed = !self.open_connection
    unless failed
      @modified.each do |file|
        next if file.end_with? "~"
        begin
          Timeout::timeout(@timeout) do
            rpath = self.remote_path_for(file)

            if @ftp.mkdir_p rpath
              puts " ## Created new directory #{rpath}".pink
            end

            @ftp.chdir rpath

            if file.end_with? ".png", ".gif", ".jpg", ".bmp", ".svg", ".tiff", ".raw"
              @ftp.putbinaryfile(file)
            else
              @ftp.puttextfile(file)
            end
            puts " ## [SUCCESS] #{file} => #{rpath}".green
          end
        rescue Timeout::Error
          failed = true
          puts " ## [ FAIL  ] #{file} timed out while syncing".red
        rescue Net::FTPError => e
          failed = true
          puts " ## [ FAIL  ] #{file} failed to sync".red
          puts e.message
        end
      end
    end

    if failed
      puts " ## Some files failed to transfer. The dirty list has not been cleared.".pink
    else
      self.clear
    end
  end

  def self.remote_path_for(file)
    extra_path = file.sub(@directory.path, "")
    @remote_path + extra_path[0, extra_path.rindex("/")]
  end

  def self.clear
    @modified = []
  end

  def self.show_status
    @watcher.scan_now

    return puts " ## Directory is in sync".green if @modified.count == 0

    puts " ## Files to be uploaded".red
    @modified.each do |file|
      puts "+   #{file}".pink
    end
  end

  def self.show_help
    puts " ## Harmony Help".red
    puts "help - Show this help file"
    puts "exit (quit) - Quit Harmony"
    puts "status (st) - Show a list of files that will be transfered"
    puts "clear - Mark all files as synced"
    puts "send (s) - Send all new and modified files to the remote server"
    puts "deploy - Send all files, regardless of their state"
    puts "mark [file] - Mark the specified file as changed (use format ./directory/file)"
    puts "auto - Automatically run 'send' every 2 seconds"
    puts "stop - reverses the 'auto' command"
  end

  def self.open_connection
    Timeout.timeout(@timeout) do
      if @ftp
        begin
          @ftp.list
        rescue Net::FTPError
          puts " ## Connection was closed by server".pink
          @ftp.close
        end
      end

      if @ftp.nil? || @ftp.closed?
        puts " ## Connection opening".red
        @ftp = BetterFTP.new(@server, @user, @password)
      end
    end
    true
  rescue SocketError
    puts " ## [FAIL] Unable to open connection to server.".red
    false
  rescue Timeout::Error
    puts " ## [TIMEOUT] Failed to connect to server.".red
    @ftp.close
    @ftp = nil
    false
  end

  def self.close_connection
    if @ftp
      puts " ## Connection closing".red
      @ftp.close
    end
  end

end


# Monkey patching the string class for easy colors (you mad?)
class String
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def pink
    colorize(35)
  end
end

require 'net/ftp'

class BetterFTP < Net::FTP

  attr_accessor :port
  attr_accessor :public_ip
  alias_method  :cd, :chdir
  attr_reader :home

  def initialize(host = nil, user = nil, passwd = nil, acct = nil)
    super
    @host = host
    @user = user
    @passwd = passwd
    @acct = acct
    @home = self.pwd
    initialize_caches
  end

  def initialize_caches
    @created_paths_cache = []
    @deleted_paths_cache = []
  end

  def connect(host, port = nil)
    port ||= @port || FTP_PORT
    if @debug_mode
      print "connect: ", host, ", ", port, "\n"
    end
    synchronize do
      initialize_caches
      @sock = open_socket(host, port)
      voidresp
    end
  end

  def reconnect!
    if @host
      connect(@host)
      if @user
        login(@user, @passwd, @acct)
      end
    end
  end

  def directory?(path)
    chdir(path)

    return true
  rescue Net::FTPPermError
    return false
  end

  def file?(path)
    chdir(File.dirname(path))

    begin
      size(path)
      return true
    rescue Net::FTPPermError
      return false
    end
  end

  def mkdir_p(dir)
    made_path = false

    parts = dir.split("/")
    if parts.first == "~"
      growing_path = ""
    else
      growing_path = "/"
    end
    for part in parts
      next if part == ""
      if growing_path == ""
        growing_path = part
      else
        growing_path = File.join(growing_path, part)
      end
      unless @created_paths_cache.include?(growing_path)
        begin
          mkdir(growing_path)
          chdir(growing_path)
          made_path = true
        rescue Net::FTPPermError, Net::FTPTempError
        end
        @created_paths_cache << growing_path
      else
      end
    end

    made_path
  end

  def rm_r(path)
    return if @deleted_paths_cache.include?(path)
    @deleted_paths_cache << path
    if directory?(path)
      chdir path

      begin
        files = nlst
        files.each {|file| rm_r "#{path}/#{file}"}
      rescue Net::FTPTempError
        # maybe all files were deleted already
      end

      rmdir path
    else
      rm(path)
    end
  end

  def rm(path)
    chdir File.dirname(path)
    delete File.basename(path)
  end

private

  def makeport
    sock = TCPServer.open(@sock.addr[3], 0)
    port = sock.addr[1]
    host = @public_ip || sock.addr[3]
    sendport(host, port)
    return sock
  end

end



if __FILE__ == $0
  Harmony.start(ARGV)
end
