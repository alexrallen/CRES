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
factor = 1.820618101874320e-30;
m = 9.109e-31;
v = 2.59627974e8;
gamma = 1/sqrt(1 - (v^2)/(c^2));
q = 1.602e-19;
E = 200000;
B = 1;

% Track cumulative error
errc = [];

% Sample entire particle store
for i=1:100
    
    % Get particle path data and plot x/y plane projection (for simple viz)
    step_data = step(map.FIRST_STEP_INDEX(i) + 1 : map.LAST_STEP_INDEX(i), : );
    %plot(step_data.position_x, step_data.position_y); hold on;
    
    cps = [];
    
    % Get initial center from particle generator
    track_data = track(map.TRACK_INDEX(i) + 1, : );
    pos = [track_data.initial_position_x track_data.initial_position_y];
    mom = [track_data.initial_momentum_x track_data.initial_momentum_y];
    
    v0 = norm(mom) / factor;
    lamar = gamma*m*v0/(q*B);
    
    nmom = mom./norm(mom);
    theta = -90;
    R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
    ic = (nmom*R)*lamar + pos;
    
    % Get centers from particle path data
    for j=1:height(step_data)
        
        % Calculate theoretical center point given lamar radius
        px = [step_data(j,:).position_x step_data(j,:).position_y];
        v_i = [step_data.momentum_x(j) step_data.momentum_y(j)];
        v_i = v_i./norm(v_i);
        theta = -90;
        R = [cosd(theta) -sind(theta); sind(theta) cosd(theta)];
        cp = v_i*R;
        cp = cp * lamar;
        cp = cp + px;
        cpn = cp + [(E/B)*step_data(j,:).time 0]; % Attempt a correction
        cps = [cpn; cp];
        err = [err; norm(cp - ic)];
        errc = [errc; norm(cpn - ic)];
    end
    
    % Option to plot predicted centers
    %plot(cps(:,1),cps(:,2)); 
end

% Plot histogram of lamar radius errors
figure; hist(err, 50);
figure; hist(errc, 50);