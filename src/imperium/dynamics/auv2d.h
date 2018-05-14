
interface
subroutine eom_state(x, y, v_x, v_y, u_t, u_x, u_y, m, T, ds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(out), dimension(1:4, 1:1) :: ds
end subroutine
end interface
interface
subroutine jacobian_eom_state(x, y, v_x, v_y, u_t, u_x, u_y, m, T, dds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(out), dimension(1:4, 1:4) :: dds
end subroutine
end interface
interface
subroutine eom_costate(x, y, v_x, v_y, lambda_x, lambda_y, lambda_v_x, &
lambda_v_y, u_t, u_x, u_y, m, T, alpha, dl)
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
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:4, 1:1) :: dl
end subroutine
end interface
interface
subroutine jacobian_eom_costate(x, y, v_x, v_y, lambda_x, lambda_y, &
lambda_v_x, lambda_v_y, u_t, u_x, u_y, m, T, alpha, ddl)
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
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:4, 1:4) :: ddl
end subroutine
end interface
interface
subroutine eom_fullstate(x, y, v_x, v_y, lambda_x, lambda_y, &
lambda_v_x, lambda_v_y, u_t, u_x, u_y, m, T, alpha, dfs)
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
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:8, 1:1) :: dfs
end subroutine
end interface
interface
subroutine jacobian_eom_fullstate(x, y, v_x, v_y, lambda_x, lambda_y, &
lambda_v_x, lambda_v_y, u_t, u_x, u_y, m, T, alpha, ddfs)
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
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:8, 1:8) :: ddfs
end subroutine
end interface
interface
subroutine lagrangian(x, y, v_x, v_y, u_t, u_x, u_y, m, T, alpha, L)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: u_t
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: alpha
REAL*8, intent(out) :: L
end subroutine
end interface
interface
subroutine hamiltonian(x, y, v_x, v_y, lambda_x, lambda_y, lambda_v_x, &
lambda_v_y, u_t, u_x, u_y, m, T, alpha, H)
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
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: alpha
REAL*8, intent(out) :: H
end subroutine
end interface
interface
subroutine control(x, y, v_x, v_y, lambda_x, lambda_y, lambda_v_x, &
lambda_v_y, m, T, alpha, uo)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:3, 1:1) :: uo
end subroutine
end interface

