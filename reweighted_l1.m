%% reweighted l1 minimization
% This program needs the l1-magic toolbox to run
% url: https://statweb.stanford.edu/~candes/software/l1magic/

close all; clear; clc;

% To make the experiment reproducible
load RandomStates
rand('state', rand_state);
randn('state', randn_state);

% signal length
N = 512;
% number of spikes in the signal
T = 130;
% number of observations to make
K = 256;
% number of iterations
niter = 3;
% regularization parameter
epsilon = 0.1;

% random signal
x = zeros(N,1);
q = randperm(N);
x(q(1:T)) = randn(T,1);

% measurement matrix
disp('Creating measurment matrix...');
A = randn(K,N);
A = orth(A')';
disp('Done.');
	
% observations
y = A*x;

% initial guess = min energy
x0 = A'*y;

% initial weight
W = ones(N,1);

% solve the LP
for i = 1:niter
    xp = diag(W)\l1eq_pd(x0, A/diag(W), [], y, 1e-3);
    W = 1./(abs(xp) + epsilon);
    x0 = xp;
end

figure(1)
plot(x)
xlim([0, 520])
xlabel('i')
ylabel('x_{0,i}')
figure(2)
plot(xp)
xlim([0, 520])
figure(3)
plot(x, xp, 'o')
hold on
plot(x, x, 'k:')
axis equal
axis([-2.5 2.5 -2.5 2.5])
xlabel('x_0')
ylabel('x^{(2)}')