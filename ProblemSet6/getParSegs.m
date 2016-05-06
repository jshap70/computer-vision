function [ parSet1,parSet2,parSet3 ] = getParSegs( image )

im = image(:,:,1);
edgeim = edge(im,'canny', [0.1 0.2], 1.5);
[edgelist, labelededgeim] = edgelink(edgeim, 30);

% Fit line segments to the edgelists with the following parameters:
tol = 2;         % Line segments are fitted with maximum deviation from
		 % original edge of 2 pixels.
angtol = 0.01;  % Segments differing in angle by less than 0.05 radians
linkrad = 2;     % and end points within 2 pixels will be merged.
[seglist, nedgelist] = lineseg(edgelist, tol, angtol, linkrad);

% Draw the fitted line segments stored in seglist in figure window 3 with
% a linewidth of 2
%figure(3); clf; imshow(im); hold on; zoom off;
%drawseg(seglist);
parSet1 = selectseg2(im, seglist);
pause(0.5)
parSet2 = selectseg2(im, seglist);
pause(0.5)
parSet3 = selectseg2(im, seglist);
pause(0.5)
close

end