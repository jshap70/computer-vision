
% this is a record of how I recovered the extra 3D points for the model
% it's not really meant to be run
load('structure.mat')
image1 = imread('myers2.ppm');
image2 = imread('myers3.ppm');
load('correspondences.mat');

moreX = [];
impoints1 = input_points';
impoints2 = base_points';

% following points form the plane that that the corner by the door behind 
% the van in image 2 is on
% this point:
% figure(1)
% [x, y] = ginput(1)
% 
%x =
%
%  738.7904
%
%
%y =
%
%  552.1099

[~, ~, v] = svd([ X(:,29)'; X(:,24)'; X(:,36)'; X(:,37)']);
ground = v(:,4);
[~, ~, v] = svd([ X(:,10)'; X(:,30)'; X(:,35)'; X(:,33)'; X(:,31)']);
wallwithlight = v(:,4);
[~, ~, v] = svd([ X(:,34)'; X(:,30)'; X(:,25)'; X(:,35)']);
door = v(:,4);

[~, ~, v] = svd([ground'; wallwithlight'; door']);
newpoint1 = v(:,4) / v(4,4);
moreX = [ moreX, newpoint1 ];
im1point = P1*newpoint1;
im2point = P2*newpoint1;
impoints1 = [impoints1, im1point(1:2)/im1point(3)];
impoints2 = [impoints2, im2point(1:2)/im2point(3)];


% the point that is in the outward corner directly out from the previous
% point

% add the new pnt to our calc (though I'm not sure this matters, as it
% should just be on that exact plane already)
[~, ~, v] = svd([ X(:,29)'; X(:,24)'; X(:,36)'; X(:,37)'; newpoint1']);
ground = v(:,4);
[~, ~, v] = svd([ X(:,10)'; X(:,30)'; X(:,35)'; X(:,33)'; X(:,31)'; newpoint1']);
wallwithlight = v(:,4);
[~, ~, v] = svd([ X(:,31)'; X(:,8)'; X(:,5)'; X(:,6)'; X(:,7)'; X(:,32)']);
closewall = v(:,4);

[~, ~, v] = svd([ground'; wallwithlight'; closewall']);
newpoint2 = v(:,4) / v(4,4);
moreX = [ moreX, newpoint2 ];
im1point = P1*newpoint2;
im2point = P2*newpoint2;
impoints1 = [impoints1, im1point(1:2)/im1point(3)];
impoints2 = [impoints2, im2point(1:2)/im2point(3)];


% the point that is in the far right corner behind the blue pickup truck

[~, ~, v] = svd([ X(:,29)'; X(:,24)'; X(:,36)'; X(:,37)'; newpoint1']);
ground = v(:,4);
[~, ~, v] = svd([ X(:,31)'; X(:,8)'; X(:,5)'; X(:,6)'; X(:,7)'; X(:,32)'; newpoint2']);
closewall = v(:,4);

% IM A GENIOUS FOR FIGURING OUT I CAN MAKE A PLANE W/ THE CAMERA PINHOLE!
[~, ~, v] = svd([ X(:,6)'; X(:,7)'; X(:,32)'; zeros(1,4) ]);
hacks = v(:,4);

[~, ~, v] = svd([ground'; closewall'; hacks']);
newpoint3 = v(:,4) / v(4,4);
moreX = [ moreX, newpoint3 ];
im1point = P1*newpoint3;
im2point = P2*newpoint3;
impoints1 = [impoints1, im1point(1:2)/im1point(3)];
impoints2 = [impoints2, im2point(1:2)/im2point(3)];



% calculate and display new points with the old ones on the images
figure(1)
showPoints(image1, image2, impoints1, impoints2);
save('points_picked_by_hand.mat', 'moreX', 'impoints1', 'impoints2')



