close all
clear all
clc

diams = 0.5:1:10;
for i = 1:numel(diams)
	if mod(i,5) == 0
		disp(i);
	end
	[f1_amps(i), mns(i)] = single_cell_single_stim_test(diams(i),0.18);
end

plot(diams,f1_amps);
