# frozen_string_literal: true

module Game
  class Grid
    attr_reader :x_coordinate, :y_coordinate, :width, :height

    def initialize(x_coordinate, y_coordinate, width, height)
      @x_coordinate = x_coordinate
      @y_coordinate = y_coordinate
      @width = width
      @height = height
    end

    def intersect?(range)
      !(range.x_coordinate - range.width > @x_coordinate + @width ||
        range.x_coordinate + range.width < @x_coordinate - @width ||
        range.y_coordinate - range.height > @y_coordinate + @height ||
        range.y_coordinate + range.height < @y_coordinate - @height)
    end

    def contain?(point)
      point.x_coordinate >= @x_coordinate - @width &&
        point.x_coordinate <= @x_coordinate + @width &&
        point.y_coordinate >= @y_coordinate - @height &&
        point.y_coordinate <= @y_coordinate + @height
    end
  end
end
