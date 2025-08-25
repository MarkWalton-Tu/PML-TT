function [TemLabelXY,TemLabelData] = fusion(TemLabel1,TemLabel2,res,noisy_data,noisy_target)
%Perform a similarity measure
[q,w] = size(noisy_target);
[~,r] = size(noisy_data);
a = zeros(q,w);
b = zeros(q,w);
d = zeros(w,r);
res_tem = res;
j = 1;
t = 0;

for i = 1:w
    HammingDistance = pdist2(TemLabel1(:,i)',TemLabel2(:,i)','hamming');
    if HammingDistance < 1
        a(:,j) = TemLabel1(:,i) + TemLabel2(:,i);
        d(j,:) = noisy_data(i,:);
        b(:,j) = noisy_target(:,i);
        j = j+1;
    else
        y = i-t;
        res_tem(y,:) = [];
        res_tem(:,y) = [];
        t = t+1;
    end
end
a(:,j:w) = [];
b(:,j:w) = [];
d(j:w,:) = [];
TemLabelData = d;

[m, n] = size(a);
for i = 1:m
    for j = 1:n 
        if a(i,j) == 0
            if a(i,:)*res_tem(:,j) <0 
                a(i,j) = -2;
            else
                a(i,j) = 2;
            end
        end
    end
end

c = a.*b;
c(c>0) = 1;
c(c<=0) = 0;
TemLabelXY = c;
end

