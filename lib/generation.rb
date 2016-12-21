require './chromosome'

module Genetic
  class Generation
    attr_reader :size, :target, :chromosomes, :t_size
    def initialize(target, size = 50, chromosomes = nil, tournament_size = 5)
      @target = target
      @size = size
      @chromosomes = chromosomes || Array.new(size)
      @t_size = tournament_size
      populate unless chromosomes
    end

    def crossover(parent_one, parent_two)
      # Get the phrase arrays
      p1_phrase = parent_one.phrase
      p2_phrase = parent_two.phrase
      child_phrase = p1_phrase

      # There is a problem if the lengths don't match up
      return parent_one if p1_phrase.join.length != p2_phrase.join.length

      # Choose an index to start the swap
      swap_start = rand(p1_phrase.length - 1)

      # Swap
      (swap_start..@target.length).each { |i| child_phrase[i] = p2_phrase[i] }
      Chromosome.new(child_phrase.join, @target)
    end

    def mutate(chromosome)
      # Choose a character to mutate
      mutate_index = rand(chromosome.phrase.length)

      # Get the array
      phrase = chromosome.phrase

      # Increment the chosen character
      phrase[mutate_index] = phrase[mutate_index].tr('0-9a-z', '1-9a-z0')
      Chromosome.new(phrase.join, @target)
    end

    def select_parent
      # Create a tournament pool
      t_generation = Genetic::Generation.new(@target, @t_size, @chromosomes.sample(t_size))

      # Pick the fittest solution from the pool
      t_generation.best_chromosome
    end

    def best_chromosome
      best_c = nil
      best_s = Float::INFINITY
      @chromosomes.each do |c|
        if c.score < best_s
          best_s = c.score
          best_c = c
        end
      end
      best_c
    end

    private

    def populate
      @target.length.times do
        @chromosomes = @chromosomes.map { Chromosome.new(random_string, @target) }
      end
    end

    def random_string
      (0...@target.length).map { (65 + rand(26)).chr }.join.downcase
    end
  end
end
