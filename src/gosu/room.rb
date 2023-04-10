# frozen_string_literal: true

require File.expand_path("entities/cell", File.dirname(__FILE__))

module Game
  class Room < Grid
    attr_reader :window, :width, :height, :x_coordinate, :y_coordinate

    def initialize(window, width, height)
      @window = window
      super(0, 0, (width % 32).zero? ? width : width + (32 - width % 32), (height % 32).zero? ? height : height + (32 - height % 32))
      define_position(@window.player)
    end

    def cells
      grid = Grid.new(0, 0, @width, @height)
      cells = []
      (0..@width / 32).each do |x|
        (0..@height / 32).each do |y|
          cells << Cell.new(x * 32, y * 32)
        end
      end
      @window.quad_tree(cells, grid)
    end

    def define_position(player)
      x_coordinate = player.x_coordinate - @width / 2
      y_coordinate = player.y_coordinate - @height / 2
      @x_coordinate = (x_coordinate % 32).zero? ? x_coordinate : x_coordinate - (32 - x_coordinate % 32)
      @y_coordinate = (y_coordinate % 32).zero? ? y_coordinate : y_coordinate - (32 - y_coordinate % 32)
      self
    end

    def entities
      @window.quad_tree.query(Grid.new(@x_coordinate, @y_coordinate, @width, @height))
    end

    def draw(image)
      cells.query.each do |cell|
        image.draw(cell.x_coordinate + @x_coordinate, cell.y_coordinate + @y_coordinate, 0)
      end
    end

    def boundaries
      Hash[
        north: Grid.new(@x_coordinate, @y_coordinate, @width, 0),
        south: Grid.new(@x_coordinate, @y_coordinate + @height, @width, 0),
        west: Grid.new(@x_coordinate, @y_coordinate, 0, @height),
        east: Grid.new(@x_coordinate + @width, @y_coordinate, 0, @height)
      ]
    end

    private :define_position
  end
end
