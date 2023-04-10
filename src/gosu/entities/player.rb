# frozen_string_literal: true

module Game
  class Player < Entity
    attr_reader :room

    def initialize(window)
      super(window, 1, 1)
      @room = nil
      @blocked_camera = false
    end

    def inside?
      return false unless room?

      @room&.contain?(grid)
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
      overlapping = qtree.query(next_state.grid).reject { |e| e == self || e == next_state }
      if overlapping.empty?
        warp(x_direction, y_direction)
        true
      else
        overlapping = overlapping.first
        x_coordinate = case direction
                       when :left
                         if (@y_coordinate + height) == overlapping.y_coordinate || @y_coordinate == (overlapping.y_coordinate + overlapping.height)
                           @x_coordinate - 4
                         else
                           overlapping.x_coordinate + overlapping.width
                         end
                       when :right
                         if (@y_coordinate + height) == overlapping.y_coordinate || @y_coordinate == (overlapping.y_coordinate + overlapping.height)
                           @x_coordinate + 4
                         else
                           overlapping.x_coordinate - width
                         end
                       else
                         @x_coordinate
                       end
        y_coordinate = case direction
                       when :forward
                         if (overlapping.x_coordinate + overlapping.width) == @x_coordinate || overlapping.x_coordinate == (@x_coordinate + width)
                           @y_coordinate - 4
                         else
                           overlapping.y_coordinate + overlapping.height
                         end
                       when :backward
                         if (overlapping.x_coordinate + overlapping.width) == @x_coordinate || overlapping.x_coordinate == (@x_coordinate + width)
                           @y_coordinate + 4
                         else
                           overlapping.y_coordinate - height
                         end
                       else
                         @y_coordinate
                       end
        warp(x_coordinate, y_coordinate)
      end
    end

    def distance_from_walls
      return nil unless room?

      distances = Hash[]
      @room.boundaries.each do |boundary|
        case boundary[0]
        when :north
          distances[:north] = (@y_coordinate - boundary[1].y_coordinate).abs
        when :south
          distances[:south] = (boundary[1].y_coordinate - (@y_coordinate + height)).abs
        when :east
          distances[:east] = (boundary[1].x_coordinate - (@x_coordinate + width)).abs
        when :west
          distances[:west] = (@x_coordinate - boundary[1].x_coordinate).abs
        else
          0
        end
      end
      distances
    end

    def next_wall
      return nil unless room?

      distances = distance_from_walls
      Hash["#{distances.filter { |_, v| v == distances.values.min }.keys.first}": distances.values.min]
    end

    def enter(room) = @room = room
    def leave = @room = nil
    def room? = !@room.nil?
    def draw = grid.draw
  end
end
