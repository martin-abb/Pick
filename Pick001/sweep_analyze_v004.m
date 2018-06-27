%
%   sweep_analyze_v004.m
%
%   Martin Krucinski
%
%   Script to sweep several parameters for pick rate / move time analysis
%
%   Uses analyze_v004.m as a "function" for calculations....
%   and as sweep parameters
%       v_coll
%       delta_1
%
%   Used for IRB 1600 large move (160 degree sweep) analysis

%no_fig      = false   %true;
no_fig      = true;

all_v_coll  = [ ...
%    0.01
    0.02
    0.05
    0.100
    0.200
    0.500
    ];

all_delta   = [ ...
    0.02
    0.002
    0.000
    ];

%
%   large sweep range
%   2018-06-15
% all_v_coll  = [ ...
%     0.050
%     0.100
%     0.200
%     0.500
%     1.000
%     ];
% 
% all_delta   = [ ...
%     0.03
%     0.02
%     0.01
%     0.005
%     0.002
%     0.000
%     ];

% all_v_coll  = [ ...
%     0.050
% %    0.100
% %    0.200
% %    0.500
%     1.000
%     ];
% 
% all_delta   = [ ...
%     0.03
% %    0.02
%     0.01
% %    0.005
% %    0.002
%     0.000
%     ];

M1          = length(all_v_coll);
M2          = length(all_delta);
N           = M1*M2;

res_tf      = zeros(N,1);       % storage for all move times
res_v_coll  = zeros(N,1);
res_delta   = zeros(N,1);

ind         = 1;
for ni=1:M1,
    for nj = 1:M2,
        v_coll      = all_v_coll(ni);
        delta_1     = all_delta(nj);
        
        res_v_coll(ind)         = v_coll;
        res_delta(ind)          = delta_1;
        
        analyze_004;
        
        res_tf(ind) = tf;
        ind         = ind+1;
    end
end


%res_tf_matrix    = reshape(res_tf, M1, M2);
res_tf_matrix    = reshape(res_tf, M2, M1);

%-------------------------------------------------------------------------
f10 = figure;
%surface(res_tf_matrix)
bar3(res_tf_matrix);
ax=gca;
set(ax,'XTickLabel',num2cell(all_v_coll));
set(ax,'YTickLabel',num2cell(all_delta));

ylabel('delta [m]')
xlabel('v\_coll [m/s]')
zlabel('Move Time [s]')

%   Picks per hour

res_pphr_matrix     = 3600 ./ (2.*res_tf_matrix);

%-------------------------------------------------------------------------
f11 = figure;
bar3(res_pphr_matrix);
ax=gca;
set(ax,'XTickLabel',num2cell(all_v_coll));
set(ax,'YTickLabel',num2cell(all_delta));

ylabel('delta [m]')
xlabel('v\_coll [m/s]')
zlabel('Pick rate [picks/hr]')

%   Calculate summary results for 
%   base case with uncertainty 3D = 2 cm and 
%   improved case secondary sensor 2 = 2 mm
%   all_delta   = [    0.02    0.002    0.000 ];

t_move_1_b    = ( res_tf_matrix(3,:) + res_tf_matrix(1,:) ) / 2;  % move time from start position to item
                                                                % uncertainty
                                                                % only at
                                                                % final
                                                                % destination
                                                                % not at
                                                                % start
                                                                % position
                                                                
t_move_2_b    = res_tf_matrix(3,:);                               % no uncertainty when moving to drop-off point

all_v_coll
t_move_b      = (t_move_1_b + t_move_2_b)'                              % total move times

pick_rates_b  = 3600 ./ t_move_b

t_move_1_i    = ( res_tf_matrix(3,:) + res_tf_matrix(2,:) ) / 2;  % move time from start position to item
t_move_2_i    = t_move_2_b;                                     % same as base, no uncertainty at drop-off location
t_move_i      = (t_move_1_i + t_move_2_i)'                              % total move times
pick_rates_i  = 3600 ./ t_move_i

t_move_delta    = t_move_b - t_move_i                   % move time improvements (actually cycle times)
pick_rates_delta = pick_rates_i - pick_rates_b

%   Calculate percent improvement in pick rate

pick_rates_i_percent    = pick_rates_delta ./ pick_rates_b * 100

%-------------------------------------------------------------------------
f12=figure;
bar3([t_move_b t_move_i]);
ax=gca;
set(ax,'YTickLabel',num2cell(all_v_coll));
set(ax,'XTickLabel',{'Base','Improved'});

ylabel('v\_coll [m/s]')
zlabel('Cycle time [s]')

%-------------------------------------------------------------------------
f13=figure;
bar3([pick_rates_b pick_rates_i]);
ax=gca;
set(ax,'YTickLabel',num2cell(all_v_coll));
set(ax,'XTickLabel',{'Base','Improved'});

ylabel('v\_coll [m/s]')
zlabel('Pick rate [pick/hr]')


%-------------------------------------------------------------------------
f14=figure;
xN      = 6;
xind    = 1:xN;

mm      = 1e-3;

bar(x_all(xind) / mm)
ax=gca;
set(ax,'XTickLabel',num2cell(v_all(xind)));
xlabel('v\_coll [m/s]')
ylabel('Crush distance [mm]')
grid on


%-------------------------------------------------------------------------
%   Plot percent pick rate improvement

f15=figure;

bar( pick_rates_i_percent )
ax=gca;
set(ax,'XTickLabel',num2cell(all_v_coll));
xlabel('v\_coll [m/s]')
ylabel('Pick rate Improvement [%]')
grid on


%-------------------------------------------------------------------------
%   Crush distance for only the velocities in all_v_coll
% i_all   = find(abs(
% f15=figure;
% bar(x_all / cm)
% ax=gca;
% set(ax,'XTickLabel',num2cell(v_all));
% xlabel('v\_coll')
% ylabel('Crush distance [cm]')

