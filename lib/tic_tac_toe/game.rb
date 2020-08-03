require 'matrix'

module TicTacToe
  class Game
    def initialize(game_board, player_selection)
      @game_board = game_board
      @player_selection = player_selection
    end

    def winner?
      is_valid_array =
        ->(array) { array.none?('-') == true && array.uniq.count == 1 && array.size >= 1 }

      # Diagonally, Starting From [First Row][First Item]
      # [0 _ _]
      # [_ 0 _]
      # [_ _ 0]
      maybe_diagonal =
        Matrix.rows(@game_board).each(:diagonal).to_a

      # Diagonally, Starting From [First Row][Last Item]
      # [_ _ 0]
      # [_ 0 _]
      # [0 _ _]
      maybe_diagonal_reverse =
        Matrix.rows(@game_board.map(&:reverse)).each(:diagonal).to_a

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
      maybe_horizontal =
        @game_board.select(&is_valid_array)

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
      maybe_vertical =
        @game_board.transpose.select(&is_valid_array)

      [maybe_diagonal, maybe_diagonal_reverse, maybe_horizontal, maybe_vertical].map(&is_valid_array).any?(true)
    end

    def players_draw?
      @game_board.flatten.none?('-')
    end

    def update_board(player)
      @game_board[@player_selection.row][@player_selection.column] = player
    end

    def player_selection_available?
      @game_board[@player_selection.row][@player_selection.column] == '-'
    end
  end
end
