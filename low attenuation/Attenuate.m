% Attnuate inputs
function x = Attenuate(inputs, Attenuate)
    
    x = zeros(size(inputs));
    
    for j = 1:size(inputs, 1)
        x(j,:) = inputs(j,:) .* (Attenuate.minval + (1 - Attenuate.minval) * (1 / (1 + exp(- Attenuate.beta * (j - Attenuate.f_0)))));
    end
    
end