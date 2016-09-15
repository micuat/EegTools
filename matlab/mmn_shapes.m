% parameters
h = 160;
w = 160;
interval = 1; %sec

% LSL
% instantiate the library
disp('Loading library...');
lib = lsl_loadlib();

% make a new stream outlet
disp('Creating a new streaminfo...');
info = lsl_streaminfo(lib,'MatlabStimuli','Markers',1,1/interval,'cf_string','stimuliID');

disp('Opening an outlet...');
outlet = lsl_outlet(info);

% prepare shapes
x = ones(h, 1) * (1:w);
y = (1:h)' * ones(1, h);
circle = (x - w * 0.5) .* (x - w * 0.5) + (y - h * 0.5) .* (y - h * 0.5);
circle = circle > 40 * 40;

square = (x > 40) & (x < 120) & (y > 40) & (y < 120);
square = ~square;

clear shapes
shapes(:, :, 1) = circle + 0.5;
shapes(:, :, 2) = square + 0.5;
shapes(:, :, 3) = ones(h, w);
tags = cellstr(['circle'; 'square']);
%tags = [0, 1];

figure(1)

while waitforbuttonpress ~= 1
end

for i = 1:100
    disp(i);
    index = (rand > 0.2) + 1;
    outlet.push_sample(tags(index));
    imshow(shapes(:, :, index));
    pause(0.1 * interval);
    imshow(shapes(:, :, end));
    pause(0.9 * interval);
end