require 'matrix'

module TicTacToe
  class Game
    attr_accessor :board

    def initialize(board)
      @board = board
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

    def update_board(selection, player)
      board[selection.row][selection.column] = player
    end
  end
end
