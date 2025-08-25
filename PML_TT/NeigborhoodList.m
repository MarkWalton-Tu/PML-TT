function [res] = NeigborhoodList(features,Threshold,indexs)
%NEIGBORHOODLIST 
    if(nargin == 2)
        indexs = 'all';
    end

    if strcmp(indexs,'all') == 0  
        tmp_fearures = features(:, indexs);
    else
        tmp_fearures = features;
    end
    tmp_fearures = normalize_feature(tmp_fearures); 
    sample_size = size(tmp_fearures, 1);
    T = zeros(sample_size,sample_size);
    for i = 1 : sample_size       
        Vector_1 = tmp_fearures(i, :);
        for j = i+1 : sample_size
            Vector_2 = tmp_fearures(j, :);
            Distance = norm(Vector_1 - Vector_2);
            if Distance <= Threshold
                T(i,j) = 1;
                T(j,i) = 1;
            end
        end
       
    end 
    res= T;
end


