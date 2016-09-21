% screen resolution
H = 768;
W = 1366;

% manually find some parameters to fit to screen
h = int32(H * 0.7);
w = int32(W * 0.7);
interval = 1; %sec
circle_diameter = h * 0.5 * 0.75;
square_halfedge = h * 0.5 * 0.75;
square_edge = square_halfedge * 2;

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
[x y] = meshgrid(1:w, 1:h);
circle = (x - w * 0.5) .* (x - w * 0.5) + (y - h * 0.5) .* (y - h * 0.5);
circle = circle < circle_diameter * circle_diameter;

squarex = abs(x - w * 0.5) < square_halfedge;
squarey = abs(y - h * 0.5) < square_halfedge;
square = squarex & squarey;

clear shapes
shapes(:, :, 1) = circle;
shapes(:, :, 2) = square;
shapes(:, :, 3) = zeros(h, w);
tags = {'deviant'; 'standard'};

figure(1)
imshow(shapes(:, :, end));

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