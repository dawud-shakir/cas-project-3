% dawud (aco)


%{

This function implements the ACO algorithm to find the shortest path
between cities
%}

function [shortest_tour,len] = aco(x,y,m,alpha,beta,rho)
% find the best tour that visits every city using aco    
    
% x,y - coordinates of cities 
% m - number of ants
% alpha - pheromone weight
% beta - heuristic weight
% rho - evaporation rate of pheromone 

if nargin < 6
%default values 

   % 20 coordinates of cities 

   x = randi(100,[1,1024]);%[82 91 12 92 63 9 28 55 96 97 15 98 96 49 80 14 42 92 80 96];
    
   y = randi(100,[1,1024]);%[66 3 85 94 68 76 75 39 66 17 71 3 27 4 9 83 70 32 95 3];

   alpha = 1.0; % pheromone
   beta = 1.0; % heuristic
   rho = 0.05; % evaporation rate

   m = 1; % number of ants
   
   rng default; % seed
   
   error('aco: not enough args')
end


%rng default;

[D,n] = city_distance(x,y); % distances between cities 

eta = 1./D; % make smaller distances important 
eta(find(isinf(eta)))=0;

Q = 1; % (10*Q)
tau0 = 1./(n*mean(D(:))); % start with average 
tau = tau0*ones(n,n);

% each ant stores its tour and its length 
empty_ant.tour = [];
empty_ant.cost = [];
ant = repmat(empty_ant,m,1); 

max_gen = 5;

best = repmat(empty_ant,max_gen,1);
best_ever = 1;


prev=rng;
rng(0);

for gen=1:max_gen % termination condition
    
    best_so_far = 1;

    % tour each ant
    for k=1:m
        
        % start ant at a random city
        ant(k).tour(1) = randi([1,n]);
       
        for l=2:n
            
            i = ant(k).tour(end); % where ant is currently 
            
            P = (tau(i,:).^alpha).*(eta(i,:).^beta);
                
                
            P(ant(k).tour) = 0; % do not include cities already visited  
                
            P = P/sum(P); % pdf Y=XY/X
                
           
           % roulette selection 
           c = cumsum(P);    % increasing probabilty (cdf)
           r = rand;         % 0.0 to 1.0
           j = find(r <= c,1,'first'); 
  
           ant(k).tour = [ant(k).tour j];
            
           
        end
        
       
        % return ant to starting city
        %%ant(k).tour = [ant(k).tour  ant(k).tour(1)];
        
       
        
       
        tour = ant(k).tour;
        
        tour = [tour tour(1)]; % wrap

   
        
        
        L=0; % length of tour for ant k
        for i=1:length(tour)-1
            L=L+D(tour(i),tour(i+1));
        end
    
        ant(k).tour = tour;
        ant(k).cost = L;
        if (ant(k).cost < ant(best_so_far).cost)
            best_so_far = k;
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
    
    
    
    % Evaporation
    
    
    
    tau = (1-rho)*tau;
    
    
    if ant(best_so_far).cost < ant(best_ever).cost
        best_ever = best_so_far;
    end
    
    
    
    
end
  

shortest_tour = ant(best_ever).tour;
len = ant(best_ever).cost;
rng(prev);

end
