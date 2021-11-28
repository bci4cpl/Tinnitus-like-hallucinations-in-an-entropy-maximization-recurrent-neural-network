clear all;
close all;
clc;

%% 

n_samples = 3000;

R = @(theta) [ cos(theta), sin(theta);
              -sin(theta), cos(theta)];
D = diag([sqrt(3)/sqrt(2), sqrt(2)/2]);
mu = [-sqrt(3)/2; 1/2];

X1 = D*R(pi/4)*rand(2, floor(n_samples/3)) + mu;

X2 = D*R(pi/4)*rand(2, floor(n_samples/3)) + mu;
X2 = R(2*pi/3)*X2;

X3 = D*R(pi/4)*rand(2, ceil(n_samples/3)) + mu;
X3 = R(4*pi/3)*X3;

X = [X1, X2, X3];

disp([num2str(n_samples) ' samples generated successfully. ']);
disp('');

%%

eta = 0.01;
Net = Infomax(2, 3, 0, eta, 0, 0, 0, 0);
Net.W = (1/sqrt(2)).*randn(3, 2);

%%

n_train = 1000;

figure();
for t = 1:n_train
    Net.Learn(X(:, randperm(n_samples, 1)));
    if (rem(t, 5) == 0 || t == n_train)
        scatter(X(1,:), X(2,:), 'k.');
        hold on;
        Wpinv = pinv(Net.W);
        Wpinv = Wpinv ./ sqrt(max(diag(Wpinv*Wpinv')));
        quiver(zeros(1,3), zeros(1,3), Wpinv(1,:), Wpinv(2,:), ...
            'b', 'Linewidth', 2);
        hold off;
        title(sprintf('t=%d', t), 'Interpreter', 'latex');
        axis square;
        xlim([-1, 1]);
        xlabel('$x_1$', 'Interpreter', 'latex');
        ylim([-1, 1]);
        ylabel('$x_2$', 'Interpreter', 'latex');
        drawnow;
        pause(0.01);
    end
end

