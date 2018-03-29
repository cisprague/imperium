
#ifndef PROJECT__.._SRC_DYNAMICS_SIMPLE_SPACECRAFT__H
#define PROJECT__.._SRC_DYNAMICS_SIMPLE_SPACECRAFT__H

void eom_state(double x, double y, double vx, double vy, double m, double u_t, double u_x, double u_y, double c_1, double c_2, double g, double *ds);
void eom_state_jac(double x, double y, double vx, double vy, double m, double u_t, double u_x, double u_y, double c_1, double c_2, double g, double *dds);
void eom_fullstate(double x, double y, double vx, double vy, double m, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double lambda_m, double u_t, double u_x, double u_y, double c_1, double c_2, double g, double *dfs);
void eom_fullstate_jac(double x, double y, double vx, double vy, double m, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double lambda_m, double u_t, double u_x, double u_y, double c_1, double c_2, double g, double *ddfs);
void lagrangian(double u_t, double u_x, double u_y, double alpha, double *L);
void hamiltonian(double x, double y, double vx, double vy, double m, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double lambda_m, double u_t, double u_x, double u_y, double alpha, double c_1, double c_2, double g, double *H);
void pontryagin(double x, double y, double vx, double vy, double m, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double lambda_m, double alpha, double c_1, double c_2, double g, double *u);

#endif

