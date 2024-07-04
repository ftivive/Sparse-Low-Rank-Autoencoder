function scene = Scene_Design(TWI)

% COMPUTE THE RANGE AND CROSS-RANGE RESOLUTION
X          = 0 : TWI.X / TWI.No_C_px: TWI.X - TWI.X / TWI.No_C_px;
X          = X - mean(X);
Z          = 0 : TWI.Z / TWI.No_R_px: TWI.Z - TWI.Z / TWI.No_R_px;
%
% COMPUTE THE 2-D ARRAY FROM THE BOTTOM VIEW
[scene{1}, scene{2}] = meshgrid(X, Z);



% % COMPUTE THE RANGE AND CROSS-RANGE RESOLUTION
% Int_Dist_Z = (TWI.speed_light / (2*TWI.BandWidth)) * TWI.Z_Resolution_factor;
% Int_Dist_X = ((TWI.speed_light /  TWI.Freqs(end)) / TWI.Aperture_size) * (TWI.Z * TWI.X_Resolution_factor);
% X          = 0:Int_Dist_X:TWI.X/2;
% X          = [-X(end:-1:2), X];
% %
% % COMPUTE THE 2-D ARRAY FROM THE BOTTOM VIEW
% [scene{1}, scene{2}] = meshgrid(X, 0:Int_Dist_Z:TWI.Z);
