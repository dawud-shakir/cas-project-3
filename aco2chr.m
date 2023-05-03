% dawud (unm)

function chr = aco2chr(alpha,beta,rho)
    
    a = uint8(alpha*255);
    b = uint8(beta*255);
    r = uint8(rho*255);
    
    chr = [];
    chr = [chr char(dec2bin(a,8))];
    chr = [chr char(dec2bin(b,8))];
    chr = [chr char(dec2bin(r,8))];

end