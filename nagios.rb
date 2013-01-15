require 'getoptlong' 

class Nagios
  
  attr_accessor :timeout, :warning, :critical, :hostname, :verbose, :community
  attr_accessor :authentication, :logname, :port, :password, :url, :username
  attr_reader :version
  
  OK = 0
  WARNING = 1
  CRITICAL = 2
  UNKNOWN = 3
   
  def initialize(opts = nil, opt_args = nil, status = nil)
    @opts = [
          ["--version", "-V", GetoptLong::NO_ARGUMENT ],
          ["--help", "-h", GetoptLong::NO_ARGUMENT  ],
          ["--timeout", "-t", GetoptLong::REQUIRED_ARGUMENT], #argument timeout
          ["--warning", "-w", GetoptLong::REQUIRED_ARGUMENT], #argument warning-threshold 
          ["--critical", "-c", GetoptLong::REQUIRED_ARGUMENT], #argument critical-threshold 
          ["--hostname", "-H", GetoptLong::REQUIRED_ARGUMENT], #argument hostname
          ["--verbose", "-v", GetoptLong::OPTIONAL_ARGUMENT], #argument verbose-level
          ["--community", "-C", GetoptLong::REQUIRED_ARGUMENT], #argument SNMP-community
          ["--authentication", "-a", GetoptLong::REQUIRED_ARGUMENT ],#argument authentication-password
          ["--logname", "-l", GetoptLong::REQUIRED_ARGUMENT ],#argument login-name
          ["--port", "-p", GetoptLong::REQUIRED_ARGUMENT ],#argument port 
          ["--password", "--passwd", GetoptLong::REQUIRED_ARGUMENT ],#argument password
          ["--url", "-u", GetoptLong::REQUIRED_ARGUMENT ],#argument url
          ["--username", GetoptLong::REQUIRED_ARGUMENT ],#argument username
          ["--usage", "-?", GetoptLong::NO_ARGUMENT ],
      ]
    
    @opt_args = [ 
        "",                             #["--version", "-V", GetoptLong::NO_ARGUMENT ],
        "",                             #["--help", "-h", GetoptLong::NO_ARGUMENT  ],
        "timeout",                      #["--timeout", "-t", GetoptLong::REQUIRED_ARGUMENT], #argument timeout
        "warning-threshold",            #["--warning", "-w", GetoptLong::REQUIRED_ARGUMENT], #argument warning-threshold 
        "critical-threshold",           #["--critical", "-c", GetoptLong::REQUIRED_ARGUMENT], #argument critical-threshold 
        "hostname",                     #["--hostname", "-H", GetoptLong::REQUIRED_ARGUMENT], #argument hostname
        "[verbose-level (default 0)]",  #["--verbose", "-v", GetoptLong::OPTIONAL_ARGUMENT], #argument verbose-level
        "SNMP-community",               #["--community", "-C", GetoptLong::REQUIRED_ARGUMENT], #argument SNMP-community
        "authentication-password",      #["--authentication", "-a", GetoptLong::REQUIRED_ARGUMENT ],#argument authentication-password
        "login-name",                   #["--logname", "-l", GetoptLong::REQUIRED_ARGUMENT ],#argument login-name
        "port",                         #["--port", "-p", GetoptLong::REQUIRED_ARGUMENT ],#argument port 
        "password",                     #["--passwd", "--password", GetoptLong::REQUIRED_ARGUMENT ],#argument password
        "url",                          #["--url", "-u", GetoptLong::REQUIRED_ARGUMENT ],#argument url
        "username",                     #["--username", GetoptLong::REQUIRED_ARGUMENT ],#argument username
        "",                             #["--usage", "-?", GetoptLong::NO_ARGUMENT ],
      ]

    @status = [:timeout, :warning, :critical, :hostname, :verbose, :community, :authentication, :logname, :port, :password, :url, :username ]
    
    @version = "1.0"
    @verbose = 0
    
    @opts += opts if opts
    @opt_args += opt_args if opt_args
    @status += status if status
    
    process_opts
    
  end
    
    
  def usage
    usage_str = "Arguments:\n"
    @opts.each_with_index do |opt, i|
      usage_str += "\t" + opt[0..-2].join(', ') + "\t#{@opt_args[i]}\n"
    end
    return usage_str
  end
  
  def process_opts
    opts = GetoptLong.new(*@opts)
    begin
      opts.each do |opt, arg|
      	case opt
      	when '--version' then  print "Version #{version}\n"; exit(UNKNOWN)
      	when '--help' then print "Version #{version}\n#{usage}\n"; exit(UNKNOWN)
      	when '--timeout' then @timeout = arg
      	when '--warning' then @warning = arg
      	when '--critical' then @critical = arg
      	when '--hostname' then @hostname = arg
      	when '--verbose' then @verbose = arg
      	when '--community' then @community = arg
      	when '--authentication' then @authentication = arg
      	when '--logname' then @logname = arg
      	when '--port' then @port = arg
      	when '--password' then @password = arg
      	when '--username' then puts "#{usage}\n"; exit(UNKNOWN)
      	when '--usage' then print "#{usage}\n"; exit(UNKNOWN)
      	end
      end
    rescue
      print "#{usage}\n"; exit(UNKNOWN)
    end
  end
  
  def to_s
    r = "Status:\n"
    @status.each do |s|
      r += "\t #{s.to_s.capitalize} = #{self.send(s)}\n"
    end
    return r
  end
  
end

#print Nagios.new

  