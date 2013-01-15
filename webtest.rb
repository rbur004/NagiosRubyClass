require 'net/http'
 
Net::HTTP.start('www.wikarekare.org') do |http| 
  req = Net::HTTP::Get.new('/')
  #req.basic_auth 'admin', 'xxxxxx'
  response = http.request(req) 
  puts "Code = #{response.code}" 
  puts
  puts "Message = #{response.message}" 
  puts
  response.each {|key, val| printf "%-14s = %-40.40s\n", key, val } 
  puts
  puts
  p response.body 
end 


