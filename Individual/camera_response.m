Ref = 1;  
sensor = [0; 0; 0; 0.1; 0.6; 0.8; 0.9; 0.7; 0.3; 0; 0; 0; 0];  % spectral response
Elambda = [0.3; 0.5; 0.6; 0.7; 0.6; 0.3; 0.3; 0.2; 0.2; 0.2; 0.1; 0.4; 0.1]; 

% storing the result
result = Ref .* sensor .* Elambda;

response = sum(result)* 25*10^-9;