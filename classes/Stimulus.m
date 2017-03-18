classdef Stimulus
	properties
		x
		y
		diameter
		mask
	end
	methods
		function stim = Stimulus(x,y,diam,xrng,yrng)
			stim.x = x;
			stim.y = y;
			stim.diameter = diam;
			[xx, yy] = meshgrid(xrng, yrng);
			stim.mask = (xx - x).^2 + (yy - y).^2 <= (diam/2).^2;
		end
	end
end
