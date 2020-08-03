require 'matrix'

module TicTacToe
  class Game
    def initialize(game_board, player_selection)
      @game_board = game_board
      @player_selection = player_selection
    end

    def winner?
      # Diagonally, Starting From [First Row][First Item]
      # [0 _ _]
      # [_ 0 _]
      # [_ _ 0]
      maybe_diagonal = Matrix.rows(
        @game_board
      ).each(:diagonal).to_a.uniq.count == 1
     
      # Diagonally, Starting From [First Row][Last Item]
      # [_ _ 0]
      # [_ 0 _]
      # [0 _ _]
      maybe_diagonal_reverse = Matrix.rows(
        @game_board.map(&:reverse)
      ).each(:diagonal).to_a.select { |item| item.uniq.count == 1 && item.none?('-') }.size >= 1
      
      # Horizontally, All Items Are The Same
      # [0 0 0]
      # [_ _ _]
      # [_ _ _]
      #
      # [_ _ _]
      # [0 0 0]
      # [_ _ _]
      #
      # [_ _ _]
      # [_ _ _]
      # [0 0 0]
      maybe_horizontal = @game_board.select { |item| item.uniq.count == 1 && item.none?('-') }.size >= 1
  
      # Vertically, All Items Are The Same
      # [0 _ _]
      # [0 _ _]
      # [0 _ _]
      #
      # [_ 0 _]
      # [_ 0 _]
      # [_ 0 _]
      #
      # [_ _ 0]
      # [_ _ 0]
      # [_ _ 0]
      maybe_vertical = @game_board.transpose.select { |item| item.uniq.count == 1 && item.none?('-')}.size >= 1 
     
      result = [maybe_diagonal, maybe_diagonal_reverse, maybe_horizontal, maybe_vertical ]
    
      if maybe_diagonal || maybe_diagonal_reverse || maybe_horizontal ||  maybe_vertical
        true
      else
        false
      end
    end

    def update_board(player)
      @game_board[@player_selection.row][@player_selection.column] = player
    end

    def player_selection_available?
      @game_board[@player_selection.row][@player_selection.column] == '-'
    end
  end
end
