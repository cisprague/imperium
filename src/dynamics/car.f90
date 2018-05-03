
subroutine ds(x, y, theta, omega, V, ds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out), dimension(1:3, 1:1) :: ds

ds(1, 1) = V*cos(theta)
ds(2, 1) = V*sin(theta)
ds(3, 1) = omega

end subroutine

subroutine dds(x, y, theta, omega, V, dds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out), dimension(1:3, 1:3) :: dds

dds(1, 1) = 0
dds(2, 1) = 0
dds(3, 1) = 0
dds(1, 2) = 0
dds(2, 2) = 0
dds(3, 2) = 0
dds(1, 3) = -V*sin(theta)
dds(2, 3) = V*cos(theta)
dds(3, 3) = 0

end subroutine

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

dl(1, 1) = 0
dl(2, 1) = 0
dl(3, 1) = V*lambda_x*sin(theta) - V*lambda_y*cos(theta)

end subroutine

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

ddl(1, 1) = 0
ddl(2, 1) = 0
ddl(3, 1) = 0
ddl(1, 2) = 0
ddl(2, 2) = 0
ddl(3, 2) = 0
ddl(1, 3) = 0
ddl(2, 3) = 0
ddl(3, 3) = V*lambda_x*cos(theta) + V*lambda_y*sin(theta)

end subroutine

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

dfs(1, 1) = V*cos(theta)
dfs(2, 1) = V*sin(theta)
dfs(3, 1) = omega
dfs(4, 1) = 0
dfs(5, 1) = 0
dfs(6, 1) = V*lambda_x*sin(theta) - V*lambda_y*cos(theta)

end subroutine

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

ddfs(1, 1) = 0
ddfs(2, 1) = 0
ddfs(3, 1) = 0
ddfs(4, 1) = 0
ddfs(5, 1) = 0
ddfs(6, 1) = 0
ddfs(1, 2) = 0
ddfs(2, 2) = 0
ddfs(3, 2) = 0
ddfs(4, 2) = 0
ddfs(5, 2) = 0
ddfs(6, 2) = 0
ddfs(1, 3) = -V*sin(theta)
ddfs(2, 3) = V*cos(theta)
ddfs(3, 3) = 0
ddfs(4, 3) = 0
ddfs(5, 3) = 0
ddfs(6, 3) = V*lambda_x*cos(theta) + V*lambda_y*sin(theta)
ddfs(1, 4) = 0
ddfs(2, 4) = 0
ddfs(3, 4) = 0
ddfs(4, 4) = 0
ddfs(5, 4) = 0
ddfs(6, 4) = V*sin(theta)
ddfs(1, 5) = 0
ddfs(2, 5) = 0
ddfs(3, 5) = 0
ddfs(4, 5) = 0
ddfs(5, 5) = 0
ddfs(6, 5) = -V*cos(theta)
ddfs(1, 6) = 0
ddfs(2, 6) = 0
ddfs(3, 6) = 0
ddfs(4, 6) = 0
ddfs(5, 6) = 0
ddfs(6, 6) = 0

end subroutine

subroutine L(x, y, theta, omega, V, L)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: theta
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: V
REAL*8, intent(out) :: L

L = omega**2

end subroutine

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

H = V*lambda_x*cos(theta) + V*lambda_y*sin(theta) + lambda_theta*omega + &
      omega**2

end subroutine

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

uo(1, 1) = -1.0d0/2.0d0*lambda_theta

end subroutine
