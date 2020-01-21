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
factor = 1.820618101874320e-30;
m = 9.109e-31;
v = 2.59627974e8;
gamma = 1/sqrt(1 - (v^2)/(c^2));
q = 1.602e-19;
E = 200000;
B = 1;

% Get initial phase
pos = [track.initial_position_x track.initial_position_y];
mom = [track.initial_momentum_x track.initial_momentum_y];
    
v0 = arrayfun(@(x, y) norm([x y]), mom(:, 1), mom(:, 2)) ./ factor;
lamar = gamma.*m.*v0./(q*B);

nmom = mom./arrayfun(@(x, y) norm([x y]), mom(:, 1), mom(:, 2));
ic = -1*cell2mat(arrayfun(@(x, y) [x y]*R, nmom(:, 1), nmom(:, 2),'UniformOutput',false));

% Get final phase
pos = [track.final_position_x track.final_position_y];
mom = [track.final_momentum_x track.final_momentum_y];
nmom = mom./arrayfun(@(x, y) norm([x y]), mom(:, 1), mom(:, 2));
fc = -1*cell2mat(arrayfun(@(x, y) [x y]*R, nmom(:, 1), nmom(:, 2),'UniformOutput',false));

% Get simulated phase shifts
phase = arrayfun(@(a, b, x, y) atan2d(a*y-b*x,a*x+b*y), ic(:, 1), ic(:, 2), fc(:, 1), fc(:, 2));
phase = phase + (phase < 0)*360;

% Get simulated number of loops
%{
min_rad = 0.005;
loops = [];

for i=1:height(map)
    loop = 0;
    step_data = step(map.FIRST_STEP_INDEX(i) + 1 : map.LAST_STEP_INDEX(i), : );
    in_center = 1;
    for j=1:height(step_data)       
        d = norm([step_data(j,:).position_x step_data(j,:).position_y]);
        if(d < min_rad)
            if in_center == 0
                loop = loop + 1;
            end
            in_center = 1;
        else
            in_center = 0;
        end
    end
    loops = [loops; loop];
end
%}

% Compute expected phase shifts
pos = [track.initial_position_x track.initial_position_y];
te = track.initial_kinetic_energy + m_0;
gamma = te ./ m_0;
v0 = sqrt(1 - 1./(gamma.^2)).*c;

[az, el, ~] = arrayfun(@(x, y, z) cart2sph(x, y, z), track.initial_momentum_x, track.initial_momentum_y, track.initial_momentum_z,'UniformOutput',false);
[vx, vy, vz] = arrayfun(@(x, y, z) sph2cart(x, y, z), cell2mat(az), cell2mat(el), v0,'UniformOutput',false);

h = size(cell2mat(vx));
v = [cell2mat(vx), cell2mat(vy), zeros(h(1), 1)];
r = [-ic.*lamar, zeros(h(1), 1)];

nm = cell2mat(arrayfun(@(a, b, c) norm([a b c]), r(:, 1), r(:, 2), r(:, 3), 'UniformOutput', false));
vm = cell2mat(arrayfun(@(a, b, c) norm([a b c]), v(:, 1), v(:, 2), v(:, 3), 'UniformOutput', false));
w = vm ./ nm;

t = 0.05 ./ cell2mat(vz);
%tf = track.final_time;
%rotations = (w.*t)/(2*pi);
phase2 = mod((w.*t.*180)./pi, 360);
%phase3 = rand(h(1), 1)*360;

% Compare phase results
err = (phase - phase2) + 360*((phase - phase2) < -180) - 360*((phase - phase2) > 180);
figure; hist(err, 50);

% Compare rotation results
%figure; hist(roterr(abs(roterr) < 20), 25)
%roterr = loops - rotations;









