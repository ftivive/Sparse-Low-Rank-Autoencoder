function TWI_image = ds_2dbeamforming(TWI, Rx_Signal)

scene = scene_design(TWI);
%**************************************************************************
% PERFORM SYNTHETIC FOCUSING IN THE FREQUENCY DOMAIN USING A PHASE DELAY
% CORRESPONDING TO THAT FREQUENCY.
%**************************************************************************
% Calcuate the phase delay for the entire scene w.r.t the transceiver.
No_pixels = numel(scene{1});
TWI_image = zeros(1, No_pixels);
for n = 1:TWI.num_receiver
    T  = transceiver_focusdelay(TWI, scene{1}, scene{2}, TWI.R_dist{n});                    
    TWI_image = TWI_image + ((Rx_Signal(:,n)).' * exp(2 * 1i * pi * TWI.Freqs(:) * T(:).')); 
end
TWI_image = TWI_image / (TWI.num_receiver * length(TWI.Freqs));
dims      = size(T); 
TWI_image = reshape(TWI_image, [dims(1), dims(2)]);