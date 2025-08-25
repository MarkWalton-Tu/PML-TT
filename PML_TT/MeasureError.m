function err = MeasureError(Outputs1,Outputs2,target)
%MEASUREERROR Summary of this function goes here
%   Detailed explanation goes here

[m,n] = size(target);
Outputs1(Outputs1 == -1) = 0;
Outputs2(Outputs2 == -1) = 0;
n_error=0;
n_same=0;
for i=1:n
    if Outputs1(:,i) == Outputs2(:,i)
        n_same= n_same+1;
        n_error = n_error+sum(Outputs2(:,i)~=target(:,i));
    end
end

if n_error == 0
    Op = Outputs1+Outputs2;
    Op(Op == -2) = 0;
    Op(Op == 2) = 1;
    err = Hamming_loss(Op,target);
else
    err = n_error/(n_same*m);
end

end

