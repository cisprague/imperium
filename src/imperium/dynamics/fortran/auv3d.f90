
subroutine eom_state(x, y, z, v_x, v_y, v_z, q_r, q_x, q_y, q_z, u, &
      u_x, u_y, rho, v_zf, omega, m, T, v_yf, cd, A, v_xf, ds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: z
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: v_z
REAL*8, intent(in) :: q_r
REAL*8, intent(in) :: q_x
REAL*8, intent(in) :: q_y
REAL*8, intent(in) :: q_z
REAL*8, intent(in) :: u
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: rho
REAL*8, intent(in) :: v_zf
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: v_yf
REAL*8, intent(in) :: cd
REAL*8, intent(in) :: A
REAL*8, intent(in) :: v_xf
REAL*8, intent(out), dimension(1:10, 1:1) :: ds

ds(1, 1) = v_x
ds(2, 1) = v_y
ds(3, 1) = v_z
ds(4, 1) = (-1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*sqrt((v_x - v_xf)**2 + ( &
      v_y - v_yf)**2 + (v_z - v_zf)**2) + T*u*(-2*q_r*q_y + 2*q_x*q_z)) &
      /m
ds(5, 1) = (-1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)*sqrt((v_x - v_xf)**2 + ( &
      v_y - v_yf)**2 + (v_z - v_zf)**2) + T*u*(-2*q_r*q_x + 2*q_y*q_z)) &
      /m
ds(6, 1) = (-1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)*sqrt((v_x - v_xf)**2 + ( &
      v_y - v_yf)**2 + (v_z - v_zf)**2) + T*u*(-2*q_x**2 - 2*q_y**2 + 1 &
      ))/m
ds(7, 1) = -1.0d0/2.0d0*omega*q_y*u_y + (1.0d0/2.0d0)*omega*q_z*u_x
ds(8, 1) = (1.0d0/2.0d0)*omega*q_y*u_x + (1.0d0/2.0d0)*omega*q_z*u_y
ds(9, 1) = (1.0d0/2.0d0)*omega*q_r*u_y - 1.0d0/2.0d0*omega*q_x*u_x
ds(10, 1) = -1.0d0/2.0d0*omega*q_r*u_x - 1.0d0/2.0d0*omega*q_x*u_y

end subroutine

subroutine jacobian_eom_state(x, y, z, v_x, v_y, v_z, q_r, q_x, q_y, &
      q_z, u, u_x, u_y, rho, v_zf, omega, m, T, v_yf, cd, A, v_xf, &
      dds)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: z
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: v_z
REAL*8, intent(in) :: q_r
REAL*8, intent(in) :: q_x
REAL*8, intent(in) :: q_y
REAL*8, intent(in) :: q_z
REAL*8, intent(in) :: u
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: rho
REAL*8, intent(in) :: v_zf
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: v_yf
REAL*8, intent(in) :: cd
REAL*8, intent(in) :: A
REAL*8, intent(in) :: v_xf
REAL*8, intent(out), dimension(1:10, 1:10) :: dds

dds(1, 1) = 0
dds(2, 1) = 0
dds(3, 1) = 0
dds(4, 1) = 0
dds(5, 1) = 0
dds(6, 1) = 0
dds(7, 1) = 0
dds(8, 1) = 0
dds(9, 1) = 0
dds(10, 1) = 0
dds(1, 2) = 0
dds(2, 2) = 0
dds(3, 2) = 0
dds(4, 2) = 0
dds(5, 2) = 0
dds(6, 2) = 0
dds(7, 2) = 0
dds(8, 2) = 0
dds(9, 2) = 0
dds(10, 2) = 0
dds(1, 3) = 0
dds(2, 3) = 0
dds(3, 3) = 0
dds(4, 3) = 0
dds(5, 3) = 0
dds(6, 3) = 0
dds(7, 3) = 0
dds(8, 3) = 0
dds(9, 3) = 0
dds(10, 3) = 0
dds(1, 4) = 1
dds(2, 4) = 0
dds(3, 4) = 0
dds(4, 4) = (-1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)**2/sqrt((v_x - v_xf)**2 &
      + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
dds(5, 4) = -1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*(v_y - v_yf)/(m*sqrt((v_x &
      - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
dds(6, 4) = -1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*(v_z - v_zf)/(m*sqrt((v_x &
      - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
dds(7, 4) = 0
dds(8, 4) = 0
dds(9, 4) = 0
dds(10, 4) = 0
dds(1, 5) = 0
dds(2, 5) = 1
dds(3, 5) = 0
dds(4, 5) = -1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*(v_y - v_yf)/(m*sqrt((v_x &
      - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
dds(5, 5) = (-1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)**2/sqrt((v_x - v_xf)**2 &
      + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
dds(6, 5) = -1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)*(v_z - v_zf)/(m*sqrt((v_x &
      - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
dds(7, 5) = 0
dds(8, 5) = 0
dds(9, 5) = 0
dds(10, 5) = 0
dds(1, 6) = 0
dds(2, 6) = 0
dds(3, 6) = 1
dds(4, 6) = -1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*(v_z - v_zf)/(m*sqrt((v_x &
      - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
dds(5, 6) = -1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)*(v_z - v_zf)/(m*sqrt((v_x &
      - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
dds(6, 6) = (-1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)**2/sqrt((v_x - v_xf)**2 &
      + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
dds(7, 6) = 0
dds(8, 6) = 0
dds(9, 6) = 0
dds(10, 6) = 0
dds(1, 7) = 0
dds(2, 7) = 0
dds(3, 7) = 0
dds(4, 7) = -2*T*q_y*u/m
dds(5, 7) = -2*T*q_x*u/m
dds(6, 7) = 0
dds(7, 7) = 0
dds(8, 7) = 0
dds(9, 7) = (1.0d0/2.0d0)*omega*u_y
dds(10, 7) = -1.0d0/2.0d0*omega*u_x
dds(1, 8) = 0
dds(2, 8) = 0
dds(3, 8) = 0
dds(4, 8) = 2*T*q_z*u/m
dds(5, 8) = -2*T*q_r*u/m
dds(6, 8) = -4*T*q_x*u/m
dds(7, 8) = 0
dds(8, 8) = 0
dds(9, 8) = -1.0d0/2.0d0*omega*u_x
dds(10, 8) = -1.0d0/2.0d0*omega*u_y
dds(1, 9) = 0
dds(2, 9) = 0
dds(3, 9) = 0
dds(4, 9) = -2*T*q_r*u/m
dds(5, 9) = 2*T*q_z*u/m
dds(6, 9) = -4*T*q_y*u/m
dds(7, 9) = -1.0d0/2.0d0*omega*u_y
dds(8, 9) = (1.0d0/2.0d0)*omega*u_x
dds(9, 9) = 0
dds(10, 9) = 0
dds(1, 10) = 0
dds(2, 10) = 0
dds(3, 10) = 0
dds(4, 10) = 2*T*q_x*u/m
dds(5, 10) = 2*T*q_y*u/m
dds(6, 10) = 0
dds(7, 10) = (1.0d0/2.0d0)*omega*u_x
dds(8, 10) = (1.0d0/2.0d0)*omega*u_y
dds(9, 10) = 0
dds(10, 10) = 0

end subroutine

subroutine eom_costate(x, y, z, v_x, v_y, v_z, q_r, q_x, q_y, q_z, &
      lambda_x, lambda_y, lambda_z, lambda_v_x, lambda_v_y, &
      lambda_v_z, lambda_q_r, lambda_q_x, lambda_q_y, lambda_q_z, &
      u, u_x, u_y, rho, v_zf, omega, m, T, v_yf, cd, A, v_xf, &
      alpha, dl)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: z
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: v_z
REAL*8, intent(in) :: q_r
REAL*8, intent(in) :: q_x
REAL*8, intent(in) :: q_y
REAL*8, intent(in) :: q_z
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_z
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: lambda_v_z
REAL*8, intent(in) :: lambda_q_r
REAL*8, intent(in) :: lambda_q_x
REAL*8, intent(in) :: lambda_q_y
REAL*8, intent(in) :: lambda_q_z
REAL*8, intent(in) :: u
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: rho
REAL*8, intent(in) :: v_zf
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: v_yf
REAL*8, intent(in) :: cd
REAL*8, intent(in) :: A
REAL*8, intent(in) :: v_xf
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:10, 1:1) :: dl

dl(1, 1) = 0
dl(2, 1) = 0
dl(3, 1) = 0
dl(4, 1) = (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_x - v_xf)*(v_y - v_yf)/( &
      m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) + ( &
      1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_x - v_xf)*(v_z - v_zf)/(m* &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) - &
      lambda_v_x*(-1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)**2/sqrt((v_x - &
      v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd* &
      rho*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m &
      - lambda_x
dl(5, 1) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(v_y - v_yf)/( &
      m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) + ( &
      1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_y - v_yf)*(v_z - v_zf)/(m* &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) - &
      lambda_v_y*(-1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)**2/sqrt((v_x - &
      v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd* &
      rho*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m &
      - lambda_y
dl(6, 1) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(v_z - v_zf)/( &
      m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) + ( &
      1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_y - v_yf)*(v_z - v_zf)/(m* &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) - &
      lambda_v_z*(-1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)**2/sqrt((v_x - &
      v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd* &
      rho*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m &
      - lambda_z
dl(7, 1) = 2*T*lambda_v_x*q_y*u/m + 2*T*lambda_v_y*q_x*u/m - 1.0d0/2.0d0 &
      *lambda_q_y*omega*u_y + (1.0d0/2.0d0)*lambda_q_z*omega*u_x
dl(8, 1) = -2*T*lambda_v_x*q_z*u/m + 2*T*lambda_v_y*q_r*u/m + 4*T* &
      lambda_v_z*q_x*u/m + (1.0d0/2.0d0)*lambda_q_y*omega*u_x + (1.0d0/ &
      2.0d0)*lambda_q_z*omega*u_y
dl(9, 1) = 2*T*lambda_v_x*q_r*u/m - 2*T*lambda_v_y*q_z*u/m + 4*T* &
      lambda_v_z*q_y*u/m + (1.0d0/2.0d0)*lambda_q_r*omega*u_y - 1.0d0/ &
      2.0d0*lambda_q_x*omega*u_x
dl(10, 1) = -2*T*lambda_v_x*q_x*u/m - 2*T*lambda_v_y*q_y*u/m - 1.0d0/ &
      2.0d0*lambda_q_r*omega*u_x - 1.0d0/2.0d0*lambda_q_x*omega*u_y

end subroutine

subroutine jacobian_eom_costate(x, y, z, v_x, v_y, v_z, q_r, q_x, q_y, &
      q_z, lambda_x, lambda_y, lambda_z, lambda_v_x, lambda_v_y, &
      lambda_v_z, lambda_q_r, lambda_q_x, lambda_q_y, lambda_q_z, &
      u, u_x, u_y, rho, v_zf, omega, m, T, v_yf, cd, A, v_xf, &
      alpha, ddl)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: z
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: v_z
REAL*8, intent(in) :: q_r
REAL*8, intent(in) :: q_x
REAL*8, intent(in) :: q_y
REAL*8, intent(in) :: q_z
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_z
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: lambda_v_z
REAL*8, intent(in) :: lambda_q_r
REAL*8, intent(in) :: lambda_q_x
REAL*8, intent(in) :: lambda_q_y
REAL*8, intent(in) :: lambda_q_z
REAL*8, intent(in) :: u
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: rho
REAL*8, intent(in) :: v_zf
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: v_yf
REAL*8, intent(in) :: cd
REAL*8, intent(in) :: A
REAL*8, intent(in) :: v_xf
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:10, 1:10) :: ddl

ddl(1, 1) = 0
ddl(2, 1) = 0
ddl(3, 1) = 0
ddl(4, 1) = 0
ddl(5, 1) = 0
ddl(6, 1) = 0
ddl(7, 1) = 0
ddl(8, 1) = 0
ddl(9, 1) = 0
ddl(10, 1) = 0
ddl(1, 2) = 0
ddl(2, 2) = 0
ddl(3, 2) = 0
ddl(4, 2) = 0
ddl(5, 2) = 0
ddl(6, 2) = 0
ddl(7, 2) = 0
ddl(8, 2) = 0
ddl(9, 2) = 0
ddl(10, 2) = 0
ddl(1, 3) = 0
ddl(2, 3) = 0
ddl(3, 3) = 0
ddl(4, 3) = 0
ddl(5, 3) = 0
ddl(6, 3) = 0
ddl(7, 3) = 0
ddl(8, 3) = 0
ddl(9, 3) = 0
ddl(10, 3) = 0
ddl(1, 4) = 0
ddl(2, 4) = 0
ddl(3, 4) = 0
ddl(4, 4) = (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(-v_x + v_xf)*(v_x - v_xf) &
      *(v_y - v_yf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_y - &
      v_yf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2 &
      )) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(-v_x + v_xf)*(v_x - v_xf) &
      *(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_z - &
      v_zf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2 &
      )) - lambda_v_x*(-1.0d0/2.0d0*A*cd*rho*(-v_x + v_xf)*(v_x - v_xf) &
      **2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)**(3.0d0 &
      /2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)/sqrt((v_x - v_xf)**2 &
      + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho*(2* &
      v_x - 2*v_xf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2))/m
ddl(5, 4) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(-v_x + v_xf)*(v_x - v_xf) &
      *(v_y - v_yf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_y - &
      v_yf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2 &
      )) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(-v_x + v_xf)*(v_y - v_yf) &
      *(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) - lambda_v_y*(-1.0d0/2.0d0*A*cd*rho*(-v_x + &
      v_xf)*(v_y - v_yf)**2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)/sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddl(6, 4) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(-v_x + v_xf)*(v_x - v_xf) &
      *(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_z - &
      v_zf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2 &
      )) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(-v_x + v_xf)*(v_y - v_yf) &
      *(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) - lambda_v_z*(-1.0d0/2.0d0*A*cd*rho*(-v_x + &
      v_xf)*(v_z - v_zf)**2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)/sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddl(7, 4) = 0
ddl(8, 4) = 0
ddl(9, 4) = 0
ddl(10, 4) = 0
ddl(1, 5) = 0
ddl(2, 5) = 0
ddl(3, 5) = 0
ddl(4, 5) = (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_x - v_xf)*(-v_y + v_yf) &
      *(v_y - v_yf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_x - &
      v_xf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2 &
      )) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_x - v_xf)*(-v_y + v_yf) &
      *(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) - lambda_v_x*(-1.0d0/2.0d0*A*cd*rho*(v_x - &
      v_xf)**2*(-v_y + v_yf)/((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z &
      - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)/ &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddl(5, 5) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(-v_y + v_yf) &
      *(v_y - v_yf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - &
      v_xf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2 &
      )) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(-v_y + v_yf)*(v_y - v_yf) &
      *(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_z - &
      v_zf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2 &
      )) - lambda_v_y*(-1.0d0/2.0d0*A*cd*rho*(-v_y + v_yf)*(v_y - v_yf) &
      **2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)**(3.0d0 &
      /2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)/sqrt((v_x - v_xf)**2 &
      + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho*(2* &
      v_y - 2*v_yf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2))/m
ddl(6, 5) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(-v_y + v_yf) &
      *(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(-v_y + &
      v_yf)*(v_y - v_yf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf &
      )**2 + (v_z - v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd* &
      lambda_v_y*rho*(v_z - v_zf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf &
      )**2 + (v_z - v_zf)**2)) - lambda_v_z*(-1.0d0/2.0d0*A*cd*rho*( &
      -v_y + v_yf)*(v_z - v_zf)**2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + &
      (v_z - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_y - &
      v_yf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/ &
      m
ddl(7, 5) = 0
ddl(8, 5) = 0
ddl(9, 5) = 0
ddl(10, 5) = 0
ddl(1, 6) = 0
ddl(2, 6) = 0
ddl(3, 6) = 0
ddl(4, 6) = (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_x - v_xf)*(v_y - v_yf)* &
      (-v_z + v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_x - &
      v_xf)*(-v_z + v_zf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - &
      v_yf)**2 + (v_z - v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd* &
      lambda_v_z*rho*(v_x - v_xf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf &
      )**2 + (v_z - v_zf)**2)) - lambda_v_x*(-1.0d0/2.0d0*A*cd*rho*(v_x &
      - v_xf)**2*(-v_z + v_zf)/((v_x - v_xf)**2 + (v_y - v_yf)**2 + ( &
      v_z - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_z - v_zf &
      )/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddl(5, 6) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(v_y - v_yf)* &
      (-v_z + v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_y - &
      v_yf)*(-v_z + v_zf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - &
      v_yf)**2 + (v_z - v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd* &
      lambda_v_z*rho*(v_y - v_yf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf &
      )**2 + (v_z - v_zf)**2)) - lambda_v_y*(-1.0d0/2.0d0*A*cd*rho*(v_y &
      - v_yf)**2*(-v_z + v_zf)/((v_x - v_xf)**2 + (v_y - v_yf)**2 + ( &
      v_z - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_z - v_zf &
      )/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddl(6, 6) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(-v_z + v_zf) &
      *(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - &
      v_xf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2 &
      )) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_y - v_yf)*(-v_z + v_zf) &
      *(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf &
      )**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_y - &
      v_yf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2 &
      )) - lambda_v_z*(-1.0d0/2.0d0*A*cd*rho*(-v_z + v_zf)*(v_z - v_zf) &
      **2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)**(3.0d0 &
      /2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)/sqrt((v_x - v_xf)**2 &
      + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho*(2* &
      v_z - 2*v_zf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2))/m
ddl(7, 6) = 0
ddl(8, 6) = 0
ddl(9, 6) = 0
ddl(10, 6) = 0
ddl(1, 7) = 0
ddl(2, 7) = 0
ddl(3, 7) = 0
ddl(4, 7) = 0
ddl(5, 7) = 0
ddl(6, 7) = 0
ddl(7, 7) = 0
ddl(8, 7) = 2*T*lambda_v_y*u/m
ddl(9, 7) = 2*T*lambda_v_x*u/m
ddl(10, 7) = 0
ddl(1, 8) = 0
ddl(2, 8) = 0
ddl(3, 8) = 0
ddl(4, 8) = 0
ddl(5, 8) = 0
ddl(6, 8) = 0
ddl(7, 8) = 2*T*lambda_v_y*u/m
ddl(8, 8) = 4*T*lambda_v_z*u/m
ddl(9, 8) = 0
ddl(10, 8) = -2*T*lambda_v_x*u/m
ddl(1, 9) = 0
ddl(2, 9) = 0
ddl(3, 9) = 0
ddl(4, 9) = 0
ddl(5, 9) = 0
ddl(6, 9) = 0
ddl(7, 9) = 2*T*lambda_v_x*u/m
ddl(8, 9) = 0
ddl(9, 9) = 4*T*lambda_v_z*u/m
ddl(10, 9) = -2*T*lambda_v_y*u/m
ddl(1, 10) = 0
ddl(2, 10) = 0
ddl(3, 10) = 0
ddl(4, 10) = 0
ddl(5, 10) = 0
ddl(6, 10) = 0
ddl(7, 10) = 0
ddl(8, 10) = -2*T*lambda_v_x*u/m
ddl(9, 10) = -2*T*lambda_v_y*u/m
ddl(10, 10) = 0

end subroutine

subroutine eom_fullstate(x, y, z, v_x, v_y, v_z, q_r, q_x, q_y, q_z, &
      lambda_x, lambda_y, lambda_z, lambda_v_x, lambda_v_y, &
      lambda_v_z, lambda_q_r, lambda_q_x, lambda_q_y, lambda_q_z, &
      u, u_x, u_y, rho, v_zf, omega, m, T, v_yf, cd, A, v_xf, &
      alpha, dfs)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: z
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: v_z
REAL*8, intent(in) :: q_r
REAL*8, intent(in) :: q_x
REAL*8, intent(in) :: q_y
REAL*8, intent(in) :: q_z
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_z
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: lambda_v_z
REAL*8, intent(in) :: lambda_q_r
REAL*8, intent(in) :: lambda_q_x
REAL*8, intent(in) :: lambda_q_y
REAL*8, intent(in) :: lambda_q_z
REAL*8, intent(in) :: u
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: rho
REAL*8, intent(in) :: v_zf
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: v_yf
REAL*8, intent(in) :: cd
REAL*8, intent(in) :: A
REAL*8, intent(in) :: v_xf
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:20, 1:1) :: dfs

dfs(1, 1) = v_x
dfs(2, 1) = v_y
dfs(3, 1) = v_z
dfs(4, 1) = (-1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*sqrt((v_x - v_xf)**2 + ( &
      v_y - v_yf)**2 + (v_z - v_zf)**2) + T*u*(-2*q_r*q_y + 2*q_x*q_z)) &
      /m
dfs(5, 1) = (-1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)*sqrt((v_x - v_xf)**2 + ( &
      v_y - v_yf)**2 + (v_z - v_zf)**2) + T*u*(-2*q_r*q_x + 2*q_y*q_z)) &
      /m
dfs(6, 1) = (-1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)*sqrt((v_x - v_xf)**2 + ( &
      v_y - v_yf)**2 + (v_z - v_zf)**2) + T*u*(-2*q_x**2 - 2*q_y**2 + 1 &
      ))/m
dfs(7, 1) = -1.0d0/2.0d0*omega*q_y*u_y + (1.0d0/2.0d0)*omega*q_z*u_x
dfs(8, 1) = (1.0d0/2.0d0)*omega*q_y*u_x + (1.0d0/2.0d0)*omega*q_z*u_y
dfs(9, 1) = (1.0d0/2.0d0)*omega*q_r*u_y - 1.0d0/2.0d0*omega*q_x*u_x
dfs(10, 1) = -1.0d0/2.0d0*omega*q_r*u_x - 1.0d0/2.0d0*omega*q_x*u_y
dfs(11, 1) = 0
dfs(12, 1) = 0
dfs(13, 1) = 0
dfs(14, 1) = (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_x - v_xf)*(v_y - v_yf) &
      /(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) + &
      (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_x - v_xf)*(v_z - v_zf)/(m* &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) - &
      lambda_v_x*(-1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)**2/sqrt((v_x - &
      v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd* &
      rho*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m &
      - lambda_x
dfs(15, 1) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(v_y - v_yf) &
      /(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) + &
      (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_y - v_yf)*(v_z - v_zf)/(m* &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) - &
      lambda_v_y*(-1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)**2/sqrt((v_x - &
      v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd* &
      rho*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m &
      - lambda_y
dfs(16, 1) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(v_z - v_zf) &
      /(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) + &
      (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_y - v_yf)*(v_z - v_zf)/(m* &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2)) - &
      lambda_v_z*(-1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)**2/sqrt((v_x - &
      v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd* &
      rho*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m &
      - lambda_z
dfs(17, 1) = 2*T*lambda_v_x*q_y*u/m + 2*T*lambda_v_y*q_x*u/m - 1.0d0/ &
      2.0d0*lambda_q_y*omega*u_y + (1.0d0/2.0d0)*lambda_q_z*omega*u_x
dfs(18, 1) = -2*T*lambda_v_x*q_z*u/m + 2*T*lambda_v_y*q_r*u/m + 4*T* &
      lambda_v_z*q_x*u/m + (1.0d0/2.0d0)*lambda_q_y*omega*u_x + (1.0d0/ &
      2.0d0)*lambda_q_z*omega*u_y
dfs(19, 1) = 2*T*lambda_v_x*q_r*u/m - 2*T*lambda_v_y*q_z*u/m + 4*T* &
      lambda_v_z*q_y*u/m + (1.0d0/2.0d0)*lambda_q_r*omega*u_y - 1.0d0/ &
      2.0d0*lambda_q_x*omega*u_x
dfs(20, 1) = -2*T*lambda_v_x*q_x*u/m - 2*T*lambda_v_y*q_y*u/m - 1.0d0/ &
      2.0d0*lambda_q_r*omega*u_x - 1.0d0/2.0d0*lambda_q_x*omega*u_y

end subroutine

subroutine jacobian_eom_fullstate(x, y, z, v_x, v_y, v_z, q_r, q_x, &
      q_y, q_z, lambda_x, lambda_y, lambda_z, lambda_v_x, &
      lambda_v_y, lambda_v_z, lambda_q_r, lambda_q_x, lambda_q_y, &
      lambda_q_z, u, u_x, u_y, rho, v_zf, omega, m, T, v_yf, cd, &
      A, v_xf, alpha, ddfs)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: z
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: v_z
REAL*8, intent(in) :: q_r
REAL*8, intent(in) :: q_x
REAL*8, intent(in) :: q_y
REAL*8, intent(in) :: q_z
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_z
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: lambda_v_z
REAL*8, intent(in) :: lambda_q_r
REAL*8, intent(in) :: lambda_q_x
REAL*8, intent(in) :: lambda_q_y
REAL*8, intent(in) :: lambda_q_z
REAL*8, intent(in) :: u
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: rho
REAL*8, intent(in) :: v_zf
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: v_yf
REAL*8, intent(in) :: cd
REAL*8, intent(in) :: A
REAL*8, intent(in) :: v_xf
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:20, 1:20) :: ddfs

ddfs(1, 1) = 0
ddfs(2, 1) = 0
ddfs(3, 1) = 0
ddfs(4, 1) = 0
ddfs(5, 1) = 0
ddfs(6, 1) = 0
ddfs(7, 1) = 0
ddfs(8, 1) = 0
ddfs(9, 1) = 0
ddfs(10, 1) = 0
ddfs(11, 1) = 0
ddfs(12, 1) = 0
ddfs(13, 1) = 0
ddfs(14, 1) = 0
ddfs(15, 1) = 0
ddfs(16, 1) = 0
ddfs(17, 1) = 0
ddfs(18, 1) = 0
ddfs(19, 1) = 0
ddfs(20, 1) = 0
ddfs(1, 2) = 0
ddfs(2, 2) = 0
ddfs(3, 2) = 0
ddfs(4, 2) = 0
ddfs(5, 2) = 0
ddfs(6, 2) = 0
ddfs(7, 2) = 0
ddfs(8, 2) = 0
ddfs(9, 2) = 0
ddfs(10, 2) = 0
ddfs(11, 2) = 0
ddfs(12, 2) = 0
ddfs(13, 2) = 0
ddfs(14, 2) = 0
ddfs(15, 2) = 0
ddfs(16, 2) = 0
ddfs(17, 2) = 0
ddfs(18, 2) = 0
ddfs(19, 2) = 0
ddfs(20, 2) = 0
ddfs(1, 3) = 0
ddfs(2, 3) = 0
ddfs(3, 3) = 0
ddfs(4, 3) = 0
ddfs(5, 3) = 0
ddfs(6, 3) = 0
ddfs(7, 3) = 0
ddfs(8, 3) = 0
ddfs(9, 3) = 0
ddfs(10, 3) = 0
ddfs(11, 3) = 0
ddfs(12, 3) = 0
ddfs(13, 3) = 0
ddfs(14, 3) = 0
ddfs(15, 3) = 0
ddfs(16, 3) = 0
ddfs(17, 3) = 0
ddfs(18, 3) = 0
ddfs(19, 3) = 0
ddfs(20, 3) = 0
ddfs(1, 4) = 1
ddfs(2, 4) = 0
ddfs(3, 4) = 0
ddfs(4, 4) = (-1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)**2/sqrt((v_x - v_xf)**2 &
      + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddfs(5, 4) = -1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*(v_y - v_yf)/(m*sqrt(( &
      v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(6, 4) = -1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*(v_z - v_zf)/(m*sqrt(( &
      v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(7, 4) = 0
ddfs(8, 4) = 0
ddfs(9, 4) = 0
ddfs(10, 4) = 0
ddfs(11, 4) = 0
ddfs(12, 4) = 0
ddfs(13, 4) = 0
ddfs(14, 4) = (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(-v_x + v_xf)*(v_x - &
      v_xf)*(v_y - v_yf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*( &
      v_y - v_yf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(-v_x + v_xf)*(v_x &
      - v_xf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z &
      - v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*( &
      v_z - v_zf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)) - lambda_v_x*(-1.0d0/2.0d0*A*cd*rho*(-v_x + v_xf)*(v_x &
      - v_xf)**2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) &
      **(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)/sqrt((v_x - &
      v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd* &
      rho*(2*v_x - 2*v_xf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + ( &
      v_z - v_zf)**2))/m
ddfs(15, 4) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(-v_x + v_xf)*(v_x - &
      v_xf)*(v_y - v_yf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*( &
      v_y - v_yf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(-v_x + v_xf)*(v_y &
      - v_yf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z &
      - v_zf)**2)**(3.0d0/2.0d0)) - lambda_v_y*(-1.0d0/2.0d0*A*cd*rho*( &
      -v_x + v_xf)*(v_y - v_yf)**2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + &
      (v_z - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_x - &
      v_xf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/ &
      m
ddfs(16, 4) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(-v_x + v_xf)*(v_x - &
      v_xf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*( &
      v_z - v_zf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(-v_x + v_xf)*(v_y &
      - v_yf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z &
      - v_zf)**2)**(3.0d0/2.0d0)) - lambda_v_z*(-1.0d0/2.0d0*A*cd*rho*( &
      -v_x + v_xf)*(v_z - v_zf)**2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + &
      (v_z - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_x - &
      v_xf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/ &
      m
ddfs(17, 4) = 0
ddfs(18, 4) = 0
ddfs(19, 4) = 0
ddfs(20, 4) = 0
ddfs(1, 5) = 0
ddfs(2, 5) = 1
ddfs(3, 5) = 0
ddfs(4, 5) = -1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*(v_y - v_yf)/(m*sqrt(( &
      v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(5, 5) = (-1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)**2/sqrt((v_x - v_xf)**2 &
      + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddfs(6, 5) = -1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)*(v_z - v_zf)/(m*sqrt(( &
      v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(7, 5) = 0
ddfs(8, 5) = 0
ddfs(9, 5) = 0
ddfs(10, 5) = 0
ddfs(11, 5) = 0
ddfs(12, 5) = 0
ddfs(13, 5) = 0
ddfs(14, 5) = (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_x - v_xf)*(-v_y + &
      v_yf)*(v_y - v_yf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*( &
      v_x - v_xf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(v_x - v_xf)*(-v_y &
      + v_yf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z &
      - v_zf)**2)**(3.0d0/2.0d0)) - lambda_v_x*(-1.0d0/2.0d0*A*cd*rho*( &
      v_x - v_xf)**2*(-v_y + v_yf)/((v_x - v_xf)**2 + (v_y - v_yf)**2 + &
      (v_z - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_y - &
      v_yf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/ &
      m
ddfs(15, 5) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(-v_y + &
      v_yf)*(v_y - v_yf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*( &
      v_x - v_xf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*(-v_y + v_yf)*(v_y &
      - v_yf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z &
      - v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*( &
      v_z - v_zf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)) - lambda_v_y*(-1.0d0/2.0d0*A*cd*rho*(-v_y + v_yf)*(v_y &
      - v_yf)**2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) &
      **(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)/sqrt((v_x - &
      v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd* &
      rho*(2*v_y - 2*v_yf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + ( &
      v_z - v_zf)**2))/m
ddfs(16, 5) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(-v_y + &
      v_yf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*( &
      -v_y + v_yf)*(v_y - v_yf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y &
      - v_yf)**2 + (v_z - v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A* &
      cd*lambda_v_y*rho*(v_z - v_zf)/(m*sqrt((v_x - v_xf)**2 + (v_y - &
      v_yf)**2 + (v_z - v_zf)**2)) - lambda_v_z*(-1.0d0/2.0d0*A*cd*rho* &
      (-v_y + v_yf)*(v_z - v_zf)**2/((v_x - v_xf)**2 + (v_y - v_yf)**2 &
      + (v_z - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_y - &
      v_yf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/ &
      m
ddfs(17, 5) = 0
ddfs(18, 5) = 0
ddfs(19, 5) = 0
ddfs(20, 5) = 0
ddfs(1, 6) = 0
ddfs(2, 6) = 0
ddfs(3, 6) = 1
ddfs(4, 6) = -1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*(v_z - v_zf)/(m*sqrt(( &
      v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(5, 6) = -1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)*(v_z - v_zf)/(m*sqrt(( &
      v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(6, 6) = (-1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)**2/sqrt((v_x - v_xf)**2 &
      + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddfs(7, 6) = 0
ddfs(8, 6) = 0
ddfs(9, 6) = 0
ddfs(10, 6) = 0
ddfs(11, 6) = 0
ddfs(12, 6) = 0
ddfs(13, 6) = 0
ddfs(14, 6) = (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_x - v_xf)*(v_y - v_yf &
      )*(-v_z + v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*( &
      v_x - v_xf)*(-v_z + v_zf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y &
      - v_yf)**2 + (v_z - v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A* &
      cd*lambda_v_z*rho*(v_x - v_xf)/(m*sqrt((v_x - v_xf)**2 + (v_y - &
      v_yf)**2 + (v_z - v_zf)**2)) - lambda_v_x*(-1.0d0/2.0d0*A*cd*rho* &
      (v_x - v_xf)**2*(-v_z + v_zf)/((v_x - v_xf)**2 + (v_y - v_yf)**2 &
      + (v_z - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_z - &
      v_zf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/ &
      m
ddfs(15, 6) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(v_y - v_yf &
      )*(-v_z + v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_z*rho*( &
      v_y - v_yf)*(-v_z + v_zf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y &
      - v_yf)**2 + (v_z - v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A* &
      cd*lambda_v_z*rho*(v_y - v_yf)/(m*sqrt((v_x - v_xf)**2 + (v_y - &
      v_yf)**2 + (v_z - v_zf)**2)) - lambda_v_y*(-1.0d0/2.0d0*A*cd*rho* &
      (v_y - v_yf)**2*(-v_z + v_zf)/((v_x - v_xf)**2 + (v_y - v_yf)**2 &
      + (v_z - v_zf)**2)**(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_z - &
      v_zf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/ &
      m
ddfs(16, 6) = (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*(v_x - v_xf)*(-v_z + &
      v_zf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_x*rho*( &
      v_x - v_xf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*(v_y - v_yf)*(-v_z &
      + v_zf)*(v_z - v_zf)/(m*((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z &
      - v_zf)**2)**(3.0d0/2.0d0)) + (1.0d0/2.0d0)*A*cd*lambda_v_y*rho*( &
      v_y - v_yf)/(m*sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - &
      v_zf)**2)) - lambda_v_z*(-1.0d0/2.0d0*A*cd*rho*(-v_z + v_zf)*(v_z &
      - v_zf)**2/((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) &
      **(3.0d0/2.0d0) - 1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)/sqrt((v_x - &
      v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd* &
      rho*(2*v_z - 2*v_zf)/sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + ( &
      v_z - v_zf)**2))/m
ddfs(17, 6) = 0
ddfs(18, 6) = 0
ddfs(19, 6) = 0
ddfs(20, 6) = 0
ddfs(1, 7) = 0
ddfs(2, 7) = 0
ddfs(3, 7) = 0
ddfs(4, 7) = -2*T*q_y*u/m
ddfs(5, 7) = -2*T*q_x*u/m
ddfs(6, 7) = 0
ddfs(7, 7) = 0
ddfs(8, 7) = 0
ddfs(9, 7) = (1.0d0/2.0d0)*omega*u_y
ddfs(10, 7) = -1.0d0/2.0d0*omega*u_x
ddfs(11, 7) = 0
ddfs(12, 7) = 0
ddfs(13, 7) = 0
ddfs(14, 7) = 0
ddfs(15, 7) = 0
ddfs(16, 7) = 0
ddfs(17, 7) = 0
ddfs(18, 7) = 2*T*lambda_v_y*u/m
ddfs(19, 7) = 2*T*lambda_v_x*u/m
ddfs(20, 7) = 0
ddfs(1, 8) = 0
ddfs(2, 8) = 0
ddfs(3, 8) = 0
ddfs(4, 8) = 2*T*q_z*u/m
ddfs(5, 8) = -2*T*q_r*u/m
ddfs(6, 8) = -4*T*q_x*u/m
ddfs(7, 8) = 0
ddfs(8, 8) = 0
ddfs(9, 8) = -1.0d0/2.0d0*omega*u_x
ddfs(10, 8) = -1.0d0/2.0d0*omega*u_y
ddfs(11, 8) = 0
ddfs(12, 8) = 0
ddfs(13, 8) = 0
ddfs(14, 8) = 0
ddfs(15, 8) = 0
ddfs(16, 8) = 0
ddfs(17, 8) = 2*T*lambda_v_y*u/m
ddfs(18, 8) = 4*T*lambda_v_z*u/m
ddfs(19, 8) = 0
ddfs(20, 8) = -2*T*lambda_v_x*u/m
ddfs(1, 9) = 0
ddfs(2, 9) = 0
ddfs(3, 9) = 0
ddfs(4, 9) = -2*T*q_r*u/m
ddfs(5, 9) = 2*T*q_z*u/m
ddfs(6, 9) = -4*T*q_y*u/m
ddfs(7, 9) = -1.0d0/2.0d0*omega*u_y
ddfs(8, 9) = (1.0d0/2.0d0)*omega*u_x
ddfs(9, 9) = 0
ddfs(10, 9) = 0
ddfs(11, 9) = 0
ddfs(12, 9) = 0
ddfs(13, 9) = 0
ddfs(14, 9) = 0
ddfs(15, 9) = 0
ddfs(16, 9) = 0
ddfs(17, 9) = 2*T*lambda_v_x*u/m
ddfs(18, 9) = 0
ddfs(19, 9) = 4*T*lambda_v_z*u/m
ddfs(20, 9) = -2*T*lambda_v_y*u/m
ddfs(1, 10) = 0
ddfs(2, 10) = 0
ddfs(3, 10) = 0
ddfs(4, 10) = 2*T*q_x*u/m
ddfs(5, 10) = 2*T*q_y*u/m
ddfs(6, 10) = 0
ddfs(7, 10) = (1.0d0/2.0d0)*omega*u_x
ddfs(8, 10) = (1.0d0/2.0d0)*omega*u_y
ddfs(9, 10) = 0
ddfs(10, 10) = 0
ddfs(11, 10) = 0
ddfs(12, 10) = 0
ddfs(13, 10) = 0
ddfs(14, 10) = 0
ddfs(15, 10) = 0
ddfs(16, 10) = 0
ddfs(17, 10) = 0
ddfs(18, 10) = -2*T*lambda_v_x*u/m
ddfs(19, 10) = -2*T*lambda_v_y*u/m
ddfs(20, 10) = 0
ddfs(1, 11) = 0
ddfs(2, 11) = 0
ddfs(3, 11) = 0
ddfs(4, 11) = 0
ddfs(5, 11) = 0
ddfs(6, 11) = 0
ddfs(7, 11) = 0
ddfs(8, 11) = 0
ddfs(9, 11) = 0
ddfs(10, 11) = 0
ddfs(11, 11) = 0
ddfs(12, 11) = 0
ddfs(13, 11) = 0
ddfs(14, 11) = -1
ddfs(15, 11) = 0
ddfs(16, 11) = 0
ddfs(17, 11) = 0
ddfs(18, 11) = 0
ddfs(19, 11) = 0
ddfs(20, 11) = 0
ddfs(1, 12) = 0
ddfs(2, 12) = 0
ddfs(3, 12) = 0
ddfs(4, 12) = 0
ddfs(5, 12) = 0
ddfs(6, 12) = 0
ddfs(7, 12) = 0
ddfs(8, 12) = 0
ddfs(9, 12) = 0
ddfs(10, 12) = 0
ddfs(11, 12) = 0
ddfs(12, 12) = 0
ddfs(13, 12) = 0
ddfs(14, 12) = 0
ddfs(15, 12) = -1
ddfs(16, 12) = 0
ddfs(17, 12) = 0
ddfs(18, 12) = 0
ddfs(19, 12) = 0
ddfs(20, 12) = 0
ddfs(1, 13) = 0
ddfs(2, 13) = 0
ddfs(3, 13) = 0
ddfs(4, 13) = 0
ddfs(5, 13) = 0
ddfs(6, 13) = 0
ddfs(7, 13) = 0
ddfs(8, 13) = 0
ddfs(9, 13) = 0
ddfs(10, 13) = 0
ddfs(11, 13) = 0
ddfs(12, 13) = 0
ddfs(13, 13) = 0
ddfs(14, 13) = 0
ddfs(15, 13) = 0
ddfs(16, 13) = -1
ddfs(17, 13) = 0
ddfs(18, 13) = 0
ddfs(19, 13) = 0
ddfs(20, 13) = 0
ddfs(1, 14) = 0
ddfs(2, 14) = 0
ddfs(3, 14) = 0
ddfs(4, 14) = 0
ddfs(5, 14) = 0
ddfs(6, 14) = 0
ddfs(7, 14) = 0
ddfs(8, 14) = 0
ddfs(9, 14) = 0
ddfs(10, 14) = 0
ddfs(11, 14) = 0
ddfs(12, 14) = 0
ddfs(13, 14) = 0
ddfs(14, 14) = -(-1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)**2/sqrt((v_x - v_xf) &
      **2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho* &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddfs(15, 14) = (1.0d0/2.0d0)*A*cd*rho*(v_x - v_xf)*(v_y - v_yf)/(m*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(16, 14) = (1.0d0/2.0d0)*A*cd*rho*(v_x - v_xf)*(v_z - v_zf)/(m*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(17, 14) = 2*T*q_y*u/m
ddfs(18, 14) = -2*T*q_z*u/m
ddfs(19, 14) = 2*T*q_r*u/m
ddfs(20, 14) = -2*T*q_x*u/m
ddfs(1, 15) = 0
ddfs(2, 15) = 0
ddfs(3, 15) = 0
ddfs(4, 15) = 0
ddfs(5, 15) = 0
ddfs(6, 15) = 0
ddfs(7, 15) = 0
ddfs(8, 15) = 0
ddfs(9, 15) = 0
ddfs(10, 15) = 0
ddfs(11, 15) = 0
ddfs(12, 15) = 0
ddfs(13, 15) = 0
ddfs(14, 15) = (1.0d0/2.0d0)*A*cd*rho*(v_x - v_xf)*(v_y - v_yf)/(m*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(15, 15) = -(-1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)**2/sqrt((v_x - v_xf) &
      **2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho* &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddfs(16, 15) = (1.0d0/2.0d0)*A*cd*rho*(v_y - v_yf)*(v_z - v_zf)/(m*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(17, 15) = 2*T*q_x*u/m
ddfs(18, 15) = 2*T*q_r*u/m
ddfs(19, 15) = -2*T*q_z*u/m
ddfs(20, 15) = -2*T*q_y*u/m
ddfs(1, 16) = 0
ddfs(2, 16) = 0
ddfs(3, 16) = 0
ddfs(4, 16) = 0
ddfs(5, 16) = 0
ddfs(6, 16) = 0
ddfs(7, 16) = 0
ddfs(8, 16) = 0
ddfs(9, 16) = 0
ddfs(10, 16) = 0
ddfs(11, 16) = 0
ddfs(12, 16) = 0
ddfs(13, 16) = 0
ddfs(14, 16) = (1.0d0/2.0d0)*A*cd*rho*(v_x - v_xf)*(v_z - v_zf)/(m*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(15, 16) = (1.0d0/2.0d0)*A*cd*rho*(v_y - v_yf)*(v_z - v_zf)/(m*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))
ddfs(16, 16) = -(-1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)**2/sqrt((v_x - v_xf) &
      **2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) - 1.0d0/2.0d0*A*cd*rho* &
      sqrt((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2))/m
ddfs(17, 16) = 0
ddfs(18, 16) = 4*T*q_x*u/m
ddfs(19, 16) = 4*T*q_y*u/m
ddfs(20, 16) = 0
ddfs(1, 17) = 0
ddfs(2, 17) = 0
ddfs(3, 17) = 0
ddfs(4, 17) = 0
ddfs(5, 17) = 0
ddfs(6, 17) = 0
ddfs(7, 17) = 0
ddfs(8, 17) = 0
ddfs(9, 17) = 0
ddfs(10, 17) = 0
ddfs(11, 17) = 0
ddfs(12, 17) = 0
ddfs(13, 17) = 0
ddfs(14, 17) = 0
ddfs(15, 17) = 0
ddfs(16, 17) = 0
ddfs(17, 17) = 0
ddfs(18, 17) = 0
ddfs(19, 17) = (1.0d0/2.0d0)*omega*u_y
ddfs(20, 17) = -1.0d0/2.0d0*omega*u_x
ddfs(1, 18) = 0
ddfs(2, 18) = 0
ddfs(3, 18) = 0
ddfs(4, 18) = 0
ddfs(5, 18) = 0
ddfs(6, 18) = 0
ddfs(7, 18) = 0
ddfs(8, 18) = 0
ddfs(9, 18) = 0
ddfs(10, 18) = 0
ddfs(11, 18) = 0
ddfs(12, 18) = 0
ddfs(13, 18) = 0
ddfs(14, 18) = 0
ddfs(15, 18) = 0
ddfs(16, 18) = 0
ddfs(17, 18) = 0
ddfs(18, 18) = 0
ddfs(19, 18) = -1.0d0/2.0d0*omega*u_x
ddfs(20, 18) = -1.0d0/2.0d0*omega*u_y
ddfs(1, 19) = 0
ddfs(2, 19) = 0
ddfs(3, 19) = 0
ddfs(4, 19) = 0
ddfs(5, 19) = 0
ddfs(6, 19) = 0
ddfs(7, 19) = 0
ddfs(8, 19) = 0
ddfs(9, 19) = 0
ddfs(10, 19) = 0
ddfs(11, 19) = 0
ddfs(12, 19) = 0
ddfs(13, 19) = 0
ddfs(14, 19) = 0
ddfs(15, 19) = 0
ddfs(16, 19) = 0
ddfs(17, 19) = -1.0d0/2.0d0*omega*u_y
ddfs(18, 19) = (1.0d0/2.0d0)*omega*u_x
ddfs(19, 19) = 0
ddfs(20, 19) = 0
ddfs(1, 20) = 0
ddfs(2, 20) = 0
ddfs(3, 20) = 0
ddfs(4, 20) = 0
ddfs(5, 20) = 0
ddfs(6, 20) = 0
ddfs(7, 20) = 0
ddfs(8, 20) = 0
ddfs(9, 20) = 0
ddfs(10, 20) = 0
ddfs(11, 20) = 0
ddfs(12, 20) = 0
ddfs(13, 20) = 0
ddfs(14, 20) = 0
ddfs(15, 20) = 0
ddfs(16, 20) = 0
ddfs(17, 20) = (1.0d0/2.0d0)*omega*u_x
ddfs(18, 20) = (1.0d0/2.0d0)*omega*u_y
ddfs(19, 20) = 0
ddfs(20, 20) = 0

end subroutine

subroutine lagrangian(x, y, z, v_x, v_y, v_z, q_r, q_x, q_y, q_z, u, &
      u_x, u_y, rho, v_zf, omega, m, T, v_yf, cd, A, v_xf, alpha, &
      L)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: z
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: v_z
REAL*8, intent(in) :: q_r
REAL*8, intent(in) :: q_x
REAL*8, intent(in) :: q_y
REAL*8, intent(in) :: q_z
REAL*8, intent(in) :: u
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: rho
REAL*8, intent(in) :: v_zf
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: v_yf
REAL*8, intent(in) :: cd
REAL*8, intent(in) :: A
REAL*8, intent(in) :: v_xf
REAL*8, intent(in) :: alpha
REAL*8, intent(out) :: L

L = alpha*(u + u_x**2 + u_y**2) + (-alpha + 1)*(u**2 + u_x**2 + u_y**2)

end subroutine

subroutine hamiltonian(x, y, z, v_x, v_y, v_z, q_r, q_x, q_y, q_z, &
      lambda_x, lambda_y, lambda_z, lambda_v_x, lambda_v_y, &
      lambda_v_z, lambda_q_r, lambda_q_x, lambda_q_y, lambda_q_z, &
      u, u_x, u_y, rho, v_zf, omega, m, T, v_yf, cd, A, v_xf, &
      alpha, H)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: z
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: v_z
REAL*8, intent(in) :: q_r
REAL*8, intent(in) :: q_x
REAL*8, intent(in) :: q_y
REAL*8, intent(in) :: q_z
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_z
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: lambda_v_z
REAL*8, intent(in) :: lambda_q_r
REAL*8, intent(in) :: lambda_q_x
REAL*8, intent(in) :: lambda_q_y
REAL*8, intent(in) :: lambda_q_z
REAL*8, intent(in) :: u
REAL*8, intent(in) :: u_x
REAL*8, intent(in) :: u_y
REAL*8, intent(in) :: rho
REAL*8, intent(in) :: v_zf
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: v_yf
REAL*8, intent(in) :: cd
REAL*8, intent(in) :: A
REAL*8, intent(in) :: v_xf
REAL*8, intent(in) :: alpha
REAL*8, intent(out) :: H

H = alpha*(u + u_x**2 + u_y**2) + lambda_q_r*(-1.0d0/2.0d0*omega*q_y*u_y &
      + (1.0d0/2.0d0)*omega*q_z*u_x) + lambda_q_x*((1.0d0/2.0d0)*omega* &
      q_y*u_x + (1.0d0/2.0d0)*omega*q_z*u_y) + lambda_q_y*((1.0d0/2.0d0 &
      )*omega*q_r*u_y - 1.0d0/2.0d0*omega*q_x*u_x) + lambda_q_z*(-1.0d0 &
      /2.0d0*omega*q_r*u_x - 1.0d0/2.0d0*omega*q_x*u_y) + lambda_v_x*( &
      -1.0d0/2.0d0*A*cd*rho*(v_x - v_xf)*sqrt((v_x - v_xf)**2 + (v_y - &
      v_yf)**2 + (v_z - v_zf)**2) + T*u*(-2*q_r*q_y + 2*q_x*q_z))/m + &
      lambda_v_y*(-1.0d0/2.0d0*A*cd*rho*(v_y - v_yf)*sqrt((v_x - v_xf) &
      **2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) + T*u*(-2*q_r*q_x + 2* &
      q_y*q_z))/m + lambda_v_z*(-1.0d0/2.0d0*A*cd*rho*(v_z - v_zf)*sqrt &
      ((v_x - v_xf)**2 + (v_y - v_yf)**2 + (v_z - v_zf)**2) + T*u*(-2* &
      q_x**2 - 2*q_y**2 + 1))/m + lambda_x*v_x + lambda_y*v_y + &
      lambda_z*v_z + (-alpha + 1)*(u**2 + u_x**2 + u_y**2)

end subroutine

subroutine control(x, y, z, v_x, v_y, v_z, q_r, q_x, q_y, q_z, &
      lambda_x, lambda_y, lambda_z, lambda_v_x, lambda_v_y, &
      lambda_v_z, lambda_q_r, lambda_q_x, lambda_q_y, lambda_q_z, &
      rho, v_zf, omega, m, T, v_yf, cd, A, v_xf, alpha, uo)
implicit none
REAL*8, intent(in) :: x
REAL*8, intent(in) :: y
REAL*8, intent(in) :: z
REAL*8, intent(in) :: v_x
REAL*8, intent(in) :: v_y
REAL*8, intent(in) :: v_z
REAL*8, intent(in) :: q_r
REAL*8, intent(in) :: q_x
REAL*8, intent(in) :: q_y
REAL*8, intent(in) :: q_z
REAL*8, intent(in) :: lambda_x
REAL*8, intent(in) :: lambda_y
REAL*8, intent(in) :: lambda_z
REAL*8, intent(in) :: lambda_v_x
REAL*8, intent(in) :: lambda_v_y
REAL*8, intent(in) :: lambda_v_z
REAL*8, intent(in) :: lambda_q_r
REAL*8, intent(in) :: lambda_q_x
REAL*8, intent(in) :: lambda_q_y
REAL*8, intent(in) :: lambda_q_z
REAL*8, intent(in) :: rho
REAL*8, intent(in) :: v_zf
REAL*8, intent(in) :: omega
REAL*8, intent(in) :: m
REAL*8, intent(in) :: T
REAL*8, intent(in) :: v_yf
REAL*8, intent(in) :: cd
REAL*8, intent(in) :: A
REAL*8, intent(in) :: v_xf
REAL*8, intent(in) :: alpha
REAL*8, intent(out), dimension(1:3, 1:1) :: uo

uo(1, 1) = (-T*lambda_v_x*q_r*q_y + T*lambda_v_x*q_x*q_z - T*lambda_v_y* &
      q_r*q_x + T*lambda_v_y*q_y*q_z - T*lambda_v_z*q_x**2 - T* &
      lambda_v_z*q_y**2 + (1.0d0/2.0d0)*T*lambda_v_z + (1.0d0/2.0d0)* &
      alpha*m)/(m*(alpha - 1))
uo(2, 1) = (1.0d0/4.0d0)*omega*(-lambda_q_r*q_z - lambda_q_x*q_y + &
      lambda_q_y*q_x + lambda_q_z*q_r)
uo(3, 1) = (1.0d0/4.0d0)*omega*(lambda_q_r*q_y - lambda_q_x*q_z - &
      lambda_q_y*q_r + lambda_q_z*q_x)

end subroutine
