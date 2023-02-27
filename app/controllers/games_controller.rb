require 'open-uri'
# gamescontroller
class GamesController < ApplicationController
  LOSE_A = "You didn't use the correct letters.".freeze
  LOSE_B = 'Your answer is not an english word.'.freeze
  def new
    grid = ('A'..'Z').to_a
    @letters = []
    @letters << grid[rand(0..25)] until @letters.length == 10
  end

  def score
    answer = params[:answer].upcase
    letters = params[:grid].chars
    result_a = grid_valid(answer, letters)
    result_b = word_valid(answer)
    @score = case result_a && result_b
             when true
               "You won with #{answer.length} letters"
             else
               "You lost! #{LOSE_A unless result_a} #{LOSE_B unless result_b}"
             end
  end

  def grid_valid(answer, letters)
    answer.chars.each do |char|
      return false unless letters.include?(char)

      letters.delete_at(letters.index(char))
    end
    true
  end

  def word_valid(answer)
    url = "https://wagon-dictionary.herokuapp.com/#{answer}"
    word_serialized = URI.open(url).read
    word = JSON.parse(word_serialized)
    word['found']
  end
end
