x= [];
y= [];
B_pada=[]; % PADA Landing Bonus
i= 1; j=1; % Variation of sigma and d
for sigma = 0.5:0.5:10
    for d = 0.5:0.5:10
       
        x(i)= sigma; 
        y(i)= d;
        B_pada(i) = 5*((1/(sigma.*sqrt(2*pi)))*exp(-(d.^2)/(2*sigma.^2)));
        i=i+1;
       
    end
end


tri = delaunay(x,y);
TO=triangulation(tri,x(:),y(:),B_pada(:));
trisurf(TO, 'LineWidth',0.01)

mycolors = [ 0.7, 0.2, 0.7; 0.8, 0.6, 0.8; 0.9, 0.7, 0.9; 1, 0.8, 1];
colormap (mycolors);

title('Scoring Analysis')
xlabel('sigma')
ylabel('d')
zlabel('Bᴾᴬᴰᴬ')
grid off;