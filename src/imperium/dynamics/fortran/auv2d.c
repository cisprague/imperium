#include "auv2d.h"
#include <math.h>

void eom_state(double x, double y, double v_x, double v_y, double u_t, double u_x, double u_y, double T, double m, double *ds) {

   ds[0] = v_x;
   ds[1] = v_y;
   ds[2] = T*u_t*u_x/m;
   ds[3] = T*u_t*u_y/m;

}

void jacobian_eom_state(double x, double y, double v_x, double v_y, double u_t, double u_x, double u_y, double T, double m, double *dds) {

   dds[0] = 0;
   dds[1] = 0;
   dds[2] = 1;
   dds[3] = 0;
   dds[4] = 0;
   dds[5] = 0;
   dds[6] = 0;
   dds[7] = 1;
   dds[8] = 0;
   dds[9] = 0;
   dds[10] = 0;
   dds[11] = 0;
   dds[12] = 0;
   dds[13] = 0;
   dds[14] = 0;
   dds[15] = 0;

}

void eom_costate(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *dl) {

   dl[0] = 0;
   dl[1] = 0;
   dl[2] = -lambda_x;
   dl[3] = -lambda_y;

}

void jacobian_eom_costate(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *ddl) {

   ddl[0] = 0;
   ddl[1] = 0;
   ddl[2] = 0;
   ddl[3] = 0;
   ddl[4] = 0;
   ddl[5] = 0;
   ddl[6] = 0;
   ddl[7] = 0;
   ddl[8] = 0;
   ddl[9] = 0;
   ddl[10] = 0;
   ddl[11] = 0;
   ddl[12] = 0;
   ddl[13] = 0;
   ddl[14] = 0;
   ddl[15] = 0;

}

void eom_fullstate(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *dfs) {

   dfs[0] = v_x;
   dfs[1] = v_y;
   dfs[2] = T*u_t*u_x/m;
   dfs[3] = T*u_t*u_y/m;
   dfs[4] = 0;
   dfs[5] = 0;
   dfs[6] = -lambda_x;
   dfs[7] = -lambda_y;

}

void jacobian_eom_fullstate(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *ddfs) {

   ddfs[0] = 0;
   ddfs[1] = 0;
   ddfs[2] = 1;
   ddfs[3] = 0;
   ddfs[4] = 0;
   ddfs[5] = 0;
   ddfs[6] = 0;
   ddfs[7] = 0;
   ddfs[8] = 0;
   ddfs[9] = 0;
   ddfs[10] = 0;
   ddfs[11] = 1;
   ddfs[12] = 0;
   ddfs[13] = 0;
   ddfs[14] = 0;
   ddfs[15] = 0;
   ddfs[16] = 0;
   ddfs[17] = 0;
   ddfs[18] = 0;
   ddfs[19] = 0;
   ddfs[20] = 0;
   ddfs[21] = 0;
   ddfs[22] = 0;
   ddfs[23] = 0;
   ddfs[24] = 0;
   ddfs[25] = 0;
   ddfs[26] = 0;
   ddfs[27] = 0;
   ddfs[28] = 0;
   ddfs[29] = 0;
   ddfs[30] = 0;
   ddfs[31] = 0;
   ddfs[32] = 0;
   ddfs[33] = 0;
   ddfs[34] = 0;
   ddfs[35] = 0;
   ddfs[36] = 0;
   ddfs[37] = 0;
   ddfs[38] = 0;
   ddfs[39] = 0;
   ddfs[40] = 0;
   ddfs[41] = 0;
   ddfs[42] = 0;
   ddfs[43] = 0;
   ddfs[44] = 0;
   ddfs[45] = 0;
   ddfs[46] = 0;
   ddfs[47] = 0;
   ddfs[48] = 0;
   ddfs[49] = 0;
   ddfs[50] = 0;
   ddfs[51] = 0;
   ddfs[52] = -1;
   ddfs[53] = 0;
   ddfs[54] = 0;
   ddfs[55] = 0;
   ddfs[56] = 0;
   ddfs[57] = 0;
   ddfs[58] = 0;
   ddfs[59] = 0;
   ddfs[60] = 0;
   ddfs[61] = -1;
   ddfs[62] = 0;
   ddfs[63] = 0;

}

void lagrangian(double x, double y, double v_x, double v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *L) {

   (*L) = alpha*u_t + pow(u_t, 2)*(-alpha + 1);

}

void hamiltonian(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *H) {

   (*H) = T*lambda_v_x*u_t*u_x/m + T*lambda_v_y*u_t*u_y/m + alpha*u_t + lambda_x*v_x + lambda_y*v_y + pow(u_t, 2)*(-alpha + 1);

}

void control(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double T, double m, double alpha, double *uo) {

   uo[0] = (1.0L/2.0L)*(-T*pow(lambda_v_x, 2) - T*pow(lambda_v_y, 2) + alpha*m*sqrt(pow(lambda_v_x, 2) + pow(lambda_v_y, 2)))/(m*(alpha - 1)*sqrt(pow(lambda_v_x, 2) + pow(lambda_v_y, 2)));
   uo[1] = -lambda_v_x/sqrt(pow(lambda_v_x, 2) + pow(lambda_v_y, 2));
   uo[2] = -lambda_v_y/sqrt(pow(lambda_v_x, 2) + pow(lambda_v_y, 2));

}

void nondimensionalise_state(double x, double y, double v_x, double v_y, double t_b, double l_b, double m_b, double *ndims) {

   ndims[0] = x/l_b;
   ndims[1] = y/l_b;
   ndims[2] = t_b*v_x/l_b;
   ndims[3] = t_b*v_y/l_b;

}

void dimensionalise_state(double x, double y, double v_x, double v_y, double t_b, double l_b, double m_b, double *dims) {

   dims[0] = l_b*x;
   dims[1] = l_b*y;
   dims[2] = l_b*v_x/t_b;
   dims[3] = l_b*v_y/t_b;

}

void nondimensionalise_parameters(double T, double m, double t_b, double l_b, double m_b, double *ndimp) {

   ndimp[0] = T*pow(t_b, 2)/(l_b*m_b);
   ndimp[1] = m/m_b;

}

void dimensionalise_parameters(double T, double m, double t_b, double l_b, double m_b, double *dimp) {

   dimp[0] = T*l_b*m_b/pow(t_b, 2);
   dimp[1] = m*m_b;

}
