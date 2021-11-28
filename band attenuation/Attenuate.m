% Attnuate inputs
function x = Attenuate(inputs, Attenuate)

x = zeros(size(inputs));

for j = 1:size(inputs, 1)
    x(j,:) = inputs(j,:) .* (...
        Attenuate.minval + (1 - Attenuate.minval) .* ...
        (1 - ...
        (1 - 1 ./ (1 + exp(- Attenuate.beta * (Attenuate.f_1 - j)))) .* ...
        (1 - 1 ./ (1 + exp(- Attenuate.beta * (j - Attenuate.f_2))))));
end

end