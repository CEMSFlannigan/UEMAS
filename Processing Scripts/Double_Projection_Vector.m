DP1 = [-1.80940000000000,1.80940000000000,-1];
DP2 = [-36.9823251984091,42.9842682783020,-3.00097153994643];
n1 = [1,1,0];
n2 = [1,1,2];

syms v1 v2 v3
eqn1 = DP1(1) == v1 - (v1*n1(1)+v2*n1(2) + v3*n1(3))/sqrt(n1*n1')*n1(1);
eqn2 = DP1(2) == v2 - (v1*n1(1)+v2*n1(2) + v3*n1(3))/sqrt(n1*n1')*n1(2);
eqn3 = DP1(3) == v3 - (v1*n1(1)+v2*n1(2) + v3*n1(3))/sqrt(n1*n1')*n1(3);
%eqn4 = DP2(1) == v1 - (v1*n2(1)+v2*n2(2) + v3*n2(3))/sqrt(n2*n2')*n2(1);
%eqn5 = DP2(2) == v2 - (v1*n2(1)+v2*n2(2) + v3*n2(3))/sqrt(n2*n2')*n2(2);
%eqn6 = DP2(3) == v3 - (v1*n2(1)+v2*n2(2) + v3*n2(3))/sqrt(n2*n2')*n2(3);

soln = solve([eqn1, eqn2, eqn3], [v1, v2, v3]);

v1Soln = double(soln.v1)
v2Soln = double(soln.v2)
v3Soln = double(soln.v3)