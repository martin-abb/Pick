%
%   analyze_003.m
%
%   Martin Krucinski
%
%   v_003 is used by a sweep algorithm to return tf (almost as a
%   function...)
%   Input arguments are:
%       v_coll
%       delta_1


g       = 9.81;     % [m/s^2]       Gravity acceleration
cm      = 0.01;     % [m]           1 centimeter
mm      = 0.001;    % [m]           1 millimeter
Ts      = 1e-3;     % [s]           motion profile sample time

a_max   = 24;%***2.0*g;      % [m/s^2]       Max acceleration
v_max   = 1.8; %***3;        % [m/s]         Max velocity

%**************************************************************************
%v_coll  = 0.1%0.5;      % [m/s]         Max allowed collision velocity
%**************************************************************************

% delta_1 = 0;        % [m]           Max uncertainty at location 1
% delta_2 = 0;        % [m]           Max uncertainty at location 2


%**************************************************************************
%delta_1 = 0%3*cm;     % [m]           Max uncertainty at location 1
%delta_2 = 2*cm;     % [m]           Max uncertainty at location 2
%delta_2 = 0*cm;     % [m]           Max uncertainty at location 2
%**************************************************************************

delta_2     = delta_1;

x1      = 0;        % [m]       Item 1 location
x2      = 922*mm; %***600*mm;   % [m]       Item 2 location
dx      = x2 - x1;  % [m]       Move distance

%**************************************************************************
%   Calculate table of move distances at various v_coll
%**************************************************************************

v_all       = [ 0.01 0.02 0.05 0.10 0.20 0.50 1.00 1.50 2.00];
dt_all      = v_all / a_max;
x_all       = 1/2*v_all.*dt_all;
disp('Move distances travelled vs. different max allowed collision velocities:')
res_all     = [ v_all ; x_all ]'

%**************************************************************************
%   Calculate distance moved until v_coll reached
%**************************************************************************

dx_coll     = 1/2*v_coll^2/a_max;

%**************************************************************************
%   Calculate motion profile WITHOUT uncertainty or
%   where uncertainty doesn't matter
%**************************************************************************

if delta_1 < eps || delta_1 < dx_coll,
    
    dt1     = v_max / a_max;
    dt3     = dt1;
    
    dx1     = 1/2*v_max*dt1; %*** alternate equation 1/2*a_max*dt1^2;
    
    %   Check if max velocity will be reached (trapezoidal velocity profile)
    %   or not (triangular velocity profile)
    
    if dx1 < dx/2,
        dx3     = dx1;
        dx2     = dx - (dx1 + dx3);
        dt2     = dx2 / v_max;
        v_points        = [0 v_max v_max 0];
    else % max velocity will NOT be reached
        dt1     = sqrt(dx/a_max);
        dt2     = 0;
        dt3     = dt1;
        dx1     = dx/2;
        dx2     = 0;
        dx3     = dx/2;
        v2      = dt1*a_max;
        
        v_points    = [ 0 v2 v2 0];
    end
    
    
    t_points        = cumsum([0 dt1 dt2 dt3]);
    x_points        = cumsum([0 dx1 dx2 dx3]);
    
    
    t0              = t_points(1);
    tf              = t_points(end);
    N               = round( (tf-t0)/Ts);
    t               = (0:(N-1))*Ts;
    
    v               = zeros(1,N);
    x               = zeros(1,N);
    
    for i=1:N,
        if t(i) < t_points(2),
            v(i)    = a_max*t(i);
        elseif t(i) < t_points(3),
            v(i)    = v_points(2);
        else
            v(i)    = v_points(3) - a_max*(t(i) - t_points(3));
        end
    end
    
else
    %**************************************************************************
    %   Calculate motion profile WITH uncertainty
    %**************************************************************************
    
    %     %   First, check if v_coll will be reached WITHIN uncertainty zone around
    %     %   item 1
    %
    %     dx1     = 1/2*v_coll^2/a_max;
    %
    %     if dx1 < delta_1,  % v_coll reached WITHIN uncertainty zone
    dx1     = dx_coll;
    dt1     = v_coll/a_max;
    dx2     = delta_1 - dx1;
    dt2     = dx2 / v_coll;     % time spent at safe velocity
    
    dt3     = (v_max - v_coll)/a_max; % acceleration time to max velocity
    dx3     = 1/2*(v_max + v_coll)*dt3;
    
    %   max velocity segment (if reached)
    dx4     = dx - 2 * (dx1 + dx2  + dx3);
    dt4     = dx4 / v_max;
    
    if dt4 > 0,     % max velocity HAS been reached,
        
        %   Segments 5 - 7 "mirror" images of segments 1-3 for now
        
        dt5     = dt3;
        dt6     = dt2;
        dt7     = dt1;
        dx5     = dx3;
        dx6     = dx2;
        dx7     = dx1;
        
        v_points        = [0 v_coll v_coll v_max v_max v_coll v_coll 0];
        
        t_points        = cumsum([0 dt1 dt2 dt3 dt4 dt5 dt6 dt7]);
        x_points        = cumsum([0 dx1 dx2 dx3 dx4 dx5 dx6 dx7]);
        
        
    else    % max velocity NOT reached
        
        disp('Max velocity NOT reached with uncertainty bounds')
        
        %   There will also be a case for when you need to limit velocity in
        %   the uncertainty zone BUT you don't achieve v_max in the
        %   remainder of the move
        
        %   calculate distance covered in the triangular middle velocity
        %   ramp that does not reach v_max
        
        dx_triangle     = dx - delta_1 - delta_2;
        
        a_eq            = 1/2*a_max;
        b_eq            = v_coll;
        c_eq            = - 1/2*dx_triangle;
        
        dt3_soln1       = (-b_eq + sqrt(b_eq^2 - 4*a_eq*c_eq))/2/a_eq;
        dt3_soln12      = (-b_eq - sqrt(b_eq^2 - 4*a_eq*c_eq))/2/a_eq;
        
        dt3             = dt3_soln1;
        
        dx4             = 0;
        dt4             = 0;
        
        dx3             = dx_triangle / 2;
        dx5             = dx_triangle / 2;
        dt5             = dt3;
        dx6             = dx2;
        dt6             = dt2;
        dx7             = dx1;
        dt7             = dt1;
        
        v_peak          = v_coll + a_max*dt3;
        
        v_points        = [0 v_coll v_coll v_peak v_peak v_coll v_coll 0];
        
        t_points        = cumsum([0 dt1 dt2 dt3 dt4 dt5 dt6 dt7]);
        x_points        = cumsum([0 dx1 dx2 dx3 dx4 dx5 dx6 dx7]);
    end
    
    t0              = t_points(1);
    tf              = t_points(end);
    N               = round( (tf-t0)/Ts);
    t               = (0:(N-1))*Ts;
    
    v               = zeros(1,N);
    x               = zeros(1,N);
    %     for i=1:N,
    %         if t(i) < t_points(2),
    %             v(i)    = a_max*t(i);
    %         elseif t(i) < t_points(3),
    %             v(i)    = v_coll;
    %         elseif t(i) < t_points(4),
    %             v(i)    = v_coll + (t(i) - t_points(3)) * a_max;
    %         elseif t(i) < t_points(5),
    %             v(i)    = v_max;
    %         elseif t(i) < t_points(6),
    %             v(i)    = v_max - (t(i) - t_points(5))*a_max;
    %         elseif t(i) < t_points(7),
    %             v(i)    = v_coll;
    %         else
    %             v(i)    = v_coll - a_max*(t(i) - t_points(7));
    %         end
    %     end
    
    for i=1:N,
        if t(i) < t_points(2),
            v(i)    = a_max*t(i);
        elseif t(i) < t_points(3),
            v(i)    = v_points(2);
        elseif t(i) < t_points(4),
            v(i)    = v_points(3) + (t(i) - t_points(3)) * a_max;
        elseif t(i) < t_points(5),
            v(i)    = v_points(4);
        elseif t(i) < t_points(6),
            v(i)    = v_points(5) - (t(i) - t_points(5))*a_max;
        elseif t(i) < t_points(7),
            v(i)    = v_points(6);
        else
            v(i)    = v_points(6) - a_max*(t(i) - t_points(7));
        end
    end
    
end     %   Calculate motion profile WITH uncertainty

x           = x1 + [0 cumsum(Ts*v(1:(end-1)))];
a           = [diff(v)/Ts 0];

if ~exist('no_fig') || no_fig == false,
    
    param_string = [ ' a\_max = ' num2str(a_max) '   v\_coll = ' num2str(v_coll) ...
        '   delta = ' num2str(delta_1) ];
    f1= figure;
    set(f1, 'DefaultLineLineWidth',3);
    plot(t_points, x_points, 'b*');
    hold on
    p12=stairs(t,x,'b');
    set(p12,'LineWidth',3);
    grid on
    xlabel('t [s]');
    ylabel('x [m]');
    title([ 'Motion profile   ' param_string ])
    
    f2= figure;
    set(f2, 'DefaultLineLineWidth',3);
    plot(t_points, v_points, 'r*');
    hold on
    p22=stairs(t,v,'r');
    set(p22,'LineWidth',3);
    grid on
    xlabel('t [s]');
    ylabel('v [m/s]');
    title([ 'Velocity profile   ' param_string])
    
    f3= figure;
    set(f3, 'DefaultLineLineWidth',3);
    p22=stairs(t,a,'k');
    set(p22,'LineWidth',3);
    grid on
    xlabel('t [s]');
    ylabel('a [m/s^2]');
    title([ 'Acceleration profile   ' param_string])
end

disp('Motion analysis results:')
disp([ 'Move time = ' num2str(tf) ' [s]'])

temp = 2+2;