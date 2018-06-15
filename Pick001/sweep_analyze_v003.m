%
%   sweep_analyze_v003.m
%
%   Martin Krucinski
%
%   Script to sweep several parameters for pick rate / move time analysis
%
%   Uses analyze_v003.m as a "function" for calculations....
%   and as sweep parameters
%       v_coll
%       delta_1

%no_fig      = false   %true;
no_fig      = true;

all_v_coll  = [ ...
    0.050
    0.100
    0.200
    0.500
    1.000
    ];

all_delta   = [ ...
    0.03
    0.02
    0.01
    0.005
    0.002
    0.000
    ];

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
        
        analyze_003;
        
        res_tf(ind) = tf;
        ind         = ind+1;
    end
end


%res_tf_matrix    = reshape(res_tf, M1, M2);
res_tf_matrix    = reshape(res_tf, M2, M1);

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
f11 = figure;
bar3(res_pphr_matrix);
ax=gca;
set(ax,'XTickLabel',num2cell(all_v_coll));
set(ax,'YTickLabel',num2cell(all_delta));

ylabel('delta [m]')
xlabel('v\_coll [m/s]')
zlabel('Pick rate [picks/hr]')