classdef SineStimulus < Stimulus
	properties
		spatial_freq
		temporal_freq
		deg
	end

	properties (Access = private)
		images
	end

	methods
		function obj = SineStimulus(spatial_freq, temporal_freq, deg, amp, xc, yc, diam, xrng, yrng, time_vec);
			% Call parent constructor
			obj@Stimulus(xc,yc,diam,xrng,yrng);

			% Set own fields
			obj.spatial_freq = spatial_freq;
			obj.temporal_freq = temporal_freq;
			obj.deg = deg;

			% Compute grating and populate 'stim' field
			total_time = time_vec(end);
			n_cycles = total_time * temporal_freq;
			numel(time_vec);
			ticks_per_cycle = numel(time_vec) / n_cycles;

			for t = 1:numel(time_vec)
				phase = (2 * pi) / (ticks_per_cycle / t);
				wave = SineStimulus.genwave(spatial_freq,deg,amp,phase,xc,yc,diam,xrng,yrng);
				masked_wave = obj.mask .* wave;
				masked_wave(~obj.mask) = 0.5;
				obj.images(:,:,t) = masked_wave; 
			end
		end

		function image = get_stim_at_time(stim,t)
			image = stim.images(:,:,t);
		end
	end

	methods (Static)
		function wave = genwave(spatial_freq,deg,amp,phase,xc,yc,diam,xrng,yrng)
			[xgrid, ygrid] = meshgrid(xrng,yrng);
			rad = diam / 2;

			theta = (deg/360) * 2 * pi;
			xx = xgrid * cos(theta);
			yy = ygrid * sin(theta);
			xxyy = xx + yy;
			wavex = xxyy * 2 * pi * spatial_freq;
			wave = sin(wavex + phase);
		end
	end	
end
