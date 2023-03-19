# frozen_string_literal: true

require "gosu"
require "rmagick"
require File.expand_path("rules", File.dirname(__FILE__))
require File.expand_path("cells", File.dirname(__FILE__))
require File.expand_path("constants", File.dirname(__FILE__))
require File.expand_path("quadtree", File.dirname(__FILE__))
require File.expand_path("grid", File.dirname(__FILE__))
require File.expand_path("camera", File.dirname(__FILE__))
require File.expand_path("tile_sheet", File.dirname(__FILE__))
require File.expand_path("room", File.dirname(__FILE__))
require File.expand_path("entities/player", File.dirname(__FILE__))

module Game
  class Window < Gosu::Window
    attr_reader :rules, :player, :camera

    def initialize
      super(Gosu.screen_width, Gosu.screen_height, Hash[resizable: true])
      @rules = Rules.new(self)
      10.times { @rules.add_entity(1, 1) }
      @rules.entities.each do |e|
        rand_x = rand(width - 64)
        rand_y = rand(height - 64)
        (rand_x % 32).zero? ? rand_x : rand_x - (32 + rand_x % 32)
        (rand_y % 32).zero? ? rand_y : rand_y - (32 + rand_y % 32)
        e.warp(rand_x, rand_y)
      end
      @player = @rules.add_entity(Player.new(self))
      @player.warp((width / 2) - @player.width / 2, (height / 2))
      @camera = Camera.new(self)
      @image = Gosu::Image.new("images/tilesheet.png").subimage(0, 0, 32, 32)
      room = Room.new(self, 1000, 500)
      @player.enter(room)
    end

    def draw
      @player.room&.define_position(@player)
      Gosu.translate(-@camera.grid.x_coordinate, -@camera.grid.y_coordinate) do
        @player.room&.draw(@image)
        @player.room&.entities&.each(&:draw)
        @player.draw
      end
    end

    def update
      @player.x_coordinate -= 5 if Gosu.button_down?(Gosu::KB_LEFT) && allowed_next_move?(@player, :left)
      @player.x_coordinate += 5 if Gosu.button_down?(Gosu::KB_RIGHT) && allowed_next_move?(@player, :right)
      @player.y_coordinate += 5 if Gosu.button_down?(Gosu::KB_DOWN) && allowed_next_move?(@player, :backward)
      @player.y_coordinate -= 5 if Gosu.button_down?(Gosu::KB_UP) && allowed_next_move?(@player, :forward)
      @player.warp(@player.x_coordinate, @player.y_coordinate)
      @camera.update(self)
    end

    def quad_tree(entities = @camera.displayed_entities, grid = nil)
      if entities.empty?
        return grid ? QuadTree.new(grid, 4) : QuadTree.new(Grid.new(0, 0, width, height), 4)
      end

      min_x = entities.map(&:x_coordinate).min
      min_y = entities.map(&:y_coordinate).min
      max_x = entities.map { |e| e.x_coordinate + e.width }.max
      max_y = entities.map { |e| e.y_coordinate + e.height }.max
      grid ||= Grid.new(min_x, min_y, (max_x - min_x), (max_y - min_y))
      qtree = QuadTree.new(grid, 4)
      entities.each { |e| qtree.insert(e) }
      qtree
    end

    def entity_over_entity(entity, grid = nil)
      entities = @rules.entities.reject { |e| e == entity || e <= Cell }
      qtree = quad_tree(entities, grid)
      qtree.query(Grid.new(entity.x_coordinate, entity.y_coordinate, entity.width, entity.height))
    end

    def allowed_next_move?(entity, next_move)
      next_entity = entity.dup
      entities = @rules.entities.reject { |e| e == entity || e == next_entity }
      case next_move
      when :forward
        next_entity.y_coordinate -= 5
      when :backward
        next_entity.y_coordinate += 5
      when :left
        next_entity.x_coordinate -= 5
      when :right
        next_entity.x_coordinate += 5
      else
        return false
      end
      quad_tree(entities).query(Grid.new(next_entity.x_coordinate, next_entity.y_coordinate, next_entity.width, next_entity.height)).empty?
    end
  end
end
