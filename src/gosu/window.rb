# frozen_string_literal: true

require "gosu"
require File.expand_path("rules", File.dirname(__FILE__))
require File.expand_path("cell", File.dirname(__FILE__))
require File.expand_path("matrix", File.dirname(__FILE__))
require File.expand_path("constants", File.dirname(__FILE__))
require File.expand_path("quadtree", File.dirname(__FILE__))
require File.expand_path("grid", File.dirname(__FILE__))
require File.expand_path("entities/player", File.dirname(__FILE__))

module Game
  class Window < Gosu::Window
    attr_reader :rules, :matrix

    def initialize
      super(Gosu.screen_width, Gosu.screen_height, Hash[resizable: true])
      self.caption = "Game"
      @rules = Rules.new(self)
      @matrix = Matrix.instance
      6.times { @rules.add_entity(1, 1) }
      @rules.entities.each { |e| e.warp(rand(Gosu.screen_width - 300), rand(Gosu.screen_height - 300)) }
      @player = @rules.add_entity(Player.new(self))
      @player.warp(12, 12)
      @highlighted = false
    end

    def draw
      @rules.entities.each(&:draw)
    end

    def update
      @player.x_coordinate -= 5 if Gosu.button_down?(Gosu::KB_LEFT)
      @player.x_coordinate += 5 if Gosu.button_down?(Gosu::KB_RIGHT)
      @player.y_coordinate += 5 if Gosu.button_down?(Gosu::KB_DOWN)
      @player.y_coordinate -= 5 if Gosu.button_down?(Gosu::KB_UP)
      @player.warp(@player.x_coordinate, @player.y_coordinate)
      quadtree
    end

    def entity_over_cell(entity)
      @cells.reject { |e| e == @player }.find do |cell|
        entity.x_coordinate.between?(cell.x_coordinate, cell.x_coordinate + cell.size) &&
          entity.y_coordinate.between?(cell.y_coordinate, cell.y_coordinate + cell.size)
      end
    end

    def quadtree
      entities = @rules.entities.reject { |e| e == @player }
      min_x = entities.map(&:x_coordinate).min
      min_y = entities.map(&:y_coordinate).min
      max_x = entities.map { |e| e.x_coordinate + e.width }.max
      max_y = entities.map { |e| e.y_coordinate + e.height }.max
      grid = Grid.new(min_x, min_y, (max_x - min_x), (max_y - min_y))
      qtree = QuadTree.new(grid, 4)
      entities.each { |e| qtree.insert(e) }
      p qtree.entities_count
    end
  end
end
