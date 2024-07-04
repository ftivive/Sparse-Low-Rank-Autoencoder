%% load parameters of the sparse autoencoder
load('autoencoder_weight', 'P', 'V', 'W');
%% load test data
savefilename = 'TWRI_Image';
load test_data.mat;
%
raw_data          = normalize_atoms(raw_data);
denoise_data      = V * sig_func(W * (Target_scene1 - P * raw_data)); 
% detail of the scene
tol               = -30;
TWI.Z             = 4.5; 
TWI.Zoff          = 1.5;
TWI.No_R_px       = 100;
TWI.No_C_px       = 100;
scene             = Scene_Design(TWI);     
X_axis            = scene{1}(1,:);
Z_axis            = scene{2}(:,1);   
% perform delay and sum beamforming
TWI.Received_Data = denoise_data;
S                 = ds_2dbeamforming(TWI, TWI.Received_Data, scene);
TWI_image         = abs(reshape(S, size(scene{1})));
% parameters for plots
width  = 2;      % Width in inches
height = 2;      % Height in inches
alw    = 0.75;   % AxesLineWidth
fsz    = 8;     % Fontsize
lw     = 2;      % LineWidth
msz    = 9;      % MarkerSize
%
close all;
% The properties we've been using in the figures
set(0,'defaultLineLineWidth',lw);   % set the default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz
set(0,'defaultLineLineWidth',lw);   % set tnumel(c)he default line width to lw
set(0,'defaultLineMarkerSize',msz); % set the default line marker size to msz
% Set the default Size for display
defpos = get(0,'defaultFigurePosition');
set(0,'defaultFigurePosition', [defpos(1) defpos(2) width*100, height*100]);
% Set the defaults for saving/printing to a file
set(0,'defaultFigureInvertHardcopy','on'); % This is the default anyway
set(0,'defaultFigurePaperUnits','inches'); % This is the default anyway
defsize = get(gcf, 'PaperSize');
left    = (defsize(1)- width)/2;
bottom  = (defsize(2)- height)/2;
defsize = [left, bottom, width, height];
set(0, 'defaultFigurePaperPosition', defsize);
%
TWI_image = TWI_image / max(TWI_image(:));
imagesc(X_axis, Z_axis, 20*log10(TWI_image)); axis xy, axis image,  grid on;  colormap(jet);
caxis([tol, 0]);
xlabel('Crossrange (m)'); ylabel('Downrange (m)'); 
fig = gcf;
print(savefilename, '-jpg', '-r600');

