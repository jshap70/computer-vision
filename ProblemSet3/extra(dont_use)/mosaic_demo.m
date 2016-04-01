% This command requires matlab 2007 or newer
[p1 p2] = cpselect(i1, i2, input_points, base_points, 'Wait', true);
% cpselect(i1, i2, input_points, base_points);
% should work on older versions, but will not wait to execute the
% rest of the script

% Make a resampler for transforming images
R = makeresampler({'linear','linear'},'bound');
% Create a Tform that maps input to base
T1 = cp2tform(p1,p2,'projective');
% Create an identity Tform
T2 = maketform('projective',eye(3));

% Transform both images and record the max and min, x and y coordinates
[i1t, x1, y1] = imtransform(i1, T1);
[i2t, x2, y2] = imtransform(i2, T2);

% Combine the x and y coordinates
x = [ x1; x2];
y = [ y1; y2];
% Find the max of the maxs and the min of the mins
xdata = [min(x(:,1)) max(x(:,2))];
ydata = [min(y(:,1)) max(y(:,2))];

% Transform both images specifying the x and y ranges
i1t = imtransform(i1, T1, R, 'XData', xdata, 'YData', ydata);
i2t = imtransform(i2, T2, R, 'XData', xdata, 'YData', ydata);

% Combine the 2 images
%comb = imlincomb(0.5, i1t, 0.5, i2t);
%comb = 0.5*i1t+0.5*i2t;
comb = cell(1, 2);
comb{1} = i1t;
comb{2} = i2t;
comb = combineImages(comb);

imshow(comb);

% combineImages can be used to get rid of the changes in brightness
