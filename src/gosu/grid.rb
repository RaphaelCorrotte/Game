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
      point.x_coordinate.between?(@x_coordinate - point.width, @x_coordinate + @width) &&
        point.y_coordinate.between?(@y_coordinate - point.height, @y_coordinate + @height)
    end

    # draw lines around the grid in different colors
    def draw
      Gosu.draw_line(@x_coordinate + 5, @y_coordinate + 5, Gosu::Color::RED, @x_coordinate + @width, @y_coordinate, Gosu::Color::RED)
      Gosu.draw_line(@x_coordinate + 5, @y_coordinate + 5, Gosu::Color::YELLOW, @x_coordinate, @y_coordinate + @height, Gosu::Color::YELLOW)
      Gosu.draw_line(@x_coordinate + @width, @y_coordinate, Gosu::Color::FUCHSIA, @x_coordinate + @width, @y_coordinate + @height, Gosu::Color::FUCHSIA)
      Gosu.draw_line(@x_coordinate, @y_coordinate + @height, Gosu::Color::GREEN, @x_coordinate + @width, @y_coordinate + @height, Gosu::Color::GREEN)
    end
  end
end
