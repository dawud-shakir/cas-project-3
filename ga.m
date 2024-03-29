
% dawud (cas/unm)
clear, clc, close all;
rng default;
cities = 8;

global x
x = randi(100,[1,cities]);
    
global y
y = randi(100,[1,cities]);

figure
plot_cities(x,y)


print_chr = @(chr) strcat(chr(1:8),'|',chr(9:16),'|',chr(17:24));


max_gen = 20
pop_size = 8
mut = 0.01
elitism = 1

M = zeros(pop_size,3); 

% aco number of ants
global m
m = 2; 

% aco co-efficients

alpha = rand(pop_size,1); % 0.0..1.0
beta = rand(pop_size,1); % 0.0..1.0
rho = 0.5*rand(pop_size,1); % 0.0..0.5





pop = aco2chr(alpha,beta,rho); 

d=zeros(1,max_gen);
mx=zeros(1,max_gen);  
mn=zeros(1,max_gen);
mu=zeros(1,max_gen);

for i=1:max_gen
   [pop,fit] = breed(pop,mut,elitism)
   
   % population sorted (fittest=1) 
   mn(i) = fit(1,2);
   mu(i) = mean(fit(:,2));
   mx(i) = fit(end,2);
 
   chr = pop(1,:);
   [alpha,beta,rho] = chr2aco(chr);

    M(i,1) = alpha;
    M(i,2) = beta;
    M(i,3) = rho;


    for j=1:pop_size
   
        chr = pop(j,:);
        [alpha,beta,rho] = chr2aco(chr);

 
   %%     disp([' alpha=' num2str(alpha) ' beta=' num2str(beta) ' rho=' num2str(rho) ' cost=' num2str(fit(j,2))])
   
   disp([num2str(j),' & ',print_chr(aco2chr(alpha,beta,rho)), ' & ', num2str(alpha), ' & ', num2str(beta), ' & ', num2str(rho), ' & ', num2str(fit(j,2)),' \\'])
   
        %disp(['fittest chromosome=' strcat(chr(1:8),'|',chr(9:16),'|',chr(17:24))]);  
      %  disp(['gen=' num2str(i) ' alpha=' num2str(alpha) ' beta=' num2str(beta) ' rho=' num2str(rho) ' min=' num2str(mn(i)) ' mean=' num2str(mu(i)) ' max=' num2str(mx(i)) ' dist=' num2str(d(i))]);
    end
end

figure
plot_cities(x,y)

figure
hold on
title(['max-gen=' num2str(max_gen) ' pop-size=' num2str(pop_size) ' mut=' num2str(mut)]);
xlabel('gen');
ylabel('best tour length');
    
plot(mn,'b');
plot(mu,'g');
plot(mx,'r');



legend('min','mean','max')


hold off

disp('done');

%{

pop=1 best=010100010000110100100000 mx=7 mu=9.5 dist=-2.5
done

%}

function tour_length = tour_fitness(chr) 
    
    % aco tour
global x
global y
global m

    
    [alpha,beta,rho] = chr2aco(chr);
    [~,tour_length] = aco(x,y,m,alpha,beta,rho);
    
end


function [pop,fit]=breed(pop,mut,elitism)    
    pop_size = size(pop,1);
    fit = zeros(pop_size,2);
   
    for i=1:pop_size
        fit(i,:) = [i, tour_fitness(pop(i,:))];
    end
    


    [~,ind]=sort(fit(:,2));  % minimum sort
    fit=fit(ind,:);
    pop=pop(ind,:);
    
    if elitism==1
    %   pop(1,:)=pop(fit(1,1),:); % best goes on
    end

    for i=2:pop_size
       pop(i,:)=pop(select(fit),:);
    end
    for i=2:pop_size-1
       pop(i,:)=cross(pop(i,:),pop(i+1,:),mut); 
    end
    pop(end,:)=cross(pop(1,:),pop(end,:),mut);


end

function chr=cross(chr1,chr2,mut)
   
    split=randi([1,length(chr2)-1]);
    chr=horzcat(chr1(1,1:split),chr2(1,split+1:end));
    r = rand;
    if r<=mut
        bit = randi(uint8(['0','1']));
        chr(randi([1,length(chr)])) = bit;
    end
end
    
function idx=select(fit)
    p = fit(:,2)./sum(fit(:,2));
          % roulette selection 
           c = cumsum(p);    % increasing probabilty (cdf)
           r = rand;         % 0.0 to 1.0
           idx = find(r <= c,1,'first');
  
  

% thold=rand()*sum(fit(:,2))
%     j=0;
%     i=1;
%     while j<thold
%         j=j+fit(i,2);
%         i=i+1;
%     end
%     idx=fit(min(1,i-1),1);
end 


