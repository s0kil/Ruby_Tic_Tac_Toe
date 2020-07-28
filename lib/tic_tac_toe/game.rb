require 'matrix'

module TicTacToe
  class Game
    def winner(game_matrix)
      # Starting From First Row & First Item
      Matrix.rows(game_matrix).each(:diagonal).to_a

      # Starting From First Row, Last Item
      Matrix.rows(game_matrix).each(:diagonal).to_a

      # First Item Of All Rows
      game_matrix.transpose.fetch(0)

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

      # Check Horizontally If All Items Are The Same, Ex: [0,0,0]
      game_matrix.select { |item| item.uniq.count == 1 }
    end
  end
end
