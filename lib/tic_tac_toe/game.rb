require 'matrix'

module TicTacToe
  class Game
    attr_accessor :board

    def initialize
      @board = Matrix.build(3, 3) { |_row, _col| '' }.to_a
    end

    def winner(game_matrix)
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

      # First Item Of All Rows
      # [0 _ _]
      # [0 _ _]
      # [0 _ _]
      game_matrix.transpose.fetch(0)

      # TODO: Refactor/Simplify
      # Check Verically If All Items Are The Same,
      # Ex: [0,1,1],[0,1,1],[0,1,1]
      game4 = [
        [1, 0, 0],
        [0, 0, 1],
        [1, 0, 1]
      ]
      result4 = []
      (0..game4.size - 1).each_with_object(game4) do |index, matrix|
        single_columns = matrix.map { |row| row[index, 1] } # row[index, length of one]
        result4 << single_columns.transpose.fetch(0)
      end
      result4.select! { |item| item.uniq.count == 1 }
    end

    def update_board(selection, player)
      board[selection.column][selection.row] = player
    end
  end
end
