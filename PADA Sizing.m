%constants
b= 0.75;
t_c= 0.126;
vel= 7.77;
zero_lift= -2.05;
AoA= 5;
a0_deg= 0.1092;
a0_rad= a0_deg*57.3;
FF= 1.341; 

Cr= []; Taper= []; AR= []; MAC= []; Ct= []; S= []; Sweep_c4= []; 
Sweep_c2= []; Re= []; flam= []; denom=[]; e=[]; a_rad= []; a_deg=[]; 
CL3d=[]; Cf=[]; Swet=[]; Cd0=[];
Cdi= []; Cd= []; L= []; D= []; L_D= [];  LD=[];
cr= 0.45;

i=1; 
sum=0;
while cr<=0.6
    taper= 0.45;
    while taper >= 0.25 
        Cr(i)= cr;
        Taper(i)= taper;
        AR(i)= (2*b)/ (cr*(1+taper));
        MAC(i)= (2/3)*cr*(1+taper+taper^2)/(1+taper); 
        Ct(i)= cr*taper;
      
        S(i)= (b^2)/AR(i);
        Sweep_c4(i)= atan(3*(cr- Ct(i))/(2*b));
        Sweep_c2(i)= atan(1*(cr- Ct(i))/(b));

        Re(i)= 1.225*vel*MAC(i)/(1.81*(10^-5));
        flam(i)= 0.005*(1+ 1.5*(taper-0.6)^2); 
        denom(i)= 1+ (0.142+ AR(i)*flam(i)*((10*t_c)^0.33))/ ((cos(Sweep_c4(i))^2)+ 0.1/((4+AR(i))^0.8));
        e(i)= 1/denom(i); 

        a_rad(i)= (2*3.14*AR(i))/(2+ sqrt(((2*3.14*AR(i))^2)*(1+ ((tan(Sweep_c2(i)))^2))+4));
        a_deg(i)= a_rad(i)/57.3;
        CL3d(i)= a_deg(i)*(AoA-zero_lift);
        Cf(i)= 0.074/(Re(i)^0.2); 
        Swet(i)= 2*S(i)*(1+ 0.25*t_c);
        Cd0(i)= Swet(i)*Cf(i)*FF/S(i); 
        Cdi(i)= (CL3d(i)^2)/ (3.14*e(i)*AR(i)); 
        Cd(i)= Cd0(i)+ Cdi(i);
        L(i)= 0.5*1.225*vel*vel*S(i)*CL3d(i);
        D(i)= 0.5*1.225*vel*vel*S(i)*Cd(i); 
        L_D(i)= L(i)/D(i); 
        
        taper= taper- 0.01;
        i=i+1;
        
    end
    cr= cr+ 0.03;
    
end
j=1;
k=1;
while j<=100
    if round(Ct(j)*t_c)>=0.020 && L(j)>=3
        LD(k)= L_D(j);  
        k=k+1;
    end
    j=j+1;
end
max_ld= max(LD);

p=1;
while p<=100
    if L_D(p)==max_ld
        disp("root chord: ")
        disp(Cr(p))
       
    end
    p=p+1;
end



