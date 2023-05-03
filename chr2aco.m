% dawud

function [alpha,beta,rho] = chr2aco(chr)
    
    a = bin2dec(chr(1:8));
    b = bin2dec(chr(9:16));
    r = bin2dec(chr(17:24));
    
    alpha = double(a/255);
    beta = double(b/255);
    rho = double(r/255);
end