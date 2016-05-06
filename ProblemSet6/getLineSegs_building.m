% Read the sample image in
im = imread('building.gif');
    
% just use the red channel
im = im(:,:,1);
    
% Find edges using the Canny operator with hysteresis thresholds of 0.1
% and 0.25 with smoothing parameter sigma set to 1.
edgeim = edge(im,'canny', [0.1 0.2], 1.5);

%figure(1), imshow(edgeim); truesize(1)
    
% Link edge pixels together into lists of sequential edge points, one
% list for each edge contour.  Discard contours less than 10 pixels long.
[edgelist, labelededgeim] = edgelink(edgeim, 30);
    
% Display the labeled edge image with separate colours for each
% distinct edge (choose your favorite colourmap!)
%figure(2), imagesc(labelededgeim); colormap(vga), 
%axis image, axis off, truesize(2)
    
% Fit line segments to the edgelists with the following parameters:
tol = 2;         % Line segments are fitted with maximum deviation from
		 % original edge of 2 pixels.
angtol = 0.01;  % Segments differing in angle by less than 0.05 radians
linkrad = 2;     % and end points within 2 pixels will be merged.
[seglist, nedgelist] = lineseg(edgelist, tol, angtol, linkrad);

% Draw the fitted line segments stored in seglist in figure window 3 with
% a linewidth of 2
figure(3); clf; imshow(im); hold on; zoom off;
drawseg(seglist);
