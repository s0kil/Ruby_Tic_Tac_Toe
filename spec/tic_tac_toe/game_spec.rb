require_relative '../../lib/tic_tac_toe/game.rb'

# Test Helper To Create Game Scenarios
def scaffold_game(matrix_string = nil)
  game_board = if matrix_string.nil?
                 Matrix.build(3, 3) { |_row, _col| '-' }.to_a
               else
                 # Transform Visual String Matrix Into An Matrix
                 matrix_string
                   .split(/\n/)
                   .map(&:strip)
                   .reject(&:empty?)
                   .map { |row| row.split(' ').map { |char| char.tr('[]', '').tr('_', '-') } }
               end

  player_selection = Struct.new(:column, :row).new
  game = TicTacToe::Game.new(game_board, player_selection)

  [game, game_board, player_selection]
end

describe 'TicTacToe::Game' do
  describe '#winner?' do
    it 'Checks For Winner Diagonally' do
      game, = scaffold_game(
        %(
          [X _ _]
          [_ X _]
          [_ _ X]
        )
      )

      expect(game.winner?).to(eq(true))
    end

    it 'Checks For Winner Diagonally Reversed' do
      game, = scaffold_game(
        %(
          [_ _ X]
          [_ X _]
          [X _ _]
        )
      )

      expect(game.winner?).to(eq(true))
    end

    it 'Checks For Winner Horizontally' do
      game, = scaffold_game(
        %(
          [X X X]
          [_ _ _]
          [_ _ _]
        )
      )

      expect(game.winner?).to(eq(true))
    end

    it 'Checks For Winner Vertically' do
      game, = scaffold_game(
        %(
          [X _ _]
          [X _ _]
          [X _ _]
        )
      )

      expect(game.winner?).to(eq(true))
    end

    it 'Does Not Find A Winner Vertically' do
      game, = scaffold_game(
        %(
          [X _ _]
          [X _ _]
          [O _ _]
        )
      )

      expect(game.winner?).to(eq(false))
    end

    it 'Does Not Find A Winner Horizontally' do
      game, = scaffold_game(
        %(
          [_ _ _]
          [X X O]
          [_ _ _]
        )
      )

      expect(game.winner?).to(eq(false))
    end
  end

  describe '#players_draw?' do
    it 'Both Players Draw' do
      game, = scaffold_game(
        %(
          [X O X]
          [O X X]
          [O X O]
        )
      )

      expect(game.players_draw?).to(eq(true))
    end

    it 'Returns False If Game Board Empty' do
      game, = scaffold_game

      expect(game.players_draw?).to(eq(false))
    end

    it 'Returns False If Game Board Is Not Full Capacity' do
      game, = scaffold_game(
        %(
          [X _ _]
          [_ _ _]
          [_ _ _]
        )
      )

      expect(game.players_draw?).to(eq(false))
    end
  end

  describe '#update_board' do
    it 'Updates The Board With Player Selection' do
      game, game_board, player_selection = scaffold_game

      player_selection.row = 2
      player_selection.column = 2
      game.update_board('X')

      expect(game_board[2][2]).to(eq('X'))
    end
  end

  describe '#player_selection_available?' do
    it 'When New Board Move, Returns True' do
      game, _, player_selection = scaffold_game

      player_selection.row = 0
      player_selection.column = 0

      expect(game.player_selection_available?).to(eq(true))
    end

    it 'When Board Move Taken, Returns False' do
      game, _, player_selection = scaffold_game

      # First Move
      player_selection.row = 0
      player_selection.column = 0
      game.update_board('X')

      # Second Move
      player_selection.row = 0
      player_selection.column = 0

      expect(game.player_selection_available?).to(eq(false))
    end
  end
end
