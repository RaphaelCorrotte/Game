# frozen_string_literal: true

require File.expand_path("grid", File.dirname(__FILE__))

module Game
  class Cells
    WIDTH = HEIGHT = 32
    attr_accessor :boundary

    def initialize(boundary)
      @boundary = boundary
      cells
    end

    def cells
      row_x = @boundary.width / WIDTH
      row_y = @boundary.height / HEIGHT
      cells = []
      row_x.times do |x|
        row_y.times do |y|
          cells << [@boundary.x_coordinate + (x * WIDTH), @boundary.y_coordinate + (y * HEIGHT)]
        end
      end
      cells
    end
  end
end
