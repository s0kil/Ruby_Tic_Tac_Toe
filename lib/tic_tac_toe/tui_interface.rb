require 'curses'
require 'strings'

module TicTacToe
  # TUI
  class TextualInterface
    WINDOW_SPACING = 2

    def initialize(game_board, player_selection)
      @game_board = game_board
      @player_selection = player_selection

      Curses.init_screen
      Curses.start_color
      Curses.use_default_colors # Use User Defined Terminal Colors
      Curses.curs_set(2) # Set Cursor Very Visible
      Curses.noecho # Do Not Print Pressed Keys To The Screen
      Curses.cbreak # Ctrl+C Exits The Program

      # The Number Is The Color Pair Identifier
      @color_pair_one = 1
      # Setup Colors That Will Be Used Later
      # Color Definitions: https://github.com/ruby/curses/blob/master/ext/curses/curses.c#L5216-L5263
      Curses.init_pair(@color_pair_one, Curses::COLOR_BLACK, Curses::COLOR_GREEN)

      @window = Curses::Window.new(0, 0, (WINDOW_SPACING / 2), WINDOW_SPACING) # Full Screen, With Some Margin

      @window.nodelay = true # Do Not Block Waiting For Keyboard Input
      @window.keypad = true # Allow User To Move Around With The Keyboard (Up, Down, Left, Right)
      @window.refresh # Refreshes The Screen

      @cursor_coordinates = {
        y: @window.cury,
        x: @window.curx
      }
    end

    def new_game
      @window.setpos(0, 0)

      welcome_message =
        %(Welcome to Ruby Tic Tac Toe
Tic-tac-toe is a game for two players, X and O, who take turns marking the spaces in a 3×3 grid.
The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row is the winner.
)

      @window.addstr(Strings.wrap(welcome_message, 50))

      # Set Cursor To Bottom Of The Terminal, https://stackoverflow.com/a/54736503
      @window.setpos(@window.maxy - WINDOW_SPACING - 2, 0)
      @window.addstr("+ Use navigation/arrow keys to move around\n")
      @window.addstr("+ Press space bar to mark an empty space\n")
      @window.addstr("- Exit game with Ctrl+C\n")
      @window.setpos(0, 0)
    end

    def draw_board(player)
      @window.setpos(10, 0)

      # Replace The Default Character `-` With A Colored Space Placeholder
      colored_placeholder = lambda do |string|
        if string == '-'
          @window.attron(Curses.color_pair(@color_pair_one)) do
            @window.addstr(' ')
          end
        else
          @window.addstr(string)
        end
      end

      @game_board.each.with_index do |row, row_index|
        row.each_index do |column_index|
          colored_placeholder.call((@game_board[row_index][column_index]).to_s)

          # Add Column Separator, Unless Last Column
          @window.addstr(' | ') unless column_index == (row.length - 1)
        end

        # Add Row Separator, Unless Last Row
        @window.addstr("\n---------\n") unless row_index == (@game_board.length - 1)
      end

      @window.addstr("\n\nPlayer #{player}'s turn\n")
    end

    def winner_message(player)
      Curses.curs_set(0) # Hide The Cursor

      @window.setpos(16, 0)
      @window << "Player #{player} has won the game."
    end

    def players_draw_message
      Curses.curs_set(0) # Hide The Cursor

      @window.setpos(16, 0)
      @window.clrtoeol # Clear The Line From Previous Message, https://stackoverflow.com/a/5072915
      @window << "It's a draw!"
    end

    def game_loop
      loop do
        yield # Assuming Block Givin
        @window.refresh

        # Slow Down Event Loop,
        # So Our Program Is Not CPU Intensive
        sleep(0.01)
      end
    rescue Interrupt => _e
      # Handling Ctrl+C, No Operation
      # Continue With Default Of Exiting The Program
    ensure
      # Close Screen Overlay After Game Loop Exits
      Curses.close_screen
    end

    def handle_key_press
      # Make Sure Cursor Starts Inside The Game Board On First Render,
      # And Prevent Cursor From Escaping Game Board
      @cursor_coordinates[:y] = 10 if @cursor_coordinates[:y] <= 10 # Up
      @cursor_coordinates[:y] = 14 if @cursor_coordinates[:y] >= 14 # Down
      @cursor_coordinates[:x] = 0 if @cursor_coordinates[:x] <= 0 # Left
      @cursor_coordinates[:x] = 8 if @cursor_coordinates[:x] >= 8 # Right

      # Restoring Cursor Position Set On The Previous Game Loop Cycle
      @window.setpos(
        @cursor_coordinates[:y],
        @cursor_coordinates[:x]
      )

      key_press = @window.getch

      # Define Amount The Cursor Should Move On Each Key Press,
      # Example: One Game Board Row Is, `- | - | -`,
      # It Takes Four Steps To Get To Each `-` Character In The Row
      row_cursor_gap = 2
      column_cursor_gap = 4

      case key_press # The Numbers (6061*) Represent Window Navigation Key Events
      when Curses::Key::UP, 60_610
        @cursor_coordinates[:y] = @cursor_coordinates[:y] - row_cursor_gap

      when Curses::Key::DOWN, 60_616
        @cursor_coordinates[:y] = @cursor_coordinates[:y] + row_cursor_gap

      when Curses::Key::LEFT, 60_612
        @cursor_coordinates[:x] = @cursor_coordinates[:x] - column_cursor_gap

      when Curses::Key::RIGHT, 60_614
        @cursor_coordinates[:x] = @cursor_coordinates[:x] + column_cursor_gap

      when ' ' # Space Bar, https://stackoverflow.com/a/13434381
        # Simple Solution To Convert Row And Column Coordinates To Game Board Matrix Indices
        # WARNING: Will Break If Game Board Position Changes
        # Example
        # [
        #   [10 0] [10 4] [10 8]
        #   [12 0] [12 4] [12 8]
        #   [14 0] [14 4] [14 8]
        # ]
        # Turns Into
        # [
        #   [0 0] [0 1] [0 2]
        #   [1 0] [1 1] [1 2]
        #   [2 0] [2 1] [2 2]
        # ]

        row_to_index =
          {
            10 => 0,
            12 => 1,
            14 => 2
          }

        row =
          row_to_index[@cursor_coordinates[:y]]

        column_to_index =
          {
            0 => 0,
            4 => 1,
            8 => 2
          }

        column =
          column_to_index[@cursor_coordinates[:x]]

        @player_selection.row = row
        @player_selection.column = column

      when Curses::Key::RESIZE # Handle Terminal Resize Event, https://stackoverflow.com/a/21815615
        # TODO: Fix Resizing On Windows OS
        if Gem.win_platform?
          system 'cls'
          throw 'Resizing Is Not Supported On Windows OS'
        end

        @window.clear # Clear The Window
        @window.resize(@window.maxy, @window.maxx)

      when 3 # Windows Terminal Exit Signal, https://stackoverflow.com/a/21123827
        exit
      end
    end
  end
end
