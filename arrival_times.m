% Set simulation source
src = "const";

% Load data
if exist('oldsrc', 'var') == 0
    [step, track, map] = load_sim(src);
elseif oldsrc ~= src
    [step, track, map] = load_sim(src);
end
oldsrc = src;

% Constants
c = 3e8;

% Verify distrobution of arrival times
final_time = track.final_time;
vz = 0.05./final_time;
cs = vz/(0.866*c);

% Should be constant
hist(cs, 10); figure