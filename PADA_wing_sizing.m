%CONSTANTS
b= 0.75; % wingspan in m
t_c= 0.126; %airfoil t/c max
vel= 8; % velocity in m/s
zero_lift= -2.05; %airfoil zero lift in deg
AoA= 5; %AoA in deg
a0_deg= 0.1092; %lift curve slope in 1/deg
a0_rad= a0_deg*57.3; %lift curve slope in 1/rad
FF= 1.341; %form factor

%DEFINING ARRAYS
Cr= []; Taper= []; AR= []; MAC= []; Ct= []; S= []; Sweep_c4= []; 
Sweep_c2= []; Re= []; flam= []; denom=[]; e=[]; a_rad= []; a_deg=[]; 
CL3d=[]; Cf=[]; Swet=[]; Cd0=[];
Cdi= []; Cd= []; L= []; D= []; L_D= [];  LD=[];

%INITIALIZING
cr= 0.45; % in m
i=1; sum=0;
j=1;max_L_D= 0; k=1;
taper= 0.45;

%WING ITERATIONS
while cr<=0.6
    while taper >= 0.25

        Cr(i)= cr; %root chord 
        Taper(i)= taper; %taper ratio    
        AR(i)= (2*b)/ (cr*(1+taper)); %aspect ratio      
        MAC(i)= (2/3)*cr*(1+taper+taper^2)/(1+taper); %mean aerodynamic chord   
        Ct(i)= cr*taper; %tip chord     
        S(i)= (b^2)/AR(i); %wing area
        Sweep_c4(i)= atan(3*(cr- Ct(i))/(2*b)); %quarter chord sweep  
        Sweep_c2(i)= atan(1*(cr- Ct(i))/(b)); %half chord sweep
        Re(i)= 1.225*vel*MAC(i)/(1.81*(10^-5)); %Reynolds number    
        flam(i)= 0.005*(1+ 1.5*(taper-0.6)^2);   
        denom(i)= 1+ (0.142+ AR(i)*flam(i)*((10*t_c)^0.33))/ ((cos(Sweep_c4(i)))^2)+ 0.1/((4+AR(i))^0.8);     
        e(i)= 1/denom(i); %Ostwalds efficiency      
        a_rad(i)= (2*3.14*AR(i))/(2+ sqrt(((2*3.14*AR(i)/a0_rad)^2)*(1+ ((tan(Sweep_c2(i)))^2))+4));     
        a_deg(i)= a_rad(i)/57.3;
        CL3d(i)= a_deg(i)*(AoA-zero_lift); %3D lift coefficient 
        Cf(i)= 0.074/(Re(i)^0.2); %coefficient of friction  
        Swet(i)= 2*S(i)*(1+ 0.25*t_c); %wetted area     
        Cd0(i)= Swet(i)*Cf(i)*FF/S(i); %zero lift drag coefficient 
        Cdi(i)= (CL3d(i)^2)/ (3.14*e(i)*AR(i)); %induced drag coefficient
        Cd(i)= Cd0(i)+ Cdi(i); %total drag coefficient    
        L(i)= 0.5*1.225*vel*vel*S(i)*CL3d(i); %lift in newton  
        D(i)= 0.5*1.225*vel*vel*S(i)*Cd(i); %drag in newton    
        L_D(i)= L(i)/D(i); %lift to drag ratio
            
        taper= taper- 0.01;
        i=i+1;     
    end
    cr= cr+ 0.03;
end

%WING SELECTION
while j<=20
    if Ct(j)>= 0.157 && L(j)>=3 %(Tip chord constraint set based on manufacturibility)

        if L_D(j)>=max_L_D
            max_L_D= L_D(j);
            var1= Cr(j)*39.37;
            var2= Taper(j); 
            var3= MAC(j)*39.37; 
            var4= L_D(j); 
        end
    end
j= j+1;
end

%OUTPUT
disp('Wingspan in inches: ')
disp(round(b*39.37,2))
disp('Root Chord in inches: ')
disp(round(var1, 2))
disp('Taper Ratio: ')
disp(round(var2, 2))
disp('Mean Aerodynamic Chord in inches:')
disp(round(var3, 2))
disp('L/D: ')
disp(round(var4, 2))