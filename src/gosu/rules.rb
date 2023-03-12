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
  end
end
