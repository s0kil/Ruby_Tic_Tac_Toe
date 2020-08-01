require 'matrix'

module TicTacToe
  class Game
    def initialize(game_board, player_selection)
      @game_board = game_board
      @player_selection = player_selection
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
      # Check Vertically If All Column Items Are The Same,
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

    def update_board(player)
      @game_board[@player_selection.row][@player_selection.column] = player
    end
  end
end
