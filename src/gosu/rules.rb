# frozen_string_literal: true

require "gosu"
require File.expand_path("entities/entity", File.dirname(__FILE__))
require File.expand_path("constants", File.dirname(__FILE__))

module Game
  class Rules
    attr_reader :window, :entities

    def initialize(window)
      @window = window
      @entities = []
    end

    def add_entity(*entity)
      @entities << if entity[0].class <= Entity
                     entity[0]
                   else
                     Entity.new(@window, entity[0], entity[1])
                   end
      @entities[-1]
    end

    def find_entities(x_coordinate, y_coordinate)
      @entities.select do |entity|
        entity.x_coordinate[0].between?(x_coordinate[0], x_coordinate[1]) && entity.y_coordinate[0].between?(y_coordinate[0], y_coordinate[1])
      end
    end

    def entities_around(entity)
      [-1, 0, 1].repeated_permutation(2).reject { |x, y| (x.zero? && y.zero?) }.map do |x, y|
        find_entities([entity.x_coordinate[0] + x, entity.x_coordinate[1] + x], [entity.y_coordinate[0] + y, entity.y_coordinate[1] + y])
      end
    end

    def cell_count
      [(Gosu.screen_width / Constants::ENTITY_SIZE).floor, (Gosu.screen_height / Constants::ENTITY_SIZE).floor]
    end

    def cell_size = CONSTANTS::ENTITY_SIZE
  end
end
