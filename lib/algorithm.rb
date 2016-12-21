require './generation'

module Genetic
  class Algorithm
    attr_reader :gen_count, :gen_size
    attr_accessor :target_phrase
    def initialize(target_phrase, gen_size, gen_count = -1)
      @gen_size = gen_size
      @gen_count = gen_count
      @target_phrase = target_phrase
    end

    def optimize
      # Initialization
      g = Generation.new(@target_phrase, @gen_size)
      gen_count.times do
        puts g.best_chromosome.phrase.join

        next_gen = []

        @gen_size.times do
          # Selection
          p1 = g.select_parent
          p2 = g.select_parent

          # Crossover
          child = g.crossover(p1,p2)

          # Mutation
          mut_prop = rand(0.0..1.0)
          child = g.mutate(child) if (mut_prop < 0.3)

          # Add child to the next generation
          next_gen << child
        end

        g = Generation.new(@target_phrase, @gen_size, next_gen)
      end
    end
  end
end

a = Genetic::Algorithm.new('pandasareawesome', 1500, 50)
a.optimize
