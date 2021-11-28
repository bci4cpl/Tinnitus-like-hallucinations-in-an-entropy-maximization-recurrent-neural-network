% Generate input
function x = GenInput(inputs, n_samples, InputGen)

x = zeros(inputs, n_samples);

f_inp = 1:inputs;
for sample_count = 1:n_samples
    n_tones = randi(InputGen.n_tones_max);
	sound = inputs.*rand(1, n_tones);
	sound_std = 0.5.*inputs.*abs(randn(1, n_tones));
    amp = InputGen.a_min + ...
		(InputGen.a_max - InputGen.a_min).*rand(1, n_tones);
    x1 = zeros(inputs, 1);
	for k = 1:n_tones
		x1 = x1 + ...
			amp(k).*sqrt(2*pi).*sound_std(k).* ...
			normpdf(f_inp', sound(k), sound_std(k));
	end
    x(:, sample_count) = x1;
end

% add noise
noise = InputGen.noise_fac .* (2 .* rand(size(x)) - 1);
x = x + noise + InputGen.white_noise;

% % normalize
% x = x ./ max(abs(x(:)));
% 
% % clear extreme inputs
% k = 0;
% y = zeros(size(x));
% for i = 1:n_samples
%     if max(x(:,i)) < 0.1
%         k = k + 1;
%         y(:,k) = x(:,i);
%     end
% end
% x = y(:, 1:k);

% renormalize
x = 0.5 .* x ./ max(abs(x(:)));

end