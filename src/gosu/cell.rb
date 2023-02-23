# frozen_string_literal: true

require File.expand_path("constants", File.dirname(__FILE__))

module Game
  class Cell
    attr_accessor :x_coordinate, :y_coordinate, :size

    def initialize(x_coordinate, y_coordinate, size: Constants::ENTITY_SIZE)
      @x_coordinate = x_coordinate
      @y_coordinate = y_coordinate
      @size = size
    end

    def draw
      Gosu.draw_rect(x_coordinate, y_coordinate, @size, @size, Gosu::Color::BLACK)
      Gosu.draw_line(x_coordinate, y_coordinate, Gosu::Color::WHITE, x_coordinate + @size, y_coordinate, Gosu::Color::WHITE)
      Gosu.draw_line(x_coordinate, y_coordinate, Gosu::Color::WHITE, x_coordinate, y_coordinate + @size, Gosu::Color::WHITE)
      Gosu.draw_line(x_coordinate + @size, y_coordinate, Gosu::Color::WHITE, x_coordinate + @size, y_coordinate + @size, Gosu::Color::WHITE)
      Gosu.draw_line(x_coordinate, y_coordinate + @size, Gosu::Color::WHITE, x_coordinate + @size, y_coordinate + @size, Gosu::Color::WHITE)
    end
  end
end
