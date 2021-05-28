#!/usr/bin/env ruby 

require 'openssl'
require 'io/console'
require './crypto'

#Move to customize..
class String
    def red;            "\e[31m#{self}\e[0m" end
    def green;          "\e[32m#{self}\e[0m" end
#
#
    def bold;           "\e[1m#{self}\e[22m" end
    def blink;          "\e[5m#{self}\e[25m" end
#
end
PASS_DIR = "#{ENV['HOME']}/.pwmcli/"

 def firstrun
     if(!File.directory?(PASS_DIR))
         Dir.mkdir(PASS_DIR)
     end
 end


 def site_search(h_array, site_name)
    h_array.each do |hash|
        hash.each do |key,value|
            if value.to_s == site_name
                puts (hash.each_pair { |k, v| puts "#{k.to_s} : #{v.to_s}".green.bold})
            end
        end
       
    end
 end

def print_hash_array(h_array)
    hash.each do |key,value|
        #puts (key.to_s + ': ' + value.to_s).green.bold
         if value.to_s == site_name
             
             #puts (hash.to_s)
         end
    end
end

def decisions(arg_array, h_array)
    case arg_array[0]
    when "search"
        Crypto::decrypt(h_array)
        site_search(h_array, arg_array[1])
    when "siteinfo"
        
    end

    
end

def main()
    arg_array = ARGV
    h_array = Array.new
    firstrun

    decisions(arg_array, h_array)
    
    
    #encrypt_string("sneksnek.com,hissss,dangernoodle,Test,DATE")
    
    
    #print p_array
end

main