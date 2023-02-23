# frozen_string_literal: true

require "singleton"
require File.expand_path("constants", File.dirname(__FILE__))

module Game
  class Matrix
    BITWISE = Hash[]
    include Singleton

    def grid
      @grid ||= Array.new(Constants::ENTITIES_ROW) { Array.new(Constants::ENTITIES_ROW) { 0 } }
    end

    def select(x_coordinate, y_coordinate)
      grid[x_coordinate][y_coordinate]
    end

    def []=(x_coordinate, y_coordinate, value)
      grid[x_coordinate][y_coordinate] = value
    end

    def update_grid
      ""
    end

    alias [] select
  end
end
