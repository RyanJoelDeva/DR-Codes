Vapp=1.2*9.94;
cross_wind=10;
vt=sqrt(Vapp^2+cross_wind^2);
CLalpha=2.21916836983389;
vstab_area=0.123648071506289;
Ss=0.10867073+vstab_area;
wing_area=0.55*2.55;
MACw=0.55;
wing_span=2.55;
Arw=wing_span^2/wing_area;
Vv=0.04;
Lvt=1.157;
Xf=0.374;
Xv=1.65;
XCG=0.4306;
Xca=((0.10867073*Xf)+(Xv*vstab_area))/Ss;
Dc=-XCG+Xca;
Cdy=0.65;


beta=atan(cross_wind/Vapp);
N1=length(0.16:0.02:0.4);
N2=length(0.70:0.05:1);
tau=zeros([N1*N2,1]);
j=1;
Cr_by_Cv=zeros([N1*N2,1]);
br_by_bv=zeros([N1*N2,1]);
for i=1:1:N2
    Cr_by_Cv(j:j+N1-1)=0.16:0.02:0.4;
    j=j+N1;
end
j=1;
for i=1:1:N1
    br_by_bv(j:j+N2-1)=0.70:0.05:1;
    j=j+N2;
end


tau=(1.129.*(Cr_by_Cv.^0.4044))-0.1772;
Nv=0.9;
Kf1=0.7;
Kf2=1.35;
Fw=0.5*1.225*cross_wind^2*Ss*Cdy;
sidewash_gradient=((0.724+3.06*((vstab_area/wing_area)/(1+cos(0)))+(0.4*(0))+0.009*Arw)/Nv)-1;
Cnbeta=Kf1*CLalpha*(1-sidewash_gradient)*Nv*Lvt*vstab_area/(wing_span*wing_area);
Cyb=(-Kf2*CLalpha*(1-sidewash_gradient)*Nv*vstab_area)/wing_area;
Cydr=CLalpha*0.9.*tau.*br_by_bv*(vstab_area/wing_area);
Cndr=-CLalpha*Vv*0.9*tau.*br_by_bv;
x = optimvar('x',2);
rho=1.225;
eq1=1/2*rho*vt^2*wing_area*wing_span*(0+Cnbeta*(beta-x(1))+Cndr*x(2))+Fw*Dc*cos(x(1))==0;
eq2=1/2*rho*cross_wind^2*Ss*Cdy-1/2*rho*vt^2*wing_area*(0+Cyb*(beta-x(1))+Cydr*x(2))==0;
sigma=zeros([N1*N2,1]);
def=zeros([N1*N2,1]);
for i=1:1:N1*N2
    eq1=1/2*rho*vt^2*wing_area*wing_span*(0+Cnbeta*(beta-x(1))+Cndr(i)*x(2))+Fw*Dc*cos(x(1))==0;
eq2=1/2*rho*cross_wind^2*Ss*Cdy-1/2*rho*vt^2*wing_area*(0+Cyb*(beta-x(1))+Cydr(i)*x(2))==0;
prob = eqnproblem;
prob.Equations.eq1 = eq1;
prob.Equations.eq2 = eq2;
x0.x = [0 0];
[sol,fval,exitflag] = solve(prob,x0);
sigma(i)=sol.x(1);
def(i)=sol.x(2);
end
sigma_deg=rad2deg(sigma);
def_deg=rad2deg(def);
crab_angle=rad2deg(asin(cross_wind/Vapp));
%cr/cv, br/bv,def_deg,sig_deg
A=zeros([N1*N2,4]);
T=table(Cr_by_Cv,br_by_bv,def_deg,sigma_deg);
filename = 'rudderdata.xlsx';
writetable(T,filename)