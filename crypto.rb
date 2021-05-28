require 'base64'

module Crypto
    PASS_FILE = "#{ENV['HOME']}/.pwmcli/passwd"

    def Crypto.encrypt_line (to_encrypt)
        cipher = OpenSSL::Cipher.new("AES-256-CBC")
        cipher.encrypt
        cipher.key = get_password("Enter Password to Encrypt:")
        cipher.iv = Base64.decode64("xZV1H8GvUiM/JbhErPijjg==") #To Be Changed
        encrypted = cipher.update(to_encrypt) + cipher.final
    end

    def Crypto.encrypt_string(data)
        encrypted = encrypt_line(data)
        File.open "#{PASS_FILE}", "a+" do |line| 
            line.puts(encrypted)
        end
    end

    def Crypto.decipher_line (encrypted_line, password)

        decipher = OpenSSL::Cipher.new("AES-256-CBC")
        decipher.decrypt
        decipher.key = password
        iv = Base64.decode64("xZV1H8GvUiM/JbhErPijjg==") #To Be Changed
        decipher.iv = iv
        plain_text = decipher.update(encrypted_line)
    end

    def Crypto.decrypt_file(h_array,password)
        temp_array = Array.new   
        File.foreach("#{PASS_FILE}") do |line|
            plain = decipher_line(line, password)
            split_plain = plain.split(',')
            split_plain.each { |word| temp_array.push(word)}
            add_to_hash_array(h_array,temp_array)
            temp_array.clear
        end
    end

    def Crypto.get_password(instruction)    
        cipher = OpenSSL::Cipher::AES.new(256, :CBC)
        puts "#{instruction}".bold.red.blink

        pwd = $stdin.noecho(&:gets).chomp

        salt = Base64.decode64("CsIktLdJltDHkpK8ZAeIFA==") #To Be Changed
        iter = 20000
        key_len = cipher.key_len
        digest = OpenSSL::Digest.new('SHA256')

        key = OpenSSL::PKCS5.pbkdf2_hmac(pwd, salt, iter, key_len, digest)
    end

    def Crypto.add_to_hash_array(h_array, temp_array)
        site_info = {
            :Site => temp_array[0],
            :Username => temp_array[1],
            :Password => temp_array[2],
            :DateAdded => temp_array[3],
            :LastModified => temp_array[4]
        }
        h_array.push(site_info)
    end

    def Crypto.decrypt(h_array)
        password = get_password("Enter Password to Decrypt!")
        decrypt_file(h_array,password)
    end
end