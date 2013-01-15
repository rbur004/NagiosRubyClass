#!/usr/local/bin/ruby
require 'net/smtp'  
require 'getoptlong' 
require 'nagios'

class Nagios_SMTP < Nagios
  
  OPTS = [
    ["--smtp_to", GetoptLong::REQUIRED_ARGUMENT], #argument timeout
    ["--smtp_from",  GetoptLong::REQUIRED_ARGUMENT], #argument warning-threshold 
    ["--smtp_domain",  GetoptLong::REQUIRED_ARGUMENT], #argument critical-threshold     
  ]
  
  OPT_ARGS = [
      "to-address",
      "from-address", 
      "default-domain", 
    ]
    
  def initialize
    #local defaults
    @version = "1.1"
    @logname = 'sci9001' 
    @authentication = 'h#t6ik5p'
    @port = 465
    @hostname = 'smtp.fos.auckland.ac.nz'
    
    super(OPTS, OPT_ARGS)
    
    #Additional things we need to define
    @smtp_default_domain = 'sit.auckland.ac.nz'
    @smtp_from_address = "scie9001@sit.auckland.ac.nz"
    @smtp_to_address = "scie9001@sit.auckland.ac.nz"
    @sequence = next_sequence;
    @smtp_email = "From: scie9001@sit.auckland.ac.nz
Subject: Sequence #{@sequence}

Created '#{Time.now}'
Port #{@port}
"
  end
 
 def next_sequence
 end
 
 def current_sequence
 end
 
 def run
   # handling exceptions  
   begin  
    smtp = Net::SMTP.new(@hostname, @port)
    smtp.enable_ssl #Not in Ruby 1.8.6 Library? Works in older and newer versions
    #smtp.set_debug_output $stderr
    #smtp.open_timeout = 
    #smtp.read_timeout = 
    smtp.start(@smtp_default_domain, @logname, @authentication, 'plain') do |smtpclient|
      smtpclient.send_message(@smtp_email, @smtp_from_address, @smtp_to_address)  
    end
    puts "SERVICE STATUS: OK. Connection #{port}\n"
   rescue Exception => e  
     print "Exception occured: " + e  
     exit(UNKNOWN)
   end
  end
end

n = Nagios_SMTP.new
print n
n.run

