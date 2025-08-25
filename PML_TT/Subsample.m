function  [Lx,Ly]=Subsample(Li,Ll,s) 
   idx=randi([1 size(Li,1)],1,s);
   Lx=Li(idx,:);
   Ly=Ll(:,idx);
end