clear all;
diams = [1 2 3 4 5 6 7 8 10 15 20]; 

for i = 1:numel(diams)
	spk(i) = area_summation(diams(i));
	fprintf('Diameter: %.3f\nSpikes: %.3f\n\n',diams(i),spk(i));
end

figure;
size(diams)
size(spk)
plot(diams,spk);
