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
  def answer_question(data, mode)
    country = data["name"]
    capital = data["capitalCity"]
    unless capital == ""
      if mode == "xmode"
        puts "#{capital} is the capital of what country?\n"
      else
        puts "What is the capital of #{country}?\n"
      end
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
      if mode == "xmode"
        leven_distance = Levenshtein.distance(guess.downcase.gsub(/[^A-Za-z0-9\s]/i,''), country.downcase.gsub(/[^A-Za-z0-9\s]/i,''))
      else
			  leven_distance = Levenshtein.distance(guess.downcase.gsub(/[^A-Za-z0-9\s]/i,''), capital.downcase.gsub(/[^A-Za-z0-9\s]/i,''))
      end
      if leven_distance < 3 && leven_distance > 0
        if mode == "xmode"
          puts "Your answer was off but we'll accept it! #{capital} is the capital of #{country}\n"
        else
				  puts "Your answer was off but we'll accept it! The capital of #{country} is #{capital}\n"
        end
        return true
			elsif leven_distance == 0
				  puts "Correct!\n"
					return true
      else
        if mode == "xmode"
          puts "Incorrect! #{capital} is the capital of #{country}\n"
        else
          puts "Incorrect! The capital of #{country} is #{capital}\n"
        end
        return false
      end
  else
    # do nothing
  end
end

  def start_quiz(mode)
    puts "Welcome!...type EXIT to end quiz"
    questions_asked = 0
    questions_right = 0
    counter = 0
    country_data = load_data()
    country_data.shuffle!
    # go forever
    for c in country_data
      country_for_question = country_data.pop
      if_correct = answer_question(country_for_question, mode)

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
  abort("All countries asked! You got #{amt_right} right!")
  end
end

puts "Start quiz? y/n... or x"
yn = gets.chomp
if yn == 'y' || yn == 'Y'
  Quiz.new.start_quiz(nil)
elsif yn = 'x'  || yn == 'X'
  Quiz.new.start_quiz("xmode")
else
  abort("Bye!")
end
