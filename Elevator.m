clc
clear
Vmax = 30; % m/s
Sw=1.4025; % m ˆ 2
Sh = 0.378; % m ˆ 2
Cbar= 0.55; % m
Vs = 10.05; %m/sec
Tmax= 32.93; %N
rho = 1.225; % kg/m ˆ 3
Cmo = 0.1033;
zT = 0.025; %m
CLa = 3.93; %1/rad
CLah = 3.655167; % 1/rad
CLa_wf = 3.93;
g = 9.81; %m/s ˆ 2
m = 14; % kg
CLo = 0.956;
taw = 0.5; % Effectiveness parameter
etha_h = 0.9; % Tail Efficiency
lh = 1.0766; % m from main landing gear
AR_w = 4.63; % Aspect Ratio of wing
de_da = ((CLa*2)/(3.14*AR_w)); % Downwash
CLdE=-CLah*etha_h*Sh*taw/Sw;
% Most aft cg
xcg = 0; % m from main landing gear
h_to_ho = (0.4-0.3684)/Cbar; % m
l_h1 = lh+xcg; %m
VH1 = (l_h1*Sh)/(Sw*Cbar);
CmdE1 = -CLah*etha_h*VH1*taw;
Cma1 = CLa_wf*h_to_ho-CLah*etha_h*Sh*(l_h1/Cbar)*(1-de_da)/Sw;
% Most forward cg
xcg = 0.025; % m from main landing gear
h_to_ho = (0.4-0.3684-0.025)/Cbar; % m
l_h2 = lh+xcg; % m
VH2 = (l_h2*Sh)/(Sw*Cbar);
CmdE2 = -CLah*etha_h*VH2*taw;
Cma2 = CLa_wf*h_to_ho-CLah*etha_h*Sh*(l_h2/Cbar)*(1-de_da)/Sw;
i =1;
for U1=Vs:0.5:Vmax
qbar=0.5*rho*U1^2;
CL1= (m*g)/(qbar*Sw);
f1=((Tmax*zT)/(qbar*Sw*Cbar))+Cmo;
dE1(i)=-((f1*CLa)+(CL1-CLo)*Cma1)/(CLa*CmdE1-Cma1*CLdE);
dE2(i)=-((f1*CLa)+(CL1-CLo)*Cma2)/(CLa*CmdE2-Cma2*CLdE);
V(i)=U1;
i=i+1;
end
plot(V,dE1*57.3,'o',V,dE2*57.3,'*')
grid
xlabel ('Speed (m/s)')
ylabel ('\delta_E (deg)')
legend('Most aft cg','Most forward cg')