# frozen_string_literal: true

require File.expand_path("grid", File.dirname(__FILE__))

module Game
  class Camera
    attr_reader :window

    def initialize(window)
      @window = window
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

    def update(window)
      @window = window
    end
  end
end
