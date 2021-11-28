classdef Infomax < handle
    %INFOMAX Implements an InfoMax network
    %   An under-complete neural network with recurrent connections which learns using the
    %   information maximization approach.
    
    properties (Constant, GetAccess = private)
        Default_FF_ridge  = 0;      % Default Feed forward connections' ridge regression
        Default_Rec_ridge = 0;      % Default Recurrent connections' ridge regression
        Default_Beta      = 0;      % Default PCA term coefficient
        Default_niter     = 3000;   % Default number of iterative solve iterations
        Default_alpha     = 0.01; 	% Default euler method iterative solution parameter
        Default_tolfun    = 1e-8;   % Default iterative solve tolerance factor
    end
    properties (GetAccess = public, SetAccess = immutable)
        Inputs;                 % Number of input neurons
        Outputs;                % Number of output neurons
        Threshold;              % Use threshold?
    end
    properties (Access = public)
        FF_eta;                 % Feed forward connections' learning rate
        Rec_eta;                % Recurrent connections' learning rate
        FF_ridge;               % Feed forward connections' ridge regression
        Rec_ridge;              % Recurrent connections' ridge regression
        Beta;                   % PCA term coefficient
        niter;                  % Number of iterative solve iterations
        alpha;                  % Euler method iterative solution parameter
        tolfun;                 % Iterative solve tolerance factor
        K;                      % Recurrent connections
        W;                      % FF connections
    end
    
    methods
        
        % Properties access methods
        function value  = get.Inputs(obj)
            value = obj.Inputs;
        end
        function value  = get.Outputs(obj)
            value = obj.Outputs;
        end
        function value  = get.Threshold(obj)
            value = obj.Threshold;
        end
        function value  = get.FF_eta(obj)
            value = obj.FF_eta;
        end
        function set.FF_eta(obj, value)
            if (value < 0)
                error('Learning rate cannot be negative. ');
            else
                obj.FF_eta = value;
            end
        end
        function value  = get.Rec_eta(obj)
            value = obj.Rec_eta;
        end
        function set.Rec_eta(obj, value)
            if (value < 0)
                error('Learning rate cannot be negative. ');
            else
                obj.Rec_eta = value;
            end
        end
        function value  = get.FF_ridge(obj)
            value = obj.FF_ridge;
        end
        function set.FF_ridge(obj, value)
            if (value < 0)
                error('Rigde regression coefficient cannot be negative. ');
            else
                obj.FF_ridge = value;
            end
        end
        function value  = get.Rec_ridge(obj)
            value = obj.Rec_ridge;
        end
        function set.Rec_ridge(obj, value)
            if (value < 0)
                error('Rigde regression coefficient cannot be negative. ');
            else
                obj.Rec_ridge = value;
            end
        end
        function value  = get.Beta(obj)
            value = obj.Beta;
        end
        function set.Beta(obj, value)
            if (value < 0)
                error('Variance cannot be negative. ');
            else
                obj.Beta = value;
            end
        end
        function value  = get.niter(obj)
            value = obj.niter;
        end
        function set.niter(obj, value)
            if (value < 0)
                error('Number of iterations cannot be negative. ');
            else
                obj.niter = value;
            end
        end
        function value  = get.alpha(obj)
            value = obj.alpha;
        end
        function set.alpha(obj, value)
            if (value < 0 || value > 1)
                error('Step size cannot be negative. ');
            else
                obj.alpha = value;
            end
        end
        function value  = get.W(obj)
            value = obj.W;
        end
        function set.W(obj, value)
            obj.W = value;
        end
        function value  = get.K(obj)
            value = obj.K;
        end
        function set.K(obj, value)
            obj.K = value;
        end
        
        % Constructor
        function obj = Infomax(inputs, outputs, threshold, ...
                               FF_eta, Rec_eta, ...
                               FF_ridge, Rec_ridge, ...
                               beta, ...
                               niter, alpha, tolfun)
            obj = obj@handle;
            switch (nargin)
                case (0 || 1 || 2 || 3 || 4)
                    error('You must enter at least the size and learning rate of the network. ');
                case 5
                    obj.FF_ridge  = obj.Default_FF_ridge;
                    obj.Rec_ridge = obj.Default_Rec_ridge;
                    obj.Beta      = obj.Default_Beta;
                    obj.niter     = obj.Default_niter;
                    obj.alpha     = obj.Default_alpha;
                    obj.tolfun    = obj.Default_tolfun;
                case 6
                    obj.FF_ridge  = FF_ridge;
                    obj.Rec_ridge = obj.Default_Rec_ridge;
                    obj.Beta      = obj.Default_Beta;
                    obj.niter     = obj.Default_niter;
                    obj.alpha     = obj.Default_alpha;
                    obj.tolfun    = obj.Default_tolfun;
                case 7
                    obj.FF_ridge  = FF_ridge;
                    obj.Rec_ridge = Rec_ridge;
                    obj.Beta      = obj.Default_Beta;
                    obj.niter     = obj.Default_niter;
                    obj.alpha     = obj.Default_alpha;
                    obj.tolfun    = obj.Default_tolfun;
                case 8
                    obj.FF_ridge  = FF_ridge;
                    obj.Rec_ridge = Rec_ridge;
                    obj.Beta      = beta;
                    obj.niter     = obj.Default_niter;
                    obj.alpha     = obj.Default_alpha;
                    obj.tolfun    = obj.Default_tolfun;
                case 9
                    obj.FF_ridge  = FF_ridge;
                    obj.Rec_ridge = Rec_ridge;
                    obj.Beta      = beta;
                    obj.niter     = niter;
                    obj.alpha     = obj.Default_alpha;
                    obj.tolfun    = obj.Default_tolfun;
                case 10
                    obj.FF_ridge  = FF_ridge;
                    obj.Rec_ridge = Rec_ridge;
                    obj.Beta      = beta;
                    obj.niter     = niter;
                    obj.alpha     = alpha;
                    obj.tolfun    = obj.Default_tolfun;
                case 11
                    obj.FF_ridge  = FF_ridge;
                    obj.Rec_ridge = Rec_ridge;
                    obj.Beta      = beta;
                    obj.niter     = niter;
                    obj.alpha     = alpha;
                    obj.tolfun    = tolfun;
            end
            
            obj.Inputs      = inputs;
            obj.Outputs     = outputs;
            obj.Threshold   = threshold;
            obj.FF_eta      = FF_eta;
            obj.Rec_eta     = Rec_eta;
            obj.ResetConnections();
            
        end
        
    end
    methods (Access = public)
        
        function [g, gp, gpp] = Evaluate(obj, x)
            %EVALUATE Get an output vector s for an input vector x
            
            x1 = x;
            if (obj.Threshold)
                x1 = [x; -ones(1, size(x, 2))];
            end
            g = zeros(obj.Outputs, size(x1, 2)); gp = g; gpp = g;
            for i = 1:size(x, 2)
                [g(:,i), gp(:,i), gpp(:,i)] = obj.gcalc(x1(:,i));
            end
        end
        
        function Learn(obj, x)
            %LEARN Learn from a samples matrix x0
            
            V = obj.W;
            R = obj.K;
            eta_W = obj.FF_eta;
            eta_K = obj.Rec_eta;
            beta  = obj.Beta;
            
            if (eta_W == 0 && eta_K == 0)
                return;
            end
            
            dW = zeros(size(V));
            dV = zeros(size(V));
            dK = zeros(size(R));
            
            if (any(R(:)) == 0)  % If K is zero anyway
                noK = 1;
            else
                noK = 0;
            end
            
            N = obj.Outputs;
            M = obj.Inputs;
            I_N = eye(N);
            I_M = eye(M);
            
            % Loop over samples
            for nsample = 1 : size(x, 2)
                
                x1 = x(:,nsample);
                [s, gp, gpp] = obj.Evaluate(x1);
                
                Phi = diag(gp);
                if (noK == 0)
                    IGK = I_N - Phi*R;
                    Phi = IGK \ Phi;
                end
                
                Chi = Phi * V(:, 1:M);
                Chipinv = pinv(Chi);
                Xi = I_N;
                %Overcomplete
                if (N > M)
                    Xi = Chi * Chipinv;
                end
                gamma = diag(Xi * Phi) .* gpp ./ (gp .^ 3);
                
                % Aggregate connections' changes
                if (eta_W ~= 0)
                    dV(:,1:M) = Phi'*(Chipinv' + gamma * x1');
                    if (N < M && beta ~= 0)
                        % Undercomplete
                        x_perp = (I_M - Chipinv * Chi) * x1;
                        dV(:,1:M) = dV(:,1:M) + ...
                            beta .* Phi' * Chipinv' * x1 * x_perp';
                    end
                    if (obj.Threshold)
                        dV(:, M + 1) = -Phi'*gamma;
                    end
                    dW = dW + dV;
                end
                if (eta_K ~= 0)
                    dK = dK + Phi'*(Xi + gamma * s');
                end
                
            end
            
            % Change connections
            if (eta_W ~= 0)
                if (obj.FF_ridge ~= 0)
                    obj.W = obj.W - (eta_W .* obj.FF_ridge .* sign(obj.W));
                end
                obj.W = obj.W + ((eta_W / size(x, 2)) .* dW);
            end
            if (eta_K ~= 0)
                if (obj.Rec_ridge ~= 0)
                    obj.K = obj.K - (eta_K .* obj.Rec_ridge .* sign(obj.K));
                end
                dK(logical(eye(size(R)))) = 0;
                obj.K = obj.K + ((eta_K / size(x, 2)) .* dK);
            end
        end
        
        function [cost] = GetCost(obj, x)
            % GETCOST Get the cost function for a given input
            
            cost = 0;
            
            V = obj.W;
            R = obj.K;
            N = obj.Outputs;
            I = eye(N);
            
            if (any(obj.K(:)) == 0)  % If K is zero anyway
                noK = 1;
            else
                noK = 0;
            end
            
            % Loop over samples
            for nsample = 1 : size(x, 2)
                x0 = x(:,nsample);
                if (obj.Threshold)
                    x0 = [x(:,nsample); -1];
                end
                [~, gp] = obj.gcalc(x0);
                Phi = diag(gp);
                if (noK == 0)
                    Phi = (I - Phi * R) \ Phi;
                end
                Chi = Phi * V;
                cost = cost + log(prod(svd(Chi)));
            end
            
            cost = -cost / size(x, 2);
            
        end
        
        function [n_iter] = GetNIter(obj, x)
            %GETNITER Iteratively solve the activation function
            
            x1 = x;
            if (obj.Threshold)
                x1 = [x; -1];
            end
            
            beta    = obj.alpha;
            tol     = obj.tolfun;
            n       = obj.niter;
            n_iter  = n;
            
            % Initialize g
            g = g_f(zeros(obj.Outputs, 1));
            H = obj.W * x1;
            R = obj.K;
            
            % Iteratively solve g = g(Wx + Kg)
            for i = 1:n
                h = H + R * g;
                g1 = g_f(h);
                g = beta .* g1 + (1 - beta) .* g;
                % Check for convergence
                if (max(abs(g1 - g)) < tol)
                    n_iter = i;
                    break;
                end
            end
            
        end
        
        function [pop_vec] = GetPopulationVector(obj, n_samples)
            %GETPOPULATIONVECTOR Get the population vector for no input and 
            % weak initial output
            
            sigma   = 0.1;
            beta    = obj.alpha;
            tol     = obj.tolfun;
            n       = obj.niter;
            R       = obj.K;
            pop_vec = zeros(n_samples, 1);
            PO      = (1:obj.Outputs)'./obj.Outputs;
            eiPO    = exp((2*pi*1i).*PO);
            
            for s = 1:n_samples
                
                % Initialize g
                g = g_f(zeros(obj.Outputs, 1)) + sigma.*randn(obj.Outputs, 1);
                
                % Iteratively solve g = g(Kg)
                for i = 1:n
                    g1 = g_f(R * g);
                    g = beta .* g1 + (1 - beta) .* g;
                    % Check for convergence
                    if (max(abs(g1 - g)) < tol)
                        break;
                    end
                end
                
                % Get the population vector
%                 pv = sum(g.*eiPO)/sum(g);
                pv = sum(g.*eiPO)/obj.Outputs;
                pop_vec(s) = abs(pv);
                
            end
            
            % Get the average population vector
            pop_vec = mean(pop_vec);
            
        end
        
        function ResetConnections(obj)
            %RESETCONNECTIONS Reset all network's connections
            
            tmp = Infomax.TonotopicMap(obj.Inputs, obj.Outputs);
            obj.W = tmp;
            if (obj.Threshold)
                obj.W = zeros(obj.Outputs, obj.Inputs + 1);
                obj.W(:,1:obj.Inputs) = tmp;
            end
            obj.K = zeros(obj.Outputs);
        end
    end
    methods (Access = private, Static)
        
        function W = TonotopicMap(inputs, outputs)
            %MEXICANHATS Generate FF initial matrix to mexican hats
            
            f_num = 50;
            f_min = 20; % minimal frequency
            f_max = f_min + (f_num - 1) * 10; % maximal frequency
            f_inp = linspace(f_min, f_max, inputs); % Hz
            a = 0.01; % amplitude
            
            W = ones(outputs, length(f_inp));
            sigma = 1 * (f_inp(end) - f_inp(1)) / (f_num - 1);
            f_out = linspace(f_inp(1), f_inp(end), outputs);
            
            for i = 1:outputs
                W(i,:) = normpdf(f_inp, f_out(i), sigma);
            end
            
            W = a * W / (sum(W(:) / size(W, 1)));
            
        end
        
        function [g, gp, gpp] = gfunc(x)
            %GFUNC The neurons activation function
            %   1 / (1 + exp(-x))
            
            g   = g_f(x);
            gp  = g .* (1 - g);
            gpp = gp .* (1 - 2 * g);
            
        end
        
    end
    methods (Access = private)
        
        function [g, gp, gpp] = gcalc(obj, x)
            %GCALC Iteratively solve the activation function
            
            H = obj.W * x;
            R = obj.K;
            
            % If K is zero anyway
            if (any(R(:)) == 0)
                [g, gp, gpp] = Infomax.gfunc(H);
            else
%                 % Euler's method for ds/dt = -s + g(Wx + Ks)
%                 beta    = obj.alpha;
%                 tol     = obj.tolfun;
%                 n       = obj.niter;
%                 lastC   = (2 * obj.Outputs) ^ 2 + 1;  % Bigger than any possible change
%                 
%                 % Initialize g
%                 g = g_f(zeros(obj.Outputs, 1));
%                 
%                 % Iteratively solve ds/dt = -s + g(Wx + Ks)
%                 for i = 1:n
%                     g1 = g_f(H + R * g);
%                     diff = g1 - g;
%                     change = diff' * diff;
%                     if change > lastC               % Overshooting
%                         if beta > 0.0001            % Reduce beta unless it's too small
%                             beta = beta / 2;
%                         end
%                     else
%                         if beta < 0.5               % Increase beta unless it's too big
%                             beta = beta * 1.03;
%                         end
%                     end
%                     lastC = change;                 % Track the last change
%                     g = beta .* g1 + (1 - beta) .* g;
%                     % Check for convergence
% %                     if (rem(i, 20) == 0) && (mean(abs(g1 - g)) < tol)
%                     if (rem(i, 20) == 0 && change < tol)
%                         break;
%                     end
%                 end
                
                % Newton's method s = g(Wx + Ks)
                tol     = obj.tolfun;
                n       = obj.niter;
                N       = obj.Outputs;
				I		= eye(N);
                
                % Initialize g
                g = g_f(zeros(N, 1));
                
                % Iteratively solve s = g(Wx + Ks)
                for i = 1:n
                    [g1, gp1] = g_f(H + R * g);
                    G = diag(gp1);
                    psi = I - G * R;
                    D = psi \ (g1 - g);
                    g = g + D;
                    % Check for convergence
                    if (mean(abs(D)) < tol)
                        break;
                    end
                end
                
                % Evaluate output
                h = H + R * g;
                [g, gp, gpp] = Infomax.gfunc(h);
            end
            
        end
        
    end
    
end

function [g, gp] = g_f(x)
%GFUNC The neurons activation function
%   1 / (1 + exp(-x))
g   = 1 ./ (1 + exp(-x));
if (nargout > 1)
    gp  = g .* (1 - g);
end
end