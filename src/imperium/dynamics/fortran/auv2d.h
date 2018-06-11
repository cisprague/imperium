
#ifndef PROJECT__.._SRC_IMPERIUM_DYNAMICS_FORTRAN_AUV2D__H
#define PROJECT__.._SRC_IMPERIUM_DYNAMICS_FORTRAN_AUV2D__H

void eom_state(double x, double y, double v_x, double v_y, double u_t, double u_x, double u_y, double T, double m, double *ds);
void jacobian_eom_state(double x, double y, double v_x, double v_y, double u_t, double u_x, double u_y, double T, double m, double *dds);
void eom_costate(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *dl);
void jacobian_eom_costate(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *ddl);
void eom_fullstate(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *dfs);
void jacobian_eom_fullstate(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *ddfs);
void lagrangian(double x, double y, double v_x, double v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *L);
void hamiltonian(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double u_t, double u_x, double u_y, double T, double m, double alpha, double *H);
void control(double x, double y, double v_x, double v_y, double lambda_x, double lambda_y, double lambda_v_x, double lambda_v_y, double T, double m, double alpha, double *uo);
void nondimensionalise_state(double x, double y, double v_x, double v_y, double t_b, double l_b, double m_b, double *ndims);
void dimensionalise_state(double x, double y, double v_x, double v_y, double t_b, double l_b, double m_b, double *dims);
void nondimensionalise_parameters(double T, double m, double t_b, double l_b, double m_b, double *ndimp);
void dimensionalise_parameters(double T, double m, double t_b, double l_b, double m_b, double *dimp);

#endif

