require 'curses'
require 'strings'

# Curses Library Resources
# - https://github.com/ruby/curses
# - http://www.cs.ukzn.ac.za/~hughm/os/notes/ncurses.html
# - https://atevans.com/2017/08/02/ruby-curses-for-terminal-apps.html
# - https://rosettacode.org/wiki/Terminal_control/Cursor_movement#Python
# - https://www.gnu.org/software/guile-ncurses/manual/html_node/index.html
# - https://www.youtube.com/playlist?list=PL2U2TQ__OrQ8jTf0_noNKtHMuYlyxQl4v
# - https://www.2n.pl/blog/basics-of-curses-library-in-ruby-make-awesome-terminal-apps
# - https://www.ibm.com/support/knowledgecenter/ssw_aix_72/generalprogramming/curses.html
# - https://stac47.github.io/ruby/curses/tutorial/2014/01/21/ruby-and-curses-tutorial.html

module TicTacToe
  module Interface
    # TUI
    class TextualInterface
      WINDOW_MARGIN = 2

      def initialize(game_board, player_selection)
        @game_board = game_board
        @player_selection = player_selection

        Curses.init_screen
        Curses.start_color
        Curses.use_default_colors # Use User Defined Terminal Colors
        Curses.curs_set(2) # Set Curser Very Visible
        Curses.noecho # Do Not Print Pressed Keys To The Screen
        Curses.cbreak # Ctrl+C Exits The Program

        # The Number Is The Color Pair Identifier
        @color_black_red = 1
        # Setup Colors That Will Be Used Later
        # Color Definitions: https://github.com/ruby/curses/blob/master/ext/curses/curses.c#L5216-L5263
        Curses.init_pair(@color_black_red, Curses::COLOR_BLACK, Curses::COLOR_RED)

        @window = Curses::Window.new(0, 0, WINDOW_MARGIN, WINDOW_MARGIN) # Full Screen, With Some Margin

        @window.nodelay = true # Do Not Block Waiting For Keyboard Input
        @window.keypad = true # Allow User To Move Around With The Keyboard (Up, Down, Left, Right)
        @window.refresh # Refreshes The Screen

        @cursor_coordinates = {
          y: @window.cury,
          x: @window.curx
        }
      end

      def new_game
        welcome_message =
          %(Welcome to Ruby Tic Tac Toe
Tic-tac-toe is a game for two players, X and O, who take turns marking the spaces in a 3×3 grid.
The player who succeeds in placing three of their marks in a horizontal, vertical, or diagonal row is the winner.
)

        @window.addstr(Strings.wrap(welcome_message, 50))

        # Set Cursor To Bottom Of The Terminal, https://stackoverflow.com/a/54736503
        @window.setpos(@window.maxy - WINDOW_MARGIN - 2, 0)
        @window.addstr("- Press space bar to mark an empty space\n")
        @window.addstr("- Exit game with Ctrl+C\n")
        @window.setpos(0, 0)
      end

      def draw_board
        # TODO: How To Render In Free Space (After Welcome Message)? Versus Manually Hardcoding The Value
        @window.setpos(10, 0)

        @window.attron(Curses.color_pair(@color_black_red)) do
          @window.addstr("#{@game_board[0][0]} | #{@game_board[0][1]} | #{@game_board[0][2]}\n")
          @window.addstr("---------\n")
          @window.addstr("#{@game_board[1][0]} | #{@game_board[1][1]} | #{@game_board[1][2]}\n")
          @window.addstr("---------\n")
          @window.addstr("#{@game_board[2][0]} | #{@game_board[2][1]} | #{@game_board[2][2]}\n")
        end
      end

      def start_game_loop
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

        # Exit Message
        puts 'Thanks for playing Tic Tac Toe, Goodbye!'
      end

      def handle_key_press
        # Make Sure Cursor Starts Inside The Game Board On First Render,
        # And Prevent Cursor From Escaping Game Board
        @cursor_coordinates[:y] = 10 if @cursor_coordinates[:y] <= 10 # Up
        @cursor_coordinates[:y] = 14 if @cursor_coordinates[:y] >= 14 # Down
        @cursor_coordinates[:x] = 0 if @cursor_coordinates[:x] <= 0 # Left
        @cursor_coordinates[:x] = 8 if @cursor_coordinates[:x] >= 8 # Right

        # We Are Restoring Cursor Position Set On The Previous Game Loop Cycle
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

        case key_press
        when Curses::Key::UP
          @cursor_coordinates[:y] = @cursor_coordinates[:y] - row_cursor_gap
        when Curses::Key::DOWN
          @cursor_coordinates[:y] = @cursor_coordinates[:y] + row_cursor_gap
        when Curses::Key::LEFT
          @cursor_coordinates[:x] = @cursor_coordinates[:x] - column_cursor_gap
        when Curses::Key::RIGHT
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
        end
      end
    end
  end
end
