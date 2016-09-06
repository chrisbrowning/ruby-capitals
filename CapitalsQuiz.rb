require 'json'
require 'csv'
require 'rest-client'
require 'levenshtein'

class Quiz

	# load world bank api data into array
	def load_data()
		country_count = 300
		@URL = "http://api.worldbank.org/countries/all/?format=json&per_page=#{country_count}"
		response = RestClient.get @URL
		json_response = JSON.parse(response)[1]
		country_data = []
		json_response.each do |country|
			country_data << country
		end
	end

	# display question based on data
	def answer_question(data)
		country = data["name"]
		capital = data["capitalCity"]
		unless capital == ""
			puts "What is the capital of #{country}?\n"
			guess = gets.chomp

      # abort program if "EXIT"
			if guess == "EXIT"
			  abort("Bye!")
			end

			# handle blank answers
			if guess == ""
				puts "Incorrect! The capital of #{country} is #{capital}\n"
				return false
			end

			# allows up to 2 incorrect letters in answer
			# lower each string, and remove non-alphanumerics
			if Levenshtein.distance(guess.downcase.gsub(/[^a-z0-9\s]/i), capital.downcase.gsub(/[^a-z0-9\s]/i)) < 3
				puts "Correct!\n"
				return true
			else
				puts "Incorrect! The capital of #{country} is #{capital}\n"
				return false
			end
		else
			# do nothing
		end
	end

	def start_quiz()
		puts "Welcome!...type EXIT to end quiz"
		questions_asked = 0
		questions_right = 0
		counter = 0
		country_data = load_data()
		# go forever
		while 1==1
			rand_index = rand(country_data.length-1)
			if_correct = answer_question(country_data[rand_index])
			# controls for situations when no capital exists
			unless if_correct.nil?
				questions_asked += 1
				counter += 1
				if if_correct
					questions_right += 1
				end
				# performance tracking
				amt_right = questions_right.fdiv(questions_asked)*100
				puts "So far you have #{amt_right}% right!" if questions_asked % 5 == 0
			end
		end
	end
end

puts "Start quiz? y/n"
yn = gets.chomp
if yn.casecmp('y')
		Quiz.new.start_quiz
else
	abort("Bye!")
end
