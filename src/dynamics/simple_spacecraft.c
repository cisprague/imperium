#include "simple_spacecraft.h"
#include <math.h>

void eom_state(double x, double y, double vx, double vy, double m, double u_t, double u_x, double u_y, double c_1, double c_2, double g, double *ds) {

   ds[0] = vx;
   ds[1] = vy;
   ds[2] = c_1*u_t*u_x;
   ds[3] = c_1*u_t*u_y - g;
   ds[4] = -c_1*u_t/c_2;

}

void eom_state_jac(double x, double y, double vx, double vy, double m, double u_t, double u_x, double u_y, double c_1, double c_2, double g, double *dds) {

   dds[0] = 0;
   dds[1] = 0;
   dds[2] = 1;
   dds[3] = 0;
   dds[4] = 0;
   dds[5] = 0;
   dds[6] = 0;
   dds[7] = 0;
   dds[8] = 1;
   dds[9] = 0;
   dds[10] = 0;
   dds[11] = 0;
   dds[12] = 0;
   dds[13] = 0;
   dds[14] = 0;
   dds[15] = 0;
   dds[16] = 0;
   dds[17] = 0;
   dds[18] = 0;
   dds[19] = 0;
   dds[20] = 0;
   dds[21] = 0;
   dds[22] = 0;
   dds[23] = 0;
   dds[24] = 0;

}

void eom_fullstate(double x, double y, double vx, double vy, double m, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double lambda_m, double u_t, double u_x, double u_y, double c_1, double c_2, double g, double *dfs) {

   dfs[0] = vx;
   dfs[1] = vy;
   dfs[2] = c_1*u_t*u_x;
   dfs[3] = c_1*u_t*u_y - g;
   dfs[4] = -c_1*u_t/c_2;
   dfs[5] = 0;
   dfs[6] = 0;
   dfs[7] = -lambda_x;
   dfs[8] = -lambda_y;
   dfs[9] = 0;

}

void eom_fullstate_jac(double x, double y, double vx, double vy, double m, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double lambda_m, double u_t, double u_x, double u_y, double c_1, double c_2, double g, double *ddfs) {

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
   ddfs[11] = 0;
   ddfs[12] = 0;
   ddfs[13] = 1;
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
   ddfs[52] = 0;
   ddfs[53] = 0;
   ddfs[54] = 0;
   ddfs[55] = 0;
   ddfs[56] = 0;
   ddfs[57] = 0;
   ddfs[58] = 0;
   ddfs[59] = 0;
   ddfs[60] = 0;
   ddfs[61] = 0;
   ddfs[62] = 0;
   ddfs[63] = 0;
   ddfs[64] = 0;
   ddfs[65] = 0;
   ddfs[66] = 0;
   ddfs[67] = 0;
   ddfs[68] = 0;
   ddfs[69] = 0;
   ddfs[70] = 0;
   ddfs[71] = 0;
   ddfs[72] = 0;
   ddfs[73] = 0;
   ddfs[74] = 0;
   ddfs[75] = -1;
   ddfs[76] = 0;
   ddfs[77] = 0;
   ddfs[78] = 0;
   ddfs[79] = 0;
   ddfs[80] = 0;
   ddfs[81] = 0;
   ddfs[82] = 0;
   ddfs[83] = 0;
   ddfs[84] = 0;
   ddfs[85] = 0;
   ddfs[86] = -1;
   ddfs[87] = 0;
   ddfs[88] = 0;
   ddfs[89] = 0;
   ddfs[90] = 0;
   ddfs[91] = 0;
   ddfs[92] = 0;
   ddfs[93] = 0;
   ddfs[94] = 0;
   ddfs[95] = 0;
   ddfs[96] = 0;
   ddfs[97] = 0;
   ddfs[98] = 0;
   ddfs[99] = 0;

}

void lagrangian(double u_t, double u_x, double u_y, double alpha, double *L) {

   (*L) = alpha*u_t + pow(u_t, 2)*(-alpha + 1);

}

void hamiltonian(double x, double y, double vx, double vy, double m, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double lambda_m, double u_t, double u_x, double u_y, double alpha, double c_1, double c_2, double g, double *H) {

   (*H) = alpha*u_t + c_1*lambda_v_x*u_t*u_x - c_1*lambda_m*u_t/c_2 + lambda_v_y*(c_1*u_t*u_y - g) + lambda_x*vx + lambda_y*vy + pow(u_t, 2)*(-alpha + 1);

}

void pontryagin(double x, double y, double vx, double vy, double m, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double lambda_m, double alpha, double c_1, double c_2, double g, double *u) {

   u[0] = (1.0L/2.0L)*(alpha*c_2*sqrt(pow(lambda_v_x, 2) + pow(lambda_v_y, 2)) - c_1*c_2*pow(lambda_v_x, 2) - c_1*c_2*pow(lambda_v_y, 2) - c_1*lambda_m*sqrt(pow(lambda_v_x, 2) + pow(lambda_v_y, 2)))/(c_2*(alpha - 1)*sqrt(pow(lambda_v_x, 2) + pow(lambda_v_y, 2)));
   u[1] = -lambda_v_x/sqrt(pow(lambda_v_x, 2) + pow(lambda_v_y, 2));
   u[2] = -lambda_v_y/sqrt(pow(lambda_v_x, 2) + pow(lambda_v_y, 2));

}
