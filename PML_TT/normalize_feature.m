function [res] = normalize_feature(features)
    [sanmpe_size, ConditionalLength] = size(features);
    res = zeros(sanmpe_size, ConditionalLength);
    for i = 1 : ConditionalLength
        feature = features(:, i);
        MaxValue = max(feature);
        MinValue = min(feature);
        for j = 1 : sanmpe_size
            res(j, i) = (features(j, i) - MinValue) / (MaxValue - MinValue);
        end
    end
end