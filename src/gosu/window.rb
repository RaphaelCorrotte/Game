# frozen_string_literal: true

require "gosu"
require File.expand_path("rules", File.dirname(__FILE__))
require File.expand_path("cell", File.dirname(__FILE__))
require File.expand_path("constants", File.dirname(__FILE__))
require File.expand_path("quadtree", File.dirname(__FILE__))
require File.expand_path("grid", File.dirname(__FILE__))
require File.expand_path("camera", File.dirname(__FILE__))
require File.expand_path("entities/player", File.dirname(__FILE__))

module Game
  class Window < Gosu::Window
    attr_reader :rules, :player, :camera

    def initialize
      super(Gosu.screen_width, Gosu.screen_height, Hash[resizable: true])
      @rules = Rules.new(self)
      120.times { @rules.add_entity(1, 1) }
      @rules.entities.each { |e| e.warp(rand(width - 64), rand(height - 64)) }
      @player = @rules.add_entity(Player.new(self))
      @player.warp((width / 2) - @player.width / 2, (height / 2))
      @camera = Camera.new(self)
    end

    def draw
      Gosu.translate(-@camera.grid.x_coordinate, -@camera.grid.y_coordinate) do
        @rules.entities.reject { |e| e == @player }.each do |e|
          Gosu.draw_rect(e.x_coordinate, e.y_coordinate, e.width, e.height, Gosu::Color::FUCHSIA)
        end
        @camera.displayed_entities.each(&:draw)
        Gosu.draw_line(@camera.grid.x_coordinate, @camera.grid.y_coordinate, Gosu::Color::RED, @player.x_coordinate, @player.y_coordinate, Gosu::Color::RED, 1)
        @player.draw
        if (qtree = quad_tree)
          qtree.draw
          p qtree.query(@camera.grid).count
        end
        @camera.grid.draw
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
      return false if entities.empty?

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
      entities = @rules.entities.reject { |e| e == entity }
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
