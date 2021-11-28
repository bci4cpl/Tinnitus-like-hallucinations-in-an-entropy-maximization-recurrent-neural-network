function [ cost ] = GetCost(SimParams, Samples)
%GETCOST Get the mean cost for the first samples
%   Detailed explanation goes here

cost = 0;

V = SimParams.net.W;
R = SimParams.net.K;
N = SimParams.net.Outputs;
I = eye(N);

if (any(R(:)) == 0)
    noK = 1;
else
    noK = 0;
end

% Loop over samples
for nsample = 1 : SimParams.Cost.n_samp
    
    [~, gp] = SimParams.net.Evaluate(Samples.x(:,nsample));
    Phi = diag(gp);
    if (noK == 0)
        Phi = (I - Phi * R) \ Phi;
    end
    Chi = Phi * V;
    cost = cost + log(prod(svd(Chi)));
    
end

cost = -cost / SimParams.Cost.n_samp;

end