
subroutine eom_state(x, y, v_x, v_y, u_t, u_x, u_y, T, m, ds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(out), dimension(1:4, 1:1) :: ds

ds(1, 1) = v_x
ds(2, 1) = v_y
ds(3, 1) = T*u_t*u_x/m
ds(4, 1) = T*u_t*u_y/m

end subroutine

subroutine jacobian_eom_state(x, y, v_x, v_y, u_t, u_x, u_y, T, m, dds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(out), dimension(1:4, 1:4) :: dds

dds(1, 1) = 0
dds(2, 1) = 0
dds(3, 1) = 0
dds(4, 1) = 0
dds(1, 2) = 0
dds(2, 2) = 0
dds(3, 2) = 0
dds(4, 2) = 0
dds(1, 3) = 1
dds(2, 3) = 0
dds(3, 3) = 0
dds(4, 3) = 0
dds(1, 4) = 0
dds(2, 4) = 1
dds(3, 4) = 0
dds(4, 4) = 0

end subroutine

subroutine eom_costate(x, y, v_x, v_y, lambda_x, lambda_y, lambda_v_x, &
      lambda_v_y, u_t, u_x, u_y, T, m, alpha, dl)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:4, 1:1) :: dl

dl(1, 1) = 0
dl(2, 1) = 0
dl(3, 1) = -lambda_x
dl(4, 1) = -lambda_y

end subroutine

subroutine jacobian_eom_costate(x, y, v_x, v_y, lambda_x, lambda_y, &
      lambda_v_x, lambda_v_y, u_t, u_x, u_y, T, m, alpha, ddl)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:4, 1:4) :: ddl

ddl(1, 1) = 0
ddl(2, 1) = 0
ddl(3, 1) = 0
ddl(4, 1) = 0
ddl(1, 2) = 0
ddl(2, 2) = 0
ddl(3, 2) = 0
ddl(4, 2) = 0
ddl(1, 3) = 0
ddl(2, 3) = 0
ddl(3, 3) = 0
ddl(4, 3) = 0
ddl(1, 4) = 0
ddl(2, 4) = 0
ddl(3, 4) = 0
ddl(4, 4) = 0

end subroutine

subroutine eom_fullstate(x, y, v_x, v_y, lambda_x, lambda_y, &
      lambda_v_x, lambda_v_y, u_t, u_x, u_y, T, m, alpha, dfs)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:8, 1:1) :: dfs

dfs(1, 1) = v_x
dfs(2, 1) = v_y
dfs(3, 1) = T*u_t*u_x/m
dfs(4, 1) = T*u_t*u_y/m
dfs(5, 1) = 0
dfs(6, 1) = 0
dfs(7, 1) = -lambda_x
dfs(8, 1) = -lambda_y

end subroutine

subroutine jacobian_eom_fullstate(x, y, v_x, v_y, lambda_x, lambda_y, &
      lambda_v_x, lambda_v_y, u_t, u_x, u_y, T, m, alpha, ddfs)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:8, 1:8) :: ddfs

ddfs(1, 1) = 0
ddfs(2, 1) = 0
ddfs(3, 1) = 0
ddfs(4, 1) = 0
ddfs(5, 1) = 0
ddfs(6, 1) = 0
ddfs(7, 1) = 0
ddfs(8, 1) = 0
ddfs(1, 2) = 0
ddfs(2, 2) = 0
ddfs(3, 2) = 0
ddfs(4, 2) = 0
ddfs(5, 2) = 0
ddfs(6, 2) = 0
ddfs(7, 2) = 0
ddfs(8, 2) = 0
ddfs(1, 3) = 1
ddfs(2, 3) = 0
ddfs(3, 3) = 0
ddfs(4, 3) = 0
ddfs(5, 3) = 0
ddfs(6, 3) = 0
ddfs(7, 3) = 0
ddfs(8, 3) = 0
ddfs(1, 4) = 0
ddfs(2, 4) = 1
ddfs(3, 4) = 0
ddfs(4, 4) = 0
ddfs(5, 4) = 0
ddfs(6, 4) = 0
ddfs(7, 4) = 0
ddfs(8, 4) = 0
ddfs(1, 5) = 0
ddfs(2, 5) = 0
ddfs(3, 5) = 0
ddfs(4, 5) = 0
ddfs(5, 5) = 0
ddfs(6, 5) = 0
ddfs(7, 5) = -1
ddfs(8, 5) = 0
ddfs(1, 6) = 0
ddfs(2, 6) = 0
ddfs(3, 6) = 0
ddfs(4, 6) = 0
ddfs(5, 6) = 0
ddfs(6, 6) = 0
ddfs(7, 6) = 0
ddfs(8, 6) = -1
ddfs(1, 7) = 0
ddfs(2, 7) = 0
ddfs(3, 7) = 0
ddfs(4, 7) = 0
ddfs(5, 7) = 0
ddfs(6, 7) = 0
ddfs(7, 7) = 0
ddfs(8, 7) = 0
ddfs(1, 8) = 0
ddfs(2, 8) = 0
ddfs(3, 8) = 0
ddfs(4, 8) = 0
ddfs(5, 8) = 0
ddfs(6, 8) = 0
ddfs(7, 8) = 0
ddfs(8, 8) = 0

end subroutine

subroutine lagrangian(x, y, v_x, v_y, u_t, u_x, u_y, T, m, alpha, L)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(in) :: alpha
REAL*8, intent(out) :: L

L = alpha*u_t + u_t**2*(-alpha + 1)

end subroutine

subroutine hamiltonian(x, y, v_x, v_y, lambda_x, lambda_y, lambda_v_x, &
      lambda_v_y, u_t, u_x, u_y, T, m, alpha, H)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(in) :: alpha
REAL*8, intent(out) :: H

H = T*lambda_v_x*u_t*u_x/m + T*lambda_v_y*u_t*u_y/m + alpha*u_t + &
      lambda_x*v_x + lambda_y*v_y + u_t**2*(-alpha + 1)

end subroutine

subroutine control(x, y, v_x, v_y, lambda_x, lambda_y, lambda_v_x, &
      lambda_v_y, T, m, alpha, uo)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:3, 1:1) :: uo

uo(1, 1) = (1.0d0/2.0d0)*(-T*lambda_v_x**2 - T*lambda_v_y**2 + alpha*m* &
      sqrt(lambda_v_x**2 + lambda_v_y**2))/(m*(alpha - 1)*sqrt( &
      lambda_v_x**2 + lambda_v_y**2))
uo(2, 1) = -lambda_v_x/sqrt(lambda_v_x**2 + lambda_v_y**2)
uo(3, 1) = -lambda_v_y/sqrt(lambda_v_x**2 + lambda_v_y**2)

end subroutine

subroutine nondimensionalise_state(x, y, v_x, v_y, t_b, l_b, m_b, &
      ndims)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: t_b
REAL*8, intent(in) :: l_b
REAL*8, intent(in) :: m_b
REAL*8, intent(out), dimension(1:4, 1:1) :: ndims

ndims(1, 1) = x/l_b
ndims(2, 1) = y/l_b
ndims(3, 1) = t_b*v_x/l_b
ndims(4, 1) = t_b*v_y/l_b

end subroutine

subroutine dimensionalise_state(x, y, v_x, v_y, t_b, l_b, m_b, dims)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: t_b
REAL*8, intent(in) :: l_b
REAL*8, intent(in) :: m_b
REAL*8, intent(out), dimension(1:4, 1:1) :: dims

dims(1, 1) = l_b*x
dims(2, 1) = l_b*y
dims(3, 1) = l_b*v_x/t_b
dims(4, 1) = l_b*v_y/t_b

end subroutine

subroutine nondimensionalise_parameters(T, m, t_b, l_b, m_b, ndimp)
implicit none
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(in) :: t_b
REAL*8, intent(in) :: l_b
REAL*8, intent(in) :: m_b
REAL*8, intent(out), dimension(1:2, 1:1) :: ndimp

ndimp(1, 1) = T*t_b/(l_b*m_b)
ndimp(2, 1) = m/m_b

end subroutine

subroutine dimensionalise_parameters(T, m, t_b, l_b, m_b, dimp)
implicit none
REAL*8, intent(in) :: T
REAL*8, intent(in) :: m
REAL*8, intent(in) :: t_b
REAL*8, intent(in) :: l_b
REAL*8, intent(in) :: m_b
REAL*8, intent(out), dimension(1:2, 1:1) :: dimp

dimp(1, 1) = T*l_b*m_b/t_b
dimp(2, 1) = m*m_b

end subroutine
