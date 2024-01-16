function [D,n] = city_distance(x,y)
% find the distance between all cities 
% D - D(1,1) is the distance between city 1 and city 1
%     D(1,2) is the distance between city 1 and city 2
%     D(2,1) is the distance between city 2 and city 1

% n - number of cities  

n = length(x); % number of cities (nodes)

D = zeros(n,n); 

for i=1:n-1
    for j=i:n
        dist_x = x(i)-x(j);
        dist_y = y(i)-y(j);
        
        D(i,j) = sqrt(dist_x^2 + dist_y^2);
        
        D(j,i) = D(i,j);         
    end
    
end


end
