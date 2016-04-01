% KEEP THESE COMMENTED
%i1 = imread('root_quadrangle01.ppm');
%i2 = imread('root_quadrangle02.ppm');
%i3 = imread('root_quadrangle03.ppm');
%i4 = imread('root_quadrangle04.ppm');
%pointset1 = [0, 0];
%pointset2 = [0, 0];
%pointset3 = [0, 0];
%pointset4 = [0, 0];
%pointset5 = [0, 0];
%pointset6 = [0, 0];

load points.mat

% This command requires matlab 2007 or newer
[pointset1, pointset2] = cpselect(i1, i2, pointset1, pointset2, 'Wait', true);
[pointset3, pointset4] = cpselect(i2, i3, pointset3, pointset4, 'Wait', true);
[pointset5, pointset6] = cpselect(i3, i4, pointset5, pointset6, 'Wait', true);

% Make a resampler for transforming images
R = makeresampler({'linear','linear'},'bound');

% Create a Tform that maps input to base
T1to2 = cp2tform(pointset1,pointset2,'projective');
T2to3 = cp2tform(pointset3,pointset4,'projective');
T4to3 = cp2tform(pointset6,pointset5,'projective');
% Create an identity Tform
T3to3 = maketform('projective',eye(3));

% Combine transform T1to2 and T1to3 to map image 1 to image 3
T1to3 = maketform('projective', T1to2.tdata.T * T2to3.tdata.T);

% Transform both images and record the max and min, x and y coordinates
[~, x1, y1] = imtransform(i1, T1to3);
[~, x2, y2] = imtransform(i2, T2to3);
[~, x3, y3] = imtransform(i3, T3to3);
[~, x4, y4] = imtransform(i4, T4to3);

% Combine the x and y coordinates
x = [ x1; x2; x3; x4];
y = [ y1; y2; y3; y4];

% Find the max of the maxs and the min of the mins
xdata = [min(x(:,1)) max(x(:,2))];
ydata = [min(y(:,1)) max(y(:,2))];

% adjust so that they are all lined up in the correct positions
i1t = imtransform(i1, T1to3, R, 'XData', xdata, 'YData', ydata);
i2t = imtransform(i2, T2to3, R, 'XData', xdata, 'YData', ydata);
i3t = imtransform(i3, T3to3, R, 'XData', xdata, 'YData', ydata);
i4t = imtransform(i4, T4to3, R, 'XData', xdata, 'YData', ydata);

comb = cell(1, 4);
comb{1} = i1t;
comb{2} = i2t;
comb{3} = i3t;
comb{4} = i4t;

comb = combineImages(comb);

imshow(comb);
imwrite(comb,'mosaic out.ppm');

