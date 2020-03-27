% Set simulation source
src = "eb";

% Load data
if exist('oldsrc', 'var') == 0
    [step, track, map] = load_sim(src);
elseif oldsrc ~= src
    [step, track, map] = load_sim(src);
end
oldsrc = src;

% Constants
c = 3e8;
mass = 9.10938363e-31;
v = 2.59627974e8;
gamma = 2;
q = 1.60217663e-19;
E = 200000;
B = 1;
theta = -90;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];

vtan = v.*vecnorm([track.initial_momentum_x track.initial_momentum_y], 2, 2)./... 
    vecnorm([track.initial_momentum_x track.initial_momentum_y track.initial_momentum_z], 2, 2);

larmor = gamma*mass*vtan/(q*B);

ic = ([track.initial_momentum_x track.initial_momentum_y]./vecnorm([track.initial_momentum_x track.initial_momentum_y], 2, 2))*R...
    .*larmor...
    + [track.initial_position_x track.initial_position_y];


m = arrayfun(@(x,y,z)  repmat(x + 1, z - y + 1, 1), map.TRACK_INDEX, map.FIRST_STEP_INDEX, map.LAST_STEP_INDEX, 'UniformOutput', false);
m = vertcat(m{:});

l = arrayfun(@(x) larmor(m(x)), (1:1:size(step.momentum_x, 1)).');
c = cell2mat(arrayfun(@(x) ic(m(x),:), (1:1:size(step.momentum_x, 1)).', 'UniformOutput', false));

cp = (([step.momentum_x step.momentum_y]./vecnorm([step.momentum_x step.momentum_y], 2, 2))*R).*l...
    + [step.position_x step.position_y];

err = vecnorm(cp - c, 2, 2);
errc = vecnorm(cp - c + [(E/B)*step.time, zeros(size(step, 1), 1)], 2, 2); % Drift Correction



% Plot histogram of lamar radius errors
subplot(1, 2, 1); hist(err, 50); title("Raw Error");
xlabel("Distance Between Predicted and Simulated Center (m)");
ylabel("Count (N = 2.3 mil samples)")

subplot(1, 2, 2); hist(errc, 50); title("Corrected Error");
xlabel("Distance Between Predicted and Simulated Center (m)");
ylabel("Count (N = 2.3 mil samples)")

figure
scatter(step.time, err, 10, 'Filled'); hold on
scatter(step.time, errc, 10, 'Filled');
title("Error vs. Time")
xlabel("Time (s)")
ylabel("Distance Between Centers (m)")
legend(["Raw Error" "Corrected Error"])

