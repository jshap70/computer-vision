% Load an image of a tile floor with perspective distortion
img = imread('moench_tile_small.ppm');

% Display the image
figure(1);
imshow(img);

% Select the 4 corners of a piece of tile (either clockwise or
% counterclockwise

% UNCOMMENT TO CHOOSE NEW ONES! but the ones in points.mat work really well
% points = ginput(4);

% PART 1
% Map the points to a 200 pixel square
pointmap = [ 0 0; 
             0 25; 
             25 25; 
             25 0 ];

%p1 = points(1,:);
%p2 = points(2,:);
%p3 = points(3,:);
%p4 = points(4,:);

A = [];

for i = 1:4
    A = [A ; 
        points(i,1) points(i,2) 1 0 0 0 (-pointmap(i,1) * points(i,1)) (-pointmap(i,1) * points(i,2)) (-pointmap(i,1));
        0 0 0 points(i,1) points(i,2) 1 (-pointmap(i,2) * points(i,1)) (-pointmap(i,2) * points(i,2)) (-pointmap(i,2));];
end;

h1 = null(A);
H1 = [ h1(1) h1(2) h1(3);
       h1(4) h1(5) h1(6);
       h1(7) h1(8) h1(9) ];

% Create a matlab Tform
T1 = maketform('projective', H1');

% Apply the Tform to the image
it1 = imtransform(img, T1);

% Display the transformed image
figure(2);
imshow(it1);

% PART 2
% l1 || l2, l3 || l4, l1 perp l3 (eventually)
p1 = [points(1,:) 1];
p2 = [points(2,:) 1];
p3 = [points(3,:) 1];
p4 = [points(4,:) 1];

% l1 || l2, l3 || l4, l1 perp l3
l1 = cross(p1, p2);
l2 = cross(p3, p4);
l3 = cross(p3, p2);
l4 = cross(p1, p4);

% points of intersection 
infP1 = cross(l1, l2);
infP2 = cross(l3, l4);
% line at infinity
linf = cross(infP1, infP2);

H2 = [1 0 0; 0 1 0; linf(1)/linf(3) linf(2)/linf(3) 1];

T2 = maketform('projective', H2');

% Apply the Tform to the image
it2 = imtransform(img, T2);
figure(3);
imshow(it2);

% PART 3
% in answers.txt

% PART 4
% I'm unsure how I'm supposed to compute the cross ratio out of the 4
% points if these 4 points are not co-linear. 




