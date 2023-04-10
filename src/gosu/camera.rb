# frozen_string_literal: true

require File.expand_path("grid", File.dirname(__FILE__))

module Game
  class Camera
    LOCK_DISTANCE = 32 * 6
    attr_reader :window, :position

    def initialize(window)
      @window = window
      @position = []
    end

    def displayed_entities
      @window.quad_tree(@window.rules.entities.reject do |e|
        e == @window.player
      end).query(grid)
    end

    def grid
      Grid.new(@window.player.x_coordinate - @window.width / 2,
               (@window.player.y_coordinate + @window.player.height / 2) - @window.height / 2,
               @window.width,
               @window.height)
    end

    def manage_position
      player = @window.player
      p @position
      return unless player.room?
      return @position.clear if player.next_wall.values.first > LOCK_DISTANCE
      @position.clear unless @position[2] == player.next_wall.keys.first
      return unless @position.empty?

      case player.next_wall.keys.first
      when :north
        @position[0] = nil
        @position[1] = -grid.y_coordinate
      when :south
        @position[0] = nil
        @position[1] = -grid.y_coordinate
      when :west
        @position[0] = -grid.x_coordinate
        @position[1] = nil
      when :east
        @position[0] = -grid.x_coordinate
        @position[1] = nil
      end
      @position[2] = player.next_wall.keys.first
    end
  end
end
