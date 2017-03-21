close all
clear all
clc

sfs = 0.1:.01:.3;
for i = 1:numel(sfs)
	if mod(i,5) == 0
		disp(i);
	end
	[f1_amps(i), mns(i)] = single_cell_single_stim_test(50,sfs(i));
end

plot(sfs,f1_amps);
