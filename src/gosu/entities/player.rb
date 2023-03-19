# frozen_string_literal: true

module Game
  class Player < Entity
    attr_reader :room

    def initialize(window)
      super(window, 1, 1)
    end

    def enter(room)
      @room = room
    end

    def leave
      @room = nil
    end

    def draw
      Gosu.draw_rect(@x_coordinate, @y_coordinate, @width, @height, Gosu::Color::BLUE)
    end
  end
end
