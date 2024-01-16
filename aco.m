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
        
    
       
        tour = ant(k).tour;
        
        tour = [tour tour(1)];  % return ant to starting city

   
        
        
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
        
        tour = [tour tour(1)];  % return ant to starting city
        
        
        
        
        for l=1:n
            i = tour(l);
            j = tour(l+1);
            
            tau(i,j) = tau(i,j) + Q/ant(k).cost; 
            
            
        end
        
      
        
        
    end
    
    
    
    % evaporation
    
    
    
    tau = (1-rho)*tau;
    
    
    if ant(best_so_far).cost < ant(best_ever).cost
        best_ever = best_so_far;
    end
    
    
    
    
end
  

shortest_tour = ant(best_ever).tour;
len = ant(best_ever).cost;
rng(prev);

end
