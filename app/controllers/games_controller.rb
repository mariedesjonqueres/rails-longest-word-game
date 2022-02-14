require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = ('a'..'z').to_a.sample(10).join(' ')
  end

  def score
    @answer = params[:words]
    search = english_word(@answer)
    @letters = params[:letters]
    if include?(@answer, @letters) == false
      @result = " Sorry but #{@answer} can't be built of #{@letters}"
    elsif search == false && include?(@answer, @letters) == true
      @result = "Sorry but #{@answer} does not seem to be a valid English word."
    else
      @result = "Congratulations #{@answer} is a valid English word."
    end
  end

  def english_word(word)
    response = URI.open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    json['found']
  end

  def include?(answer, letters)
    answer.chars.all? { |letter| answer.count(letter) <= letters.count(letter) }
  end
end
