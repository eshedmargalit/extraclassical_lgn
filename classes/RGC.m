classdef RGC
	
	% private properties
	properties (Access = private)
		x
		y
		rf_params
		rf_2d
		basal_fr
	end
	methods
		% constructor
		function cell = RGC(x,y,rf_params,xrng,yrng,basal_fr)
		
			if isempty(rf_params)
				rf_params = [9 1 1.5 2];
			end

			if isempty(basal_fr)
				basal_fr = 20; %Hz
			end

			cell.x = x;
			cell.y = y;
			cell.rf_params = rf_params;
			cell.basal_fr = basal_fr;

			cell.rf_2d = RGC.compute_rf(rf_params, xrng, yrng, x, y);
		end

		% Getter functions
		function pos = get_position(cell)
			pos.x = cell.x;
			pos.y = cell.y;
		end

		function rf = get_rf(cell)
			rf = cell.rf_2d;
		end

		% Other functions
		function fr = respond_to_stimulus(cell, stim)
			fr = 1000*sum(sum(cell.rf_2d .* stim))/prod(size(cell.rf_2d)) + cell.basal_fr;
			fr = fr + randn(1,1) * fr * .1;
		end
	end

	% static methods belong to the RGC class, but not to any individual instance. Thus, they should be callable in the constructor.
	methods (Static)
		function rf = compute_rf(params, xrng, yrng, xc, yc)
		% params - [amp1 rad1 amp2 rad2]
		% xrng - values over which to compute rf 
		% yrng - see above
		% xc, yc, center points
			[x, y] = meshgrid(xrng,yrng);

			exp1 = ((x-xc).^2 + (y-yc).^2)./(2*params(2)^2);
			amp1 = params(1) * (1 / (2 * sqrt(2*pi)));
			g1 = amp1  * exp(-exp1);

			exp2 = ((x-xc).^2 + (y-yc).^2)./(2*params(3)^2);
			amp2 = params(4) * (2 / (2 * sqrt(2*pi)));
			g2 = amp2  * exp(-exp2);

			rf = g1 - g2;
		end

		function [spike_vec, spike_times] = poisson_generator(frs, dt)
			expected_per_step = frs .* dt;
			n_steps = numel(frs);

			spike_vec = zeros(n_steps,1);
			for step = 1:n_steps
				thresh = randn(1,1);
				if expected_per_step(step) > thresh
					spike_vec(step) = 1;
				end
			end

			spike_times = find(spike_vec==1);
			
		end
	end
end
