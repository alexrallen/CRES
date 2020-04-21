% Set simulation source
src = "trap";

% Load data
if exist('oldsrc', 'var') == 0
    [step, track, map] = load_sim(src);
elseif oldsrc ~= src
    [step, track, map] = load_sim(src);
end
oldsrc = src;


times_ahead = [0; step.position_z(1:end-1)];
times = step.position_z;
times_behind = [step.position_z(2:end); 0];
turnaround = (abs(times_ahead) < abs(times)).*(abs(times_behind) < abs(times));

m = arrayfun(@(x,y,z)  repmat(x + 1, z - y + 1, 1), map.TRACK_INDEX, map.FIRST_STEP_INDEX, map.LAST_STEP_INDEX, 'UniformOutput', false);
m = vertcat(m{:});

step.track_id = m;
turn_data = step(turnaround == 1,:);

turnlist = arrayfun(@(x) table2array(turn_data(turn_data.track_id == (x + 1),'time')), map.TRACK_INDEX, 'UniformOutput', false);
zlist = arrayfun(@(x) table2array(turn_data(turn_data.track_id == (x + 1),'position_z')), map.TRACK_INDEX, 'UniformOutput', false);

turntimes = arrayfun(@(x) mean(diff(x{1, 1}(2:end-1))), turnlist);
turnz = arrayfun(@(x) mean(abs(diff(x{1, 1}(2:end-1)))), zlist);
track.turn_time = turntimes;
track.turn_z = turnz;

disp(["Trapping Fraction " num2str(size(track(track.terminator_name == "term_max_steps", :), 1) / size(track, 1))]);

figure;
scatter(step.position_z, step.magnetic_field_z);
title("Magnetic Field")
xlabel("z position (m)")
ylabel("B-Field z-component (T)")

figure;
scatter(track.initial_polar_angle_to_z, track.turn_time);
title("Oscillation Time vs. Pitch Angle")
xlabel("Pitch Angle (degrees)");
ylabel("Elapsed Time Between Classical Turning Points (s)");

figure;
scatter(track.initial_polar_angle_to_z, track.turn_z);
title("Oscillation Width vs. Pitch Angle");
xlabel("Pitch Angle (degrees)");
ylabel("Distance Between Classical Turning Points (m)");


%% Trapping Fraction for Uniform Spatial Dist. 

% Set simulation source
src = "trap_uniform";

% Load data
if exist('oldsrc', 'var') == 0
    [~, track, ~] = load_sim(src);
elseif oldsrc ~= src
    [~, track, ~] = load_sim(src);
end
oldsrc = src;


disp(["Trapping Fraction " num2str(size(track(track.terminator_name == "term_max_steps", :), 1) / size(track, 1))]);
disp(["Left Geometry" num2str(size(track(track.terminator_name == "term_max_z", :), 1) / size(track, 1))]);
disp(["Larmor Exceeds Geometry" num2str(size(track(track.terminator_name == "term_max_r", :), 1) / size(track, 1))]);


