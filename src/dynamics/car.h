
#ifndef PROJECT___HOME_CISPRAGUE_DEV_IMPERIUM_SRC_DYNAMICS_CAR__H
#define PROJECT___HOME_CISPRAGUE_DEV_IMPERIUM_SRC_DYNAMICS_CAR__H

void ds(double x, double y, double theta, double omega, double V, double *ds);
void dds(double x, double y, double theta, double omega, double V, double *dds);
void dl(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *dl);
void ddl(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *ddl);
void dfs(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *dfs);
void ddfs(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *ddfs);
void L(double x, double y, double theta, double omega, double V, double *L);
void H(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double omega, double V, double *H);
void uo(double x, double y, double theta, double lambda_x, double lambda_y, double lambda_theta, double V, double *uo);

#endif

