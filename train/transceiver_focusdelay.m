function [focus_delay, mask] = Transceiver_Focusdelay(TWI, X_grid, Z_grid, Rx_dist)

%--------------------------------------------------------------------------
Rx_dist(2) = TWI.Zoff;
%--------------------------------------------------------------------------
% The computation of the TOA for TWI is based on the method proposed by
% Michal et al. Paper title: Efficient Method of TOA Estimation for the
% Through Wall Imaging by UWB Radar.
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% Wall Thickness
wall_dist = (TWI.wall_thickness + TWI.wall_thickness_error);
%--------------------------------------------------------------------------
% Wall Permittivity
root_E    = sqrt(TWI.dielectric_value + TWI.dielectric_error);
%--------------------------------------------------------------------------
% Compute the focus delay from the receiver to the target pixel
%--------------------------------------------------------------------------
D         = abs(X_grid - Rx_dist(1));
H         = Z_grid + Rx_dist(2) - wall_dist;
%--------------------------------------------------------------------------
co        = cell(5,1);
co{1}     = (TWI.speed_light^2 - TWI.wall_velocity^2) * ones(size(D));
co{2}     = 2 * D * (TWI.wall_velocity^2 - TWI.speed_light^2);
co{3}     = (D.^2 .* co{1}) + (TWI.speed_light^2 * H.^2) - (TWI.wall_velocity^2 * wall_dist^2);
co{4}     = 2 * TWI.wall_velocity^2 * wall_dist^2 * D;
co{5}     = -TWI.wall_velocity^2 * wall_dist^2 * D.^2;
%--------------------------------------------------------------------------
d         = (1/root_E) * ((D * wall_dist) / (Rx_dist(2) + wall_dist));
for m = 1:TWI.num_iterations
    Nume   = (co{1} .* d.^4) + (co{2} .* d.^3) + (co{3} .* d.^2) + (co{4} .* d) + co{5};
    Denome = 0;
    for j = 1:4
        temp  = 0;
        for k = 1:j
            temp = temp + (co{k} .* d.^(j-k));
        end
        Denome = Denome + (temp .* d.^(4-j));
    end
    d = abs(d - (Nume ./ (Denome + eps)));
end
%--------------------------------------------------------------------------
% Critical angle should be less than 90 degree
mask           = double(atan(d/wall_dist) <= pi/2);
%--------------------------------------------------------------------------
d_air          = sqrt(H.^2 + (D - d).^2);
d_wall         = sqrt(wall_dist^2 + d.^2);
focus_delay    = 2 * ((d_air / TWI.speed_light) + (d_wall / TWI.wall_velocity));

%--------------------------------------------------------------------------
