% dawud (aco)


function [best_ever] = aco(x,y,m,alpha,beta,rho)
    
    

if nargin < 6
    
   % 20 coordinates of cities 

   x = [82 91 12 92 63 9 28 55 96 97 15 98 96 49 80 14 42 92 80 96];
    
   y = [66 3 85 94 68 76 75 39 66 17 71 3 27 4 9 83 70 32 95 3];

   alpha = 1.0; % pheromone
   beta = 1.0; % heuristic
   rho = 0.05; % evaporation rate

   m = 1; % number of ants
   
   rng default; % seed

end




[D,n] = city_distance(x,y); % distances between cities 


eta = 1./D; 

Q = 1;
tau0 = 1./(n*mean(D(:))); % (10*Q)
tau = tau0*ones(n,n);

% ants
empty_ant.tour = [];
empty_ant.cost = [];

ant = repmat(empty_ant,m,1);


max_gen = 1;
best = repmat(empty_ant,max_gen,1);
best_ever = inf;

for gen=1:max_gen % termination condition

    
    best_so_far = inf;

for k=1:m
    
    ant(k).tour = randi([1 n]); % first stop on tour
   
    for l=2:n
        
        i = ant(k).tour(end);
        
        P = (tau(i,:).^alpha).*(eta(i,:).^beta);
            
        P(ant(k).tour) = 0; % contraint
            
        P = P/sum(P); % pdf Y=XY/X
            
       
       % roulette selection 
       c = cumsum(P);
       r = rand;
       j = find(r <= c,1,'first');
    
       ant(k).tour = [ant(k).tour j];
        
       
    end
    
   
    
   
    tour = ant(k).tour;
    
    tour = [tour tour(1)]; % wrap
    
    
    L=0; % length of tour for ant k
    for i=1:length(tour)-1
        L=L+D(tour(i),tour(i+1));
    end

    ant(k).tour = tour;
    ant(k).cost = L;
    if (ant(k).cost < best_so_far)
        best_so_far = ant(k).cost;
    end
    
   
    
    
end



for k=1:m
    
    tour = ant(k).tour;
    
    tour = [tour tour(1)]; % wrap around
    
    
    
    
    for l=1:n
        i = tour(l);
        j = tour(l+1);
        
        tau(i,j) = tau(i,j) + Q/ant(k).cost; 
        
        
    end
    
  
    
    
end

%{

6. Evaporation

%}

tau = (1-rho)*tau;

if best_so_far < best_ever
    best_ever = best_so_far;
end




end




end

function [D,n] = city_distance(x,y)
    

n = length(x); % number of cities (nodes)

% distance between site combinations

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