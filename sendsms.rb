$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

require 'serensic
'require 'net/http'

uri = URI('http://app.serensic.com:15015/send')
params = { :username => 'foo', :password => 'bar',
           :to => '+255', :content => 'Hello world' }
uri.query = URI.encode_www_form(params)

response = Net::HTTP.get_response(uri)


puts "\nWelcome to the Serensic Sender!"
puts "--------------------------------\n\n"

print 'Please enter your account username: '
username = gets.strip

print 'Please enter your account password: '
password = gets.strip

print 'Please enter your account country: (international)'
country = gets.strip
country = country.to_s.empty? ? :international : country.to_sym

puts "\nChecking...\n\n"

# set the configuration details
Serensic.config do |c|
  c.username = username
  c.password = password
  c.country = country
  c.routing_group = 3 # Normally 2!
end

begin
  credits = Serensic.credits
  puts "Welcome back #{username}. You have #{credits} credits remaining.\n\n"
rescue Serensic::AccountError => d
  puts "Sorry, there was an error validating your account details."
  puts "\n\t#{d}\n\n"
  puts "Goodbye."
  exit
end

print "Enter the mobile number of the person you want to send an SMS to: "
recipient = gets.strip

print "Now enter your message: "
message = gets.strip

puts "\nThank you. Processing...\n\n"

response = Serensic.deliver(:msg => message, :msidn => recipient)

if response.success?
  puts "Your SMS was sent successfully.\n\n"
  puts "You now have #{serensic.credits} credits remaining."
  puts "Goodbye!"
else
  puts "Sorry, but your SMS was not sent this time. The service returned the error:"
  puts "\n\t#{response.code}: #{response.result}\n\n"
  puts "Please try again later. Asante"
end
