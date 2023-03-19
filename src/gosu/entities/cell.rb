# frozen_string_literal: true

module Game
  class Cell
    WIDTH = HEIGHT = 32
    attr_reader :x_coordinate, :y_coordinate

    def initialize(x_coordinate, y_coordinate)
      @x_coordinate = x_coordinate
      @y_coordinate = y_coordinate
    end

    def warp(x_coordinate, y_coordinate)
      @x_coordinate = x_coordinate
      @y_coordinate = y_coordinate
    end

    def grid
      Grid.new(@x_coordinate, @y_coordinate, WIDTH, HEIGHT)
    end

    def width = WIDTH
    def height = HEIGHT
  end
end
