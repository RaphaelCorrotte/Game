# frozen_string_literal: true

module Game
  class Player < Entity
    IDENTIFIER = 2
    def initialize(window)
      super(window, 1, 1)
    end

    attr_writer :x_coordinate, :y_coordinate
  end
end
