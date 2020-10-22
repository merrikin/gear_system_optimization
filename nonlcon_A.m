function [C,Ceq] = nonlcon_A(z,q,BC)
C = [];
Ceq(1) = z(8) - round(z(8)); % snt must be an integer
end