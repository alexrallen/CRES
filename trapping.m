% Set simulation source
src = "trap";

% Load data
if exist('oldsrc', 'var') == 0
    [step, track, map] = load_sim(src);
elseif oldsrc ~= src
    [step, track, map] = load_sim(src);
end
oldsrc = src;

% Constants
c = 3e8;
factor = 1.820618101874320e-30;
m = 9.109e-31;
v = 2.59627974e8;
gamma = 1/sqrt(1 - (v^2)/(c^2));
q = 1.602e-19;
E = 200000;
B = 1;

for i=5:5
    
    % Get particle path data and plot x/y plane projection (for simple viz)
    step_data = step(map.FIRST_STEP_INDEX(i) + 1 : map.LAST_STEP_INDEX(i), : );
    plot(step_data.position_z, step_data.position_y); hold on;
end