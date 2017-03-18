% Add object classes to path
pathdirs = {'classes'};

for i = 1:numel(pathdirs)
	addpath(genpath(pathdirs{i}));
end
