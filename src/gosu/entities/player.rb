# frozen_string_literal: true

module Game
  class Player < Entity
    attr_reader :room

    def initialize(window)
      super(window, 1, 1)
      @room = nil
      @blocked_camera = false
    end

    def outside?
      return false unless room?

      @room&.grid&.contain?(grid)
    end

    def move(direction)
      @blocked_camera = false unless room?
      x_direction = case direction
                    when :left
                      @x_coordinate - 4
                    when :right
                      @x_coordinate + 4
                    else
                      @x_coordinate
                    end
      y_direction = case direction
                    when :forward
                      @y_coordinate - 4
                    when :backward
                      @y_coordinate + 4
                    else
                      @y_coordinate
                    end
      next_state = Entity.new(@window, @width, @height).warp(x_direction, y_direction)
      qtree = @window.quad_tree.dup
      qtree.insert(next_state)
      next_state.grid.draw
      overlapping = qtree.query(next_state.grid).reject { |e| e == self || e == next_state }
      if overlapping.empty?
        warp(x_direction, y_direction)
        true
      else
        overlapping = overlapping.first
        x_coordinate = case direction
                       when :left
                         overlapping.x_coordinate + overlapping.width
                       when :right
                         overlapping.x_coordinate - width
                       else
                         @x_coordinate
                       end
        y_coordinate = case direction
                       when :forward
                         overlapping.y_coordinate + overlapping.height
                       when :backward
                         overlapping.y_coordinate - height
                       else
                         @y_coordinate
                       end
        warp(x_coordinate, y_coordinate)
      end
    end

    def enter(room) = @room = room
    def leave = @room = nil
    def room? = !@room.nil?
    def draw = Gosu.draw_rect(@x_coordinate, @y_coordinate, @width, @height, Gosu::Color::RED, 0)
  end
end
