function u=Outer(t,x,dt)

persistent K1 K2 K3

%%% MEASUREMENT
x=MoCap(x); % full state [x;y;z;vx;vy;vz;theta_3;theta_2;theta_1;p;q;r]

%%% NOMINAL CONTROL - This is the baseline control which we used when we
% linearized the system
m=.6891;
g=9.806;
u_nom=[0;0;0;m*g];

%%% FEEDBACK CONTROL
% POSITION CONTROL
delta_roll=0;
delta_pitch=0;
delta_thrust=m*g;
Kx = -[.1952 .2446];
Ky = -[-.1952 -.2446];
Kz = [-4.3112 -2.4473];

[x_des, y_des, z_des, yaw_des] = planner(x,t);

x1=[x(1); x(4)];
a_x=-Kx*(x1-[x_des;0]);

x2=[x(2); x(5)];
a_y=-Ky*(x2-[y_des;0]);

x3=[x(3); x(6)];
delta_thrust=-Kz*(x3-[z_des;0]);

% YAW CONTROL
delta_yaw=yaw_des;
delta_pitch = (a_x*cos(x(9))-a_y*sin(x(9)));
delta_roll =  (a_x*sin(x(9))+a_y*cos(x(9)));

delta_u=[delta_roll;delta_pitch;delta_yaw;delta_thrust];

%%% RETURN OUTER LOOP CONTROL VECTOR
u=u_nom + delta_u;


