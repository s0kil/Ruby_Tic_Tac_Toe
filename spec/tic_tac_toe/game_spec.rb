require_relative '../../lib/tic_tac_toe/game.rb'

describe 'TicTacToe::Game' do
  let(:player_selection) { Struct.new(:column, :row).new }
  let(:game_board) { Matrix.build(3, 3) { |_row, _col| '-' }.to_a }
  let(:game) { TicTacToe::Game.new(game_board, player_selection) }

  describe '#winner?' do
    it 'Checks For Winner Diagonally' do
      player_selection.row = 0
      player_selection.column = 0
      game.update_board('X')

      player_selection.row = 1
      player_selection.column = 1
      game.update_board('X')

      player_selection.row = 2
      player_selection.column = 2
      game.update_board('X')

      expect(game.winner?).to(eq(true))
    end

    it 'Checks For Winner Diagonally Reversed' do
      player_selection.row = 2
      player_selection.column = 0
      game.update_board('X')

      player_selection.row = 1
      player_selection.column = 1
      game.update_board('X')

      player_selection.row = 0
      player_selection.column = 2
      game.update_board('X')

      expect(game.winner?).to(eq(true))
    end

    it 'Checks For Winner Horizontally' do
      player_selection.row = 0
      player_selection.column = 0
      game.update_board('X')

      player_selection.row = 0
      player_selection.column = 1
      game.update_board('X')

      player_selection.row = 0
      player_selection.column = 2
      game.update_board('X')

      expect(game.winner?).to(eq(true))
    end

    it 'Checks For Winner Vertically' do
      player_selection.row = 0
      player_selection.column = 0
      game.update_board('X')

      player_selection.row = 1
      player_selection.column = 0
      game.update_board('X')

      player_selection.row = 2
      player_selection.column = 0
      game.update_board('X')

      expect(game.winner?).to(eq(true))
    end
  end

  describe '#players_draw?' do
    it 'Both Players Draw' do
      # X | O | X
      # ---------
      # O | X | X
      # ---------
      # O | X | O

      player_selection.row = 0
      player_selection.column = 0
      game.update_board('X')

      player_selection.row = 0
      player_selection.column = 2
      game.update_board('X')

      player_selection.row = 1
      player_selection.column = 1
      game.update_board('X')

      player_selection.row = 1
      player_selection.column = 2
      game.update_board('X')

      player_selection.row = 2
      player_selection.column = 1
      game.update_board('X')

      player_selection.row = 0
      player_selection.column = 1
      game.update_board('O')

      player_selection.row = 1
      player_selection.column = 0
      game.update_board('O')

      player_selection.row = 2
      player_selection.column = 0
      game.update_board('O')

      player_selection.row = 2
      player_selection.column = 2
      game.update_board('O')

      expect(game.players_draw?).to(eq(true))
    end
  end

  describe '#update_board' do
    it 'Updates The Board With Player Selection' do
      player_selection.row = 2
      player_selection.column = 2
      game.update_board('X')

      expect(game_board[2][2]).to(eq('X'))
    end
  end
end
