clear all; clc;
%%
addpath('..\Test_Data');
addpath('..\Focusing_Delay');
%--------------------------------------------------------------------------
%% Training Data
load Train_Data_SD100_120_180_200;
rng default;
%%
X            = normalize_atoms(X);
%%
lambda       = 1e-6;
beta         = 1e-6;
gamma        = 1e-1;
num          = 50;
No_ns        = 137;
n            = size(X_hat,1);
Ds           = conj(dftmtx(n)) / sqrt(n);
[P1, V1, W1] = Wall_Removal_AEwLRJS(X, X_hat, Ds, lambda, beta, gamma, No_ns, num, 0);
%%
% savefilename = 'Image_PAE_3D';
% load TEST_DATA_SINGLE_WALL_SD150CM_ANT_HEIGHT_900CM_1T2DOBJS_TARGETS_14082019.mat;
% load TARGET_MASK_3O.mat
savefilename = 'Image_PAE_2D';
load TEST_DATA_SINGLE_WALL_SD150CM_ANT_HEIGHT_900CM_2DOBJS_TARGETS_14082019.mat;
load TARGET_MASK_2O.mat

Target_scene        = TWI.Received_Data{1};
[Target_scene, TWI] = data_alignment(TWI, Target_scene, 2);
%
Target_scene1       = normalize_atoms(Target_scene);
X_hat_AELR          = V1 * sig_func(W1 * (Target_scene1 - P1 * Target_scene1)); 
%

tol               = -30;
TWI.TOA_method    = 1;
TWI.Z             = 4.5;
TWI.Zoff          = 1.5;
TWI.No_R_px       = 100;
TWI.No_C_px       = 100;
scene             = Scene_Design(TWI);     
X_axis            = scene{1}(1,:);
Z_axis            = scene{2}(:,1);   


TWI.Received_Data   = X_hat_AELR;
S                   = DS_Beamforming_2D(TWI, TWI.Received_Data, scene);
TWI_image           = abs(reshape(S, size(scene{1})));

T_1        = (TWI_image .*  Target_Mask);
C_1        = (TWI_image .*  Clutter_Mask);
T_1        = sum(T_1(:))/sum(Target_Mask(:));
C_1        = sum(C_1(:))/sum(Clutter_Mask(:));
Result_PAE = 20*log10(T_1 / (eps + C_1))  

% Defaults for this blog post
width  = 2;      % Width in inches
height = 2;      % Height in inches
alw    = 0.75;   % AxesLineWidth
fsz    = 8;     % Fontsize
lw     = 2;      % LineWidth
msz    = 9;      % MarkerSize
%
% The new defaults will not take effect if there are any open figures. To
% use them, we close all figures, and then repeat the first example.
close all;
%
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
print(savefilename, '-depsc', '-r600');

