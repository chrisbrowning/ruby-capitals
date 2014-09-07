require 'json'
require 'csv'
require 'rest-client'

codes  = CSV.read('countrycodes.csv').flatten
rnd = rand(codes.length)
country = codes[rnd]
URL = "http://api.worldbank.org/countries/#{country}?format=json"
response = RestClient.get URL
jsonData = JSON.parse(response)
capital =  jsonData[1][0]["capitalCity"]
country = jsonData[1][0]["name"]
puts "What is the capital of #{country}?"
guess = gets.chomp

if guess == capital
print "Correct!"
else
print "Wrong!"
end
