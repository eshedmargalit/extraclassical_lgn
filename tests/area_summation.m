function mn_spike_count = area_summation(diam)
	%% VARIABLE INIT
	total_time = 1; %s
	time_step = .005; %s
	time_vec = time_step:time_step:total_time;
	N = numel(time_vec);

	rng = linspace(-10,10,500);
	rf_params = [];

	%% Create stimulus and cell
	spatial_frequency = 0.18;
	temporal_frequency = 4; %Hz
	angle = 45;
	amplitude = 1;
	basal_fr = 5;

	%% CELL POPULATION INIT
	n_cells = 9;
	xs = [-2 -2 -2 0 0 0 2 2 2];
	ys = [-2 0 -2 -2 0 2 -2 0 2];

	for i=1:n_cells
		RGCs{i} = RGC(xs(i),ys(i),[],rng,rng,basal_fr,1);
	end

	x_center = 0;
	y_center = 0;

	frs = zeros(n_cells,N);

	%% RUN THE EXP
	m_seq = SineStimulus(spatial_frequency,temporal_frequency,angle,amplitude,x_center,y_center,diam,rng,rng,time_vec);
	for cell_idx = 1:n_cells
		for t = 1:N
			stim = m_seq.get_stim_at_time(t);
			frs(cell_idx,t) = RGCs{cell_idx}.respond_to_stimulus(stim);
		end
	end

	for cell = 1:n_cells
		[spikes, spike_times] = RGC.poisson_generator(frs(cell,:),time_step);
		%myfft(spikes,N,total_time);
		%subplot(n_cells,1,cell)
		n_spikes = numel(spike_times);
		spike_counts(cell) = n_spikes;
		%plot(spikes);
	end

	mn_spike_count = max(spike_counts);
end
