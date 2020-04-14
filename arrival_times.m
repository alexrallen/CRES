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
vz = vz / (0.866*c);

% Should be constant
nbins = 10;
avg = mean(hist(vz, nbins));
dev = std(hist(vz, nbins));
hist(vz, nbins); hold on;

yline(avg + 2*dev,'color','green');
yline(avg,'color','red');
yline(avg - 2*dev,'color','green');

title("Portion of Velocity on Z-axis");
ylabel("Counts (N = 42474)");
xlabel("v_z/v");