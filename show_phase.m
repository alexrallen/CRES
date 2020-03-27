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
m_0 = 510.999e3;
c = 3e8;
theta = -90;
R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
m = 9.109e-31;
v = 2.59627974e8;
gamma = 2;
q = 1.602e-19;
E = 200000;
B = 1;

% Get initial phase
vtan = v.*vecnorm([track.initial_momentum_x track.initial_momentum_y], 2, 2)./... 
    vecnorm([track.initial_momentum_x track.initial_momentum_y track.initial_momentum_z], 2, 2);
    
larmor = gamma.*m.*vtan./(q*B);

ic = ([track.initial_momentum_x track.initial_momentum_y]./vecnorm([track.initial_momentum_x track.initial_momentum_y], 2, 2))*R...
    + [track.initial_position_x track.initial_position_y];

ic = -1*ic; % Point outwards

% Get final phase
fc = ([track.final_momentum_x track.final_momentum_y]./vecnorm([track.final_momentum_x track.final_momentum_y], 2, 2))*R...
    + [track.final_position_x track.final_position_y];

fc = -1*fc; % Point outwards

% Get simulated phase shifts
phase = arrayfun(@(a, b, x, y) atan2(a*y-b*x,a*x+b*y), ic(:, 1), ic(:, 2), fc(:, 1), fc(:, 2));
phase = phase + (phase < 0)*2*pi;


% Compute expected phase shifts

[az, el, ~] = arrayfun(@(x, y, z) cart2sph(x, y, z), track.initial_momentum_x, track.initial_momentum_y, track.initial_momentum_z,'UniformOutput',false);
[vx, vy, vz] = arrayfun(@(x, y, z) sph2cart(x, y, z), cell2mat(az), cell2mat(el), v*ones(size(el, 1), 1),'UniformOutput',false);

h = size(cell2mat(vx));
v = [cell2mat(vx), cell2mat(vy), zeros(h(1), 1)];
r = [-ic.*larmor, zeros(h(1), 1)];

nm = vecnorm(r, 2, 2);
vm = vecnorm(v, 2, 2);
w = vm ./ nm;

t = 0.05 ./ cell2mat(vz);
phase2 = mod(w.*t, 2*pi);

% Compare phase results
err = (phase - phase2) + 2*pi*((phase - phase2) < 0);
hist(err, 50);

%Graph features

title("Aggregate \Delta\theta Error")
xlabel("Error (rad)")
ylabel("Count (N = 17.2 mil samples)")








