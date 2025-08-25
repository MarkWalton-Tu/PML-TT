function [sample1,Label1,sample2,Label2,sample3,Label3]=bagging(x,y,N,nb)

[m,n]=size(x);
[n2,~] = size(y);
rng('default');
for k=1:N
index=randi([1 m],1,nb) ;  
j=1;
xt = zeros(nb,n);
yt = zeros(n2,nb);
for i=1:nb               
    col=index(1,i); 
    xt(j,:)=x(col,:);
    yt(:,j)=y(:,col);
    j=j+1;
end
Samples((k-1)*nb+1:k*nb,:)=xt;
Labels(:,(k-1)*nb+1:k*nb)=yt;
end

sample1 = Samples(1:nb,:);
Label1 = Labels(:,1:nb);
sample2 = Samples(nb+1:2*nb,:);
Label2 = Labels(:,nb+1:2*nb);
sample3 = Samples(2*nb+1:3*nb,:);
Label3 = Labels(:,2*nb+1:3*nb);
