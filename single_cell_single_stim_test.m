time = linspace(1,5,50);
rng = linspace(-10,10,500);

rf_params = [];
rgc1 = RGC(1,1,rf_params,rng,rng,[]);

diam = 6;
s = SineStimulus(0.2,45,1,1,1,diam,rng,rng,time);

frs = zeros(numel(time),1);
figure('units','normalized','outerposition',[0 0 1 1])

for t = 1:numel(time)
	stim = s.get_stim_at_time(t);
	rf = rgc1.get_rf();
	frs(t) = rgc1.respond_to_stimulus(s.get_stim_at_time(t));

	subplot(1,2,1);
	plot(frs);

	subplot(1,2,2);
	imshow(stim);
	drawnow;
end

freqs = fft(frs);
plot(abs(freqs));
