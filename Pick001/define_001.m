%
%   define_001.m
%
%   Martin Krucinski

%   Note: all linear dimensions units are in millimeters [mm]

%   Define Bin dimensions

%   suffix .O - outside dimension
%   suffix .I - inside dimension

%   x aligned with L, y aligned with W, z aligned with H

Bin.O.L     = 615;
Bin.O.W     = 375;
Bin.O.H     = 206;

Bin.I.L     = 480;
Bin.I.W     = 300;
Bin.I.H     = 200;

%   offsets from outsed walls to inside walls, z handled differently

Bin.offset.O_I_x        = (Bin.O.L - Bin.I.L)/2;
Bin.offset.O_I_y        = (Bin.O.W - Bin.I.W)/2;
Bin.offset.O_I_z        = (Bin.O.H - Bin.I.H);  % note! z-offset should be the bin bottom thickness


%   Define Crayola crayon box dimensions, aligned with long dimension L
%   along x

Item1.Name      = 'Crayons';
Item1.L         = 150;
Item1.W         = 37;
Item1.H         = 125;

%   Define Crayola crayon box location with its corner in the middle of a bin

Item1.x         = Bin.I.L/2 + Bin.offset.O_I_x;
Item1.y         = -(Bin.I.W/2 + Bin.offset.O_I_y);
Item1.z         = Bin.offset.O_I_z;

%   Define Crayola crayon box grip points, jaw & suction

Item1.jaw.x    = Item1.x + Item1.L/2;
Item1.jaw.y    = Item1.y - Item1.W/2;
Item1.jaw.z    = Item1.z + Item1.H - 50;    % grasp Crayola box 50 mm down from top surface

%   Define start positions for robot from which to "dive down" into the bin

Item1.jaw_start.x   = Item1.jaw.x;
Item1.jaw_start.y   = Item1.jaw.y;
Item1.jaw_start.z   = Item1.jaw.z + 300;    % start 300 mm above grip point for now


%   Suction Gripper

Gripper_Suction.x       = 0;
Gripper_Suction.y       = 0;
Gripper_Suction.z       = 195;  %   account for approx. 5 mm compressions of suction cup / bellows to get a good grip

%   Jaw Gripper

Gripper_Jaw.x           = 0;
Gripper_Jaw.y           = 0;
Gripper_Jaw.z           = 230;
