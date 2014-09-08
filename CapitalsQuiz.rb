require 'json'
require 'csv'
require 'rest-client'

class Quiz
	
	def initialize		
		@codes  = CSV.read('countrycodes.csv').flatten
		@rnd = rand(@codes.length)
		@country_code = @codes[@rnd]
		@URL = "http://api.worldbank.org/countries/#{@country_code}?format=json"
		print "Getting next question...(#{@country_code})\n"
		@response = RestClient.get @URL
		while @response.nil? do
			@response = RestClient.get @URL
		end
		@jsonData = JSON.parse(@response)
		@country = @jsonData[1][0]["name"]
		if @jsonData[1][0]["capitalCity"].nil?
			@capital = "SKIP"
			print "#{@country} does not have a capital city. Type SKIP"
		else 
			@capital =  @jsonData[1][0]["capitalCity"]
		end
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
