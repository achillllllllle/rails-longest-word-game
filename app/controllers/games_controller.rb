require "json"
require "open-uri"

class GamesController < ApplicationController
  def new
    @start_time = Time.now
    @array = []
    alphabet = ('A'..'Z').to_a
    for i in 0..10 do
      @array.push(alphabet.sample(1))
    end
  end

  def score
    check = true
    list = params["array"].split('')
    @reponse = params["reponse"].split('')
    @reponse.each do |letter|
      unless list.include?(letter)
        @message = "Sorry but #{@reponse.join.upcase} can't be built out of #{params["array"]}"
        check = false
      else
        list.delete_at(list.find_index(letter))
      end
    end
    if check
      url = "https://wagon-dictionary.herokuapp.com/#{params['reponse']}"
      word_serialized = URI.open(url).read
      word = JSON.parse(word_serialized)
      unless word["found"]
        @message = "Sorry but #{@reponse.join.upcase} does not seem to be a valid English word..."
      else
        @message = "Congratulations ! #{@reponse.join.upcase} is a valid English word!"
      end
    end
    flash[:score] = "SCORE"
  end
end
