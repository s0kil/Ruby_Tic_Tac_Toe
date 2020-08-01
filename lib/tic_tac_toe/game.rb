require 'matrix'

module TicTacToe
  class Game
    def initialize(game_board, player_selection)
      @game_board = game_board
      @player_selection = player_selection
    end

    def winner
      # Diagonally, Starting From [First Row][First Item]
      # [0 _ _]
      # [_ 0 _]
      # [_ _ 0]
      Matrix.rows(
        game_matrix
      ).each(:diagonal).to_a

      # Diagonally, Starting From [First Row][Last Item]
      # [_ _ 0]
      # [_ 0 _]
      # [0 _ _]
      Matrix.rows(
        game_matrix.map(&:reverse)
      ).each(:diagonal).to_a

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
      game_matrix.select { |item| item.uniq.count == 1 }

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
      game_matrix.transpose.select { |item| item.uniq.count == 1 }
    end

    def update_board(player)
      @game_board[@player_selection.row][@player_selection.column] = player
    end

    def player_selection_available?
      @game_board[@player_selection.row][@player_selection.column] == '-'
    end
  end
end
