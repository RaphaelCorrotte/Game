# frozen_string_literal: true

require File.expand_path("grid", File.dirname(__FILE__))

module Game
  class QuadTree
    attr_reader :divided, :boundary, :capacity, :entities, :northwest, :northeast, :southwest, :southeast

    def initialize(boundary, capacity)
      @boundary = boundary
      @capacity = capacity
      @entities = []
      @divided = false
    end

    def subdivide
      @northeast = QuadTree.new(Grid.new(@boundary.x_coordinate + @boundary.width / 2, @boundary.y_coordinate, @boundary.width / 2, @boundary.height / 2), @capacity)
      @northwest = QuadTree.new(Grid.new(@boundary.x_coordinate, @boundary.y_coordinate, @boundary.width / 2, @boundary.height / 2), @capacity)
      @southeast = QuadTree.new(Grid.new(@boundary.x_coordinate + @boundary.width / 2, @boundary.y_coordinate + @boundary.height / 2, @boundary.width / 2, @boundary.height / 2), @capacity)
      @southwest = QuadTree.new(Grid.new(@boundary.x_coordinate, @boundary.y_coordinate + @boundary.height / 2, @boundary.width / 2, @boundary.height / 2), @capacity)
    end

    def insert(entity)
      return false unless @boundary.contain?(entity.grid)

      if @entities.count < @capacity
        @entities << entity
        return true
      end
      unless @divided
        subdivide
        @divided = true
      end
      if @northwest.insert(entity)
        true
      elsif @northeast.insert(entity)
        true
      elsif @southwest.insert(entity)
        true
      elsif @southeast.insert(entity)
        true
      else
        false
      end
    end

    def query(grid = @boundary, found = [])
      return found unless @boundary.intersect?(grid)

      @entities.each { |entity| found << entity if grid.contain?(Grid.new(entity.x_coordinate, entity.y_coordinate, entity.width, entity.height)) }

      return found unless @divided

      @northwest.query(grid, found)
      @northeast.query(grid, found)
      @southwest.query(grid, found)
      @southeast.query(grid, found)
      found
    end

    def entities_overlapping(grid = @boundary, entities = query(grid))
      overlapping = []
      entities.reject { |e| e.class <= Cell }.each do |e|
        overlapping << e if grid.contain?(Grid.new(e.x_coordinate, e.y_coordinate, e.width, e.height))
      end
      overlapping
    end

    def entities_count
      [@northwest, @northeast, @southwest, @southeast].sum { _1&.entities_count || 0 } + @entities.count
    end

    def draw
      Gosu.draw_line(@boundary.x_coordinate, @boundary.y_coordinate, Gosu::Color::WHITE, @boundary.x_coordinate + @boundary.width, @boundary.y_coordinate, Gosu::Color::WHITE)
      Gosu.draw_line(@boundary.x_coordinate, @boundary.y_coordinate, Gosu::Color::WHITE, @boundary.x_coordinate, @boundary.y_coordinate + @boundary.height, Gosu::Color::WHITE)
      Gosu.draw_line(@boundary.x_coordinate + @boundary.width, @boundary.y_coordinate, Gosu::Color::WHITE, @boundary.x_coordinate + @boundary.width, @boundary.y_coordinate + @boundary.height,
                     Gosu::Color::WHITE)
      Gosu.draw_line(@boundary.x_coordinate, @boundary.y_coordinate + @boundary.height, Gosu::Color::WHITE, @boundary.x_coordinate + @boundary.width, @boundary.y_coordinate + @boundary.height,
                     Gosu::Color::WHITE)
      return unless @divided

      @northwest.draw
      @northeast.draw
      @southwest.draw
      @southeast.draw
    end

    private :subdivide
  end
end
