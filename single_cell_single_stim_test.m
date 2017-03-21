function [f1_amp,mn_fr] = single_cell_single_stim_test(diam,sf)
	total_time = 2; %s
	time_step = .01; %s
	time_vec = time_step:time_step:total_time;
	N = numel(time_vec);
	temporal_frequency = 4; %Hz

	rng = linspace(-10,10,500);
	rf_params = [];

	%% Create stimulus and cell
	spatial_frequency = 0.18;
	angle = 45;
	amplitude = 1;
	x_center = 1;
	y_center = 1;
	s = SineStimulus(sf,temporal_frequency,angle,amplitude,x_center,y_center,diam,rng,rng,time_vec);
	basal_fr = 15;
	rgc1 = RGC(1,1,rf_params,rng,rng,15);
	%surf(rgc1.get_rf());
	%figure;
	%surf(s.get_stim_at_time(1));

	frs = zeros(N,1);
	%figure('units','normalized','outerposition',[0 0 1 1])
	%figure(1)

	for i = 1:N
		stim = s.get_stim_at_time(i);
		rf = rgc1.get_rf();
		frs(i) = rgc1.respond_to_stimulus(s.get_stim_at_time(i));

		subplot(1,2,1);
		plot(1:i,frs(1:i),'k.-');

		closest_int = ceil(time_vec(i));
		xticks((1:closest_int) .* 1/time_step);
		xticklabels(1:closest_int);
		xlim([0 N]);

		subplot(1,2,2);

		rfbin = abs(rgc1.get_rf()) > 0.2;
		stimbin = abs(stim) > 0.2;
		mush = rfbin + stimbin;

		colormap('gray');
		imagesc(stim);

		drawnow;
	end

	freqs = fft(frs);
	absfreqs = abs(freqs);
	spectrum = absfreqs./numel(absfreqs);
	spectrum = spectrum(1:numel(spectrum)/2+1);

	freq = linspace(0,N/total_time,N);
	freq = freq(1:numel(freq)/2+1);
	%figure;
	%plot(freq,spectrum);
	%xlabel('Frequency');
	%ylabel('Power');
	[f1_amp, idx] = max(spectrum(2:end));
	f1 = freq(idx);
	mn_fr = mean(frs);
end
