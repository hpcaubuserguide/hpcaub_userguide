clc; clear;

% run a function locally
output_local = my_linalg_function(80, 300);

% run 4 jobs on the cluster, wait for the remote jobs to finish
% and fetch the results.
cluster = parcluster('Arza');

% run the jobs (asyncroneously)
for i=1:4
    jobs(i) = batch(cluster, @my_linalg_function, 1, {80, 600});
end

% wait for the jobs to finish
for i=1:4
    status = wait(jobs(i));
    outputs(i) = fetchOutputs(jobs(i));
end

% define a function that does some linaer algebra
function results = my_linalg_function(n_iters, mat_sz)
    results = zeros(n_iters, 1);
    for i = 1:n_iters
        results(i) = max(abs(eig(rand(mat_sz))));
    end
end
