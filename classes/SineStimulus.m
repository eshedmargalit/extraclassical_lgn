classdef SineStimulus < Stimulus
	properties
		freq
		deg
	end

	properties (Access = private)
		images
	end

	methods
		function obj = SineStimulus(freq, deg, amp, xc, yc, diam, xrng, yrng, time)
			% Call parent constructor
			obj@Stimulus(xc,yc,diam,xrng,yrng);

			% Set own fields
			obj.freq = freq;
			obj.deg = deg;

			% Compute grating and populate 'stim' field
			for t = 1:numel(time)
				wave = SineStimulus.genwave(freq,deg,amp,t,xc,yc,diam,xrng,yrng);
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
		function wave = genwave(freq,deg,amp,phase,xc,yc,diam,xrng,yrng)
			[xgrid, ygrid] = meshgrid(xrng,yrng);
			rad = diam / 2;

			theta = (deg/360) * 2 * pi;
			xx = xgrid * cos(theta);
			yy = ygrid * sin(theta);
			xxyy = xx + yy;
			wavex = xxyy * 2 * pi * freq;
			wave = sin(wavex + phase);
		end
	end	
end
