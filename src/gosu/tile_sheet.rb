# frozen_string_literal: true

require "rmagick"

module Game
  class TileSheet
    attr_reader :sheet

    def initialize(sheet)
      @sheet = sheet
    end
  end
end
