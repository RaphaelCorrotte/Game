# frozen_string_literal: true

module Game
  class Entity
    attr_reader :window, :width, :height
    attr_accessor :x_coordinate, :y_coordinate

    def initialize(window, width = Constants::ENTITY_SIZE, height = Constants::ENTITY_SIZE)
      @window = window
      @width = width.abs < Constants::ENTITY_SIZE ? Constants::ENTITY_SIZE : width.abs - (width.abs % Constants::ENTITY_SIZE)
      @height = height.abs < Constants::ENTITY_SIZE ? Constants::ENTITY_SIZE : height.abs - (height.abs % Constants::ENTITY_SIZE)
      warp(0, 0)
    end

    def warp(x_coordinate, y_coordinate)
      @x_coordinate = x_coordinate
      @y_coordinate = y_coordinate
    end

    def grid
      Grid.new(@x_coordinate, @y_coordinate, @width, @height)
    end

    def draw
      Gosu.draw_rect(@x_coordinate, @y_coordinate, @width, @height, Gosu::Color::WHITE)
    end
  end
end
