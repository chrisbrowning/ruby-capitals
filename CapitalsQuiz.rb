require 'json'
require 'csv'
require 'rest-client'

class Quiz
	
	def initialize		
		@codes  = CSV.read('countrycodes.csv').flatten
		@rnd = rand(@codes.length)
		@country_code = @codes[@rnd]
		@URL = "http://api.worldbank.org/countries/#{@country_code}?format=json"
		@response = RestClient.get @URL
		@jsonData = JSON.parse(@response)
		@capital =  @jsonData[1][0]["capitalCity"]
		@country = @jsonData[1][0]["name"]

	end
	
	def question 
		puts "What is the capital of #{@country}?"
		@guess = gets.chomp
		if @guess == @capital
			print "Correct!\n"
		elsif @guess == "QUIT"
			abort("Bye!")	
		else	
			print "Wrong! #{@country}'s capital is #{@capital}\n"
		end
	end
end

puts "Start quiz? y/n"
yn = gets.chomp
if yn == 'y' || yn == 'Y'
	until 1==2 do
		Quiz.new.question
	end
else
	abort("Bye!")
end
