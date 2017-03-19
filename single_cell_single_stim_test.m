total_time = 5; %s
time_step = .01; %s
time_vec = time_step:time_step:total_time;
N = numel(time_vec);
temporal_frequency = 10; %Hz

rng = linspace(-10,10,500);
rf_params = [];
diam = 4;

%% Create stimulus and cell
s = SineStimulus(0.2,temporal_frequency,45,1,1,1,diam,rng,rng,time_vec);
rgc1 = RGC(1,1,rf_params,rng,rng,2000);

frs = zeros(N,1);
figure('units','normalized','outerposition',[0 0 1 1])

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
	imshow(stim);
	drawnow;
end

freqs = fft(frs);
absfreqs = abs(freqs);
spectrum = absfreqs./numel(absfreqs);
spectrum = spectrum(1:numel(spectrum)/2+1);

freq = linspace(0,N/total_time,N);
freq = freq(1:numel(freq)/2+1);
figure;
plot(freq,spectrum);
xlabel('Frequency');
ylabel('Power');
[~,idx] = max(spectrum(2:end));
f1 = freq(idx);
disp(f1);
