program tic_tac_toe
  implicit none

  character(len=1) :: board(9)
  integer :: move, turn_count
  character(len=1) :: winner
  logical :: finished

  call init_board(board)
  turn_count = 0
  winner = ' '
  finished = .false.

  print *, '三子棋双人模式：玩家 1 使用 X，玩家 2 使用 O'
  print *, '输入 1 到 9 选择位置。位置如下：'
  call print_help()

  do while (.not. finished)
    call print_board(board)
    call player_turn(board, move, 'X', '玩家 1')
    turn_count = turn_count + 1

    winner = check_winner(board)
    if (winner /= ' ') exit
    if (turn_count == 9) exit

    call player_turn(board, move, 'O', '玩家 2')
    turn_count = turn_count + 1

    winner = check_winner(board)
    if (winner /= ' ') exit
    if (turn_count == 9) exit
  end do

  call print_board(board)

  if (winner == 'X') then
    print *, '玩家 1 赢了！'
  else if (winner == 'O') then
    print *, '玩家 2 赢了！'
  else
    print *, '平局！'
  end if

contains

  subroutine init_board(board)
    character(len=1), intent(out) :: board(9)
    integer :: i

    do i = 1, 9
      board(i) = ' '
    end do
  end subroutine init_board

  subroutine print_help()
    print *, ' 1 | 2 | 3 '
    print *, '---+---+---'
    print *, ' 4 | 5 | 6 '
    print *, '---+---+---'
    print *, ' 7 | 8 | 9 '
  end subroutine print_help

  subroutine print_board(board)
    character(len=1), intent(in) :: board(9)

    print *, ''
    print *, ' ', board(1), ' | ', board(2), ' | ', board(3)
    print *, '---+---+---'
    print *, ' ', board(4), ' | ', board(5), ' | ', board(6)
    print *, '---+---+---'
    print *, ' ', board(7), ' | ', board(8), ' | ', board(9)
    print *, ''
  end subroutine print_board

  subroutine player_turn(board, move, marker, player_name)
    character(len=1), intent(inout) :: board(9)
    integer, intent(out) :: move
    character(len=1), intent(in) :: marker
    character(len=*), intent(in) :: player_name
    integer :: ios

    do
      write (*, '(A, A, A)', advance='no') trim(player_name), '，请输入落子位置（1-9）：'
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
  end subroutine player_turn

  character(len=1) function check_winner(board) result(winner)
    character(len=1), intent(in) :: board(9)
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
