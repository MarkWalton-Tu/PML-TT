function [Centroids,Sigma_value,Weights,number] = repeat(sample1,Label1,sample2,Label2,sample3,Label3,test_data,test_target,noisy_data,noisy_label)
 
ratio = 0.01;
mu = 1;
err_prime=zeros(1,3);
s_prime=zeros(1,3);
Centroids = cell(1,3);
Sigma_value = cell(1,3);
Weights = cell(1,3);
for n=1:3 
    a = eval(strcat('sample',string(n)));
    b = eval(strcat('Label',string(n)));
    [Centroids{n},Sigma_value{n},Weights{n},~]=ML_classifier_train(a,b,ratio,mu);
    err_prime(n) = 1;                     
    s_prime(n) = 0;                         
end


p=zeros(1,3)*nan;
q=zeros(1,3)*nan;
for ii=1:3
    if ii+1<=3
        p(ii)=ii+1;

    else
        p(ii)=mod((ii+1),3);

    end
    if ii+2<=3
        q(ii)=ii+2;
    else
        q(ii)=mod((ii+2),3);
    end
end
h=[p;q];

bChange = 1;
[Unum]=size(noisy_data,1);
err = zeros(1,3)*nan;
flag = zeros(1,3)*nan;
number = cell(1,3);

while bChange == 1
    bChange = 0;

    Li=cell(1,3);
    Ll=cell(1,3);
    for l=1:3
        [~,Outputs1,~]=ML_classifier_test(test_data,test_target,Centroids{h(1,l)},Sigma_value{h(1,l)},Weights{h(1,l)});
        [~,Outputs2,~]=ML_classifier_test(test_data,test_target,Centroids{h(2,l)},Sigma_value{h(2,l)},Weights{h(2,l)});
        err(l) = MeasureError(Outputs1,Outputs2,test_target); 

        if err(l) < err_prime(l)   
            [~,U_1,~]=ML_classifier_test(noisy_data,noisy_label,Centroids{h(1,l)},Sigma_value{h(1,l)},Weights{h(1,l)});
            [~,U_2,~]=ML_classifier_test(noisy_data,noisy_label,Centroids{h(2,l)},Sigma_value{h(2,l)},Weights{h(2,l)});

            for j=1:Unum
                if U_1(:,j)==U_2(:,j) 
                    U_2(:,j)=U_2(:,j).*noisy_label(:,j);
                    Li{l}=[Li{l};noisy_data(j,:)];
                    Ll{l}=[Ll{l} U_2(:,j)];
                end
            end

            Ll{l}(Ll{l} == 0) =-1;
            
            if s_prime(l) == 0   
                s_prime(l)=floor(err(l)/( err_prime(l)-err(l))+1);

            end
            
            if  s_prime(l)<size(Li{l},1)
                if err(l)*size(Li{l},1)<err_prime(l)*s_prime(l)
                    flag(l)=1;

                elseif s_prime(l)>floor(err(l)/( err_prime(l)-err(l)))

                    s = floor(err_prime(l)*s_prime(l)/err(l)-1);

                    [Li{l},Ll{l}]=Subsample(Li{l},Ll{l},s);
                    flag(l)=1;
                end
            else
                flag(l) = 0;
            end
        else
            flag(l) = 0;
        end
    end

    for q=1:3
        if flag(q)==1
            bChange = 1;
            sample5 = eval(strcat('sample',string(q)));
            Label5 = eval(strcat('Label',string(q)));
            sample5 = [sample5;Li{q}];
            Label5 = [Label5 Ll{q}];
            number{q} = size(sample5,1);
            [Centroids{q},Sigma_value{q},Weights{q},~]=ML_classifier_train(sample5,Label5,ratio,mu);
            err_prime(q) = err(q);                   
            s_prime(q) = size(Li{q},1) ;              
        end
    end
end

end

