
interface
subroutine ds(x, y, theta, omega, V, ds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out), dimension(1:3, 1:1) :: ds
end subroutine
end interface
interface
subroutine dds(x, y, theta, omega, V, dds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out), dimension(1:3, 1:3) :: dds
end subroutine
end interface
interface
subroutine dl(x, y, theta, lambda_x, lambda_y, lambda_theta, omega, V, &
dl)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out), dimension(1:3, 1:1) :: dl
end subroutine
end interface
interface
subroutine ddl(x, y, theta, lambda_x, lambda_y, lambda_theta, omega, V, &
ddl)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out), dimension(1:3, 1:3) :: ddl
end subroutine
end interface
interface
subroutine dfs(x, y, theta, lambda_x, lambda_y, lambda_theta, omega, V, &
dfs)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out), dimension(1:6, 1:1) :: dfs
end subroutine
end interface
interface
subroutine ddfs(x, y, theta, lambda_x, lambda_y, lambda_theta, omega, &
V, ddfs)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out), dimension(1:6, 1:6) :: ddfs
end subroutine
end interface
interface
subroutine L(x, y, theta, omega, V, L)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out) :: L
end subroutine
end interface
interface
subroutine H(x, y, theta, lambda_x, lambda_y, lambda_theta, omega, V, &
H)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out) :: H
end subroutine
end interface
interface
subroutine uo(x, y, theta, lambda_x, lambda_y, lambda_theta, V, uo)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_theta
REAL*8, intent(in) :: V
REAL*8, intent(out), dimension(1:1, 1:1) :: uo
end subroutine
end interface

