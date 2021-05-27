#!/usr/bin/env ruby 

require 'openssl'
require 'uri'
require 'base64'
require 'csv'
require 'io/console'

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
PASS_FILE = "#{ENV['HOME']}/.pwmcli/passwd"

def firstrun
    if(!File.directory?(PASS_DIR))
        heading = "Site,Username,Password,DateAdded,LastModified"
        Dir.mkdir(PASS_DIR)
         File.open("#{PASS_FILE}", "w") do |header|
             encrypted = encrypt_line(heading)
             header.puts(encrypted)
        end
    end
end


def encrypt_line (to_encrypt)
    cipher = OpenSSL::Cipher.new("AES-256-CBC")
    cipher.encrypt
    cipher.key = get_password("Enter Password to Encrypt:")
    cipher.iv = Base64.decode64("xZV1H8GvUiM/JbhErPijjg==")
    encrypted = cipher.update(to_encrypt) + cipher.final
end

def encrypt_string(data)
    encrypted = encrypt_line(data)
    File.open "#{PASS_FILE}", "a+" do |line| 
        line.puts(encrypted)
    end
end

def decipher_line (encrypted_line, password)

    decipher = OpenSSL::Cipher.new("AES-256-CBC")
    decipher.decrypt
    decipher.key = password
    iv = Base64.decode64("xZV1H8GvUiM/JbhErPijjg==")
    decipher.iv = iv
    plain_text = decipher.update(encrypted_line)
end

def decrypt_file(p_array, password)

    File.foreach("#{PASS_FILE}") do |line|
        plain = decipher_line(line, password)
        split_plain = plain.split(',')
        split_plain.each { |word| p_array.push(word)}
    end
end

def get_password(instruction)    
    cipher = OpenSSL::Cipher::AES.new(256, :CBC)
    puts "#{instruction}".bold.red.blink

    pwd = $stdin.noecho(&:gets).chomp

    salt = Base64.decode64("CsIktLdJltDHkpK8ZAeIFA==")
    iter = 20000
    key_len = cipher.key_len
    digest = OpenSSL::Digest.new('SHA256')

    key = OpenSSL::PKCS5.pbkdf2_hmac(pwd, salt, iter, key_len, digest)
end

def search_by_site(p_array, site_name)
    site_num = 0
    until site_num >= p_array.size
        #puts p_array[site_num]
         if p_array[site_num].include? "#{site_name}"
             puts "Site: #{p_array[site_num]} Username: #{p_array[site_num + 1]} Password: #{p_array[site_num + 2]}".bold.green
         end
        site_num += 5
    end
end

p_array = Array.new
arg_array = ARGV

case arg_array[0]
when "search"
    password = get_password("Enter Passphrase To Decrypt!")
    decrypt_file(p_array,password)
    site_search(p_array,arg_array[1])
when "siteinfo"
    password = get_password("Enter Passphrase To Decrypt!")
    decrypt_file(p_array,password)
    site_search(p_array,arg_array[1])
end

#firstrun
#encrypt_string("sneksnek.com,hissss,dangernoodle,Test,DATE")


#print p_array




