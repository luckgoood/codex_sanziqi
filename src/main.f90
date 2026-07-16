program tic_tac_toe
  implicit none

  character(len=3) :: board(9)
  integer :: game_mode, move, turn_count
  character(len=3) :: winner
  logical :: finished

  call init_board(board)
  turn_count = 0
  winner = ' '
  finished = .false.

  call choose_game_mode(game_mode)

  if (game_mode == 1) then
    print *, '三子棋：玩家 △，对手电脑 O'
  else
    print *, '三子棋：玩家 1 是 △，玩家 2 是 O'
  end if
  print *, '输入 1 到 9 选择位置。位置如下：'
  call print_help()

  do while (.not. finished)
    call print_board(board)
    call human_turn(board, move, '△', '玩家 1，请输入落子位置（1-9）：')
    turn_count = turn_count + 1

    winner = check_winner(board)
    if (winner /= ' ') exit
    if (turn_count == 9) exit

    if (game_mode == 1) then
      call computer_turn(board, move)
      print *, '电脑选择了位置 ', move
    else
      call human_turn(board, move, 'O', '玩家 2，请输入落子位置（1-9）：')
    end if
    turn_count = turn_count + 1

    winner = check_winner(board)
    if (winner /= ' ') exit
    if (turn_count == 9) exit
  end do

  call print_board(board)

  if (game_mode == 1 .and. winner == '△') then
    print *, '你赢了！'
  else if (game_mode == 1 .and. winner == 'O') then
    print *, '电脑赢了！'
  else if (game_mode == 2 .and. winner == '△') then
    print *, '玩家 1 赢了！'
  else if (game_mode == 2 .and. winner == 'O') then
    print *, '玩家 2 赢了！'
  else
    print *, '平局！'
  end if

contains

  subroutine init_board(board)
    character(len=3), intent(out) :: board(9)
    integer :: i

    do i = 1, 9
      board(i) = ' '
    end do
  end subroutine init_board

  subroutine choose_game_mode(game_mode)
    integer, intent(out) :: game_mode
    integer :: ios

    print *, '请选择游戏模式：'
    print *, '1. 玩家对电脑'
    print *, '2. 双人对战'

    do
      write (*, '(A)', advance='no') '请输入模式编号（1-2）：'
      read (*, *, iostat=ios) game_mode

      if (ios /= 0) then
        print *, '输入无效，请输入数字 1 或 2。'
      else if (game_mode < 1 .or. game_mode > 2) then
        print *, '模式编号只能是 1 或 2。'
      else
        exit
      end if
    end do
  end subroutine choose_game_mode

  subroutine print_help()
    print *, ' 1 | 2 | 3 '
    print *, '---+---+---'
    print *, ' 4 | 5 | 6 '
    print *, '---+---+---'
    print *, ' 7 | 8 | 9 '
  end subroutine print_help

  subroutine print_board(board)
    character(len=3), intent(in) :: board(9)

    write (*, '(A)') ''
    call print_row(board, 1, 2, 3)
    write (*, '(A)') '---+---+---'
    call print_row(board, 4, 5, 6)
    write (*, '(A)') '---+---+---'
    call print_row(board, 7, 8, 9)
    write (*, '(A)') ''
  end subroutine print_board

  subroutine print_row(board, first, second, third)
    character(len=3), intent(in) :: board(9)
    integer, intent(in) :: first, second, third

    call print_cell(board(first))
    write (*, '(A)', advance='no') '|'
    call print_cell(board(second))
    write (*, '(A)', advance='no') '|'
    call print_cell(board(third))
    write (*, '(A)') ''
  end subroutine print_row

  subroutine print_cell(marker)
    character(len=3), intent(in) :: marker

    if (marker == '△') then
      write (*, '(A)', advance='no') ' △ '
    else if (marker == 'O') then
      write (*, '(A)', advance='no') ' O '
    else
      write (*, '(A)', advance='no') '   '
    end if
  end subroutine print_cell

  subroutine human_turn(board, move, marker, prompt)
    character(len=3), intent(inout) :: board(9)
    integer, intent(out) :: move
    character(len=*), intent(in) :: marker, prompt
    integer :: ios

    do
      write (*, '(A)', advance='no') prompt
      read (*, *, iostat=ios) move

      if (ios /= 0) then
        print *, '输入无效，请输入数字 1 到 9。'
      else if (move < 1 .or. move > 9) then
        print *, '位置必须在 1 到 9 之间。'
      else if (board(move) /= ' ') then
        print *, '这个位置已经有棋子了。'
      else
        board(move) = marker
        exit
      end if
    end do
  end subroutine human_turn

  subroutine computer_turn(board, move)
    character(len=3), intent(inout) :: board(9)
    integer, intent(out) :: move
    integer :: preferred(9)
    integer :: i

    move = find_winning_move(board, 'O')
    if (move == 0) move = find_winning_move(board, '△')

    if (move == 0) then
      preferred = (/5, 1, 3, 7, 9, 2, 4, 6, 8/)
      do i = 1, 9
        if (board(preferred(i)) == ' ') then
          move = preferred(i)
          exit
        end if
      end do
    end if

    if (move > 0) board(move) = 'O'
  end subroutine computer_turn

  integer function find_winning_move(board, player) result(move)
    character(len=3), intent(in) :: board(9)
    character(len=*), intent(in) :: player
    character(len=3) :: test_board(9)
    integer :: i

    move = 0
    do i = 1, 9
      if (board(i) == ' ') then
        test_board = board
        test_board(i) = player
        if (check_winner(test_board) == player) then
          move = i
          return
        end if
      end if
    end do
  end function find_winning_move

  character(len=3) function check_winner(board) result(winner)
    character(len=3), intent(in) :: board(9)
    integer :: lines(8, 3)
    integer :: i

    lines(1, :) = (/1, 2, 3/)
    lines(2, :) = (/4, 5, 6/)
    lines(3, :) = (/7, 8, 9/)
    lines(4, :) = (/1, 4, 7/)
    lines(5, :) = (/2, 5, 8/)
    lines(6, :) = (/3, 6, 9/)
    lines(7, :) = (/1, 5, 9/)
    lines(8, :) = (/3, 5, 7/)

    winner = ' '
    do i = 1, 8
      if (board(lines(i, 1)) /= ' ' .and. &
          board(lines(i, 1)) == board(lines(i, 2)) .and. &
          board(lines(i, 2)) == board(lines(i, 3))) then
        winner = board(lines(i, 1))
        return
      end if
    end do
  end function check_winner

end program tic_tac_toe
