clc
b=2.55; % wingspan
bv=0.448; % Vstab span
br=bv; % Rudder span
CLav=2.219; % Vstab lift curve slope
S=1.4025; % wing area
Sv=0.123648; %  Vstab area
Cv=0.28406; % Vstab MAC
CR=0.36*Cv; % Rudder chord
nv=0.9; % Tail Efficiency
Vs=9.8; % Stall velocity
a=0.785; % Spin angle
lv=1.157; % Vstab moment arm
defmax=30; % Max deflection of Rudder
Tr=0.5697; % Rudder Effectiveness parameter
Ixxp=4.84;
Izzp=4.43;
Ixzp=-0.1;
A=[cos(a)*cos(a) sin(a)*sin(a) -1*sin(2*a);sin(a)*sin(a) cos(a)*cos(a) sin(2*a); 0.5*sin(2*a) -0.5*sin(2*a) cos(2*a)];
B=[Ixxp;Izzp;Ixzp];
X=linsolve(A,B);
Ixxw=X(1);
Izzw=X(2);
Ixzw=X(3);
NSR=(((Ixxw*Izzw)-((Ixzw)^2))/Ixxw)*1; % Net spin rate
Vv=((lv*Sv)/(b*S));
CndR=-1*CLav*Vv*nv*Tr*(br/bv);
def=((2*NSR)/(1.225*Vs*Vs*S*b*CndR));
def_deg=-1*def*57.3;
disp(def_deg);
if def_deg<defmax
disp('Spin recovery conditon is satisfied');
else
disp('Spin recovery condition is not satisfied');
end