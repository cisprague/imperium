#include "car.h"
#include <math.h>

void ds(double x, double y, double theta, double omega, double V, double *ds) {

   ds[0] = V*cos(theta);
   ds[1] = V*sin(theta);
   ds[2] = omega;

}

void dds(double x, double y, double theta, double omega, double V, double *dds) {

   dds[0] = 0;
   dds[1] = 0;
   dds[2] = -V*sin(theta);
   dds[3] = 0;
   dds[4] = 0;
   dds[5] = V*cos(theta);
   dds[6] = 0;
   dds[7] = 0;
   dds[8] = 0;

}

void dl(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *dl) {

   dl[0] = 0;
   dl[1] = 0;
   dl[2] = V*lambda_x*sin(theta) - V*lambda_y*cos(theta);

}

void ddl(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *ddl) {

   ddl[0] = 0;
   ddl[1] = 0;
   ddl[2] = 0;
   ddl[3] = 0;
   ddl[4] = 0;
   ddl[5] = 0;
   ddl[6] = 0;
   ddl[7] = 0;
   ddl[8] = V*lambda_x*cos(theta) + V*lambda_y*sin(theta);

}

void dfs(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *dfs) {

   dfs[0] = V*cos(theta);
   dfs[1] = V*sin(theta);
   dfs[2] = omega;
   dfs[3] = 0;
   dfs[4] = 0;
   dfs[5] = V*lambda_x*sin(theta) - V*lambda_y*cos(theta);

}

void ddfs(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *ddfs) {

   ddfs[0] = 0;
   ddfs[1] = 0;
   ddfs[2] = -V*sin(theta);
   ddfs[3] = 0;
   ddfs[4] = 0;
   ddfs[5] = 0;
   ddfs[6] = 0;
   ddfs[7] = 0;
   ddfs[8] = V*cos(theta);
   ddfs[9] = 0;
   ddfs[10] = 0;
   ddfs[11] = 0;
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
   ddfs[32] = V*lambda_x*cos(theta) + V*lambda_y*sin(theta);
   ddfs[33] = V*sin(theta);
   ddfs[34] = -V*cos(theta);
   ddfs[35] = 0;

}

void L(double x, double y, double theta, double omega, double V, double *L) {

   (*L) = pow(omega, 2);

}

void H(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *H) {

   (*H) = V*lambda_x*cos(theta) + V*lambda_y*sin(theta) + lambda_theta*omega + pow(omega, 2);

}

void uo(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double V, double *uo) {

   uo[0] = -1.0L/2.0L*lambda_theta;

}
