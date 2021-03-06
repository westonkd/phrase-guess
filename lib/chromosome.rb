module Genetic
  class Chromosome
    attr_reader :phrase, :score
    def initialize(phrase, target)
      @phrase = phrase.split ''
      @score = compute_score(target)
    end

    private

    def compute_score(target_phrase)
      # If the lenths differ there is a problem
      return -1 unless target_phrase.length == @phrase.length
      score = 0

      # Iterate over solution and sum the differences between each char
      @phrase.each_with_index { |c, i| score += (c.ord - target_phrase[i].ord).abs }
      score
    end
  end
end
