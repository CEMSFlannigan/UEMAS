V = 8; % nm/ps
h = 5; % nm
VL = 5.350; % nm/ps
VT = 3.570; % nm/ps

k = 0.0270; % 1/nm

syms omega p q

p = sqrt(omega^2*(1/VL^2 - 1/V^2));
q = sqrt(omega^2*(1/VT^2 - 1/V^2));

vpasolve(omega^4/VT^4 == 4*k^2*q^2*(1-(p/q)*(tan(p*h)/tan(q*h))),omega,1e9)