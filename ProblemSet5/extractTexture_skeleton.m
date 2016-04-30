% Calculate the plane formed by the 3D vertices of the polygon using
% X'*pi = 0.  Let A be a matrix built using several points.


% *** Fill in your code *** A =
[U D V] = svd(A);
plane = V(:,4);


% (Optional) Use the image that is closest to being fronto-parallel
% Use the magnitude of the dot product between plane's normal and the
% camera's optical axis to decide.  The largest magnitude (reguardless
% of sign) is closest to fronto-parallel.

% *** Fill in your code *** 

  
% (Probably optional) The polygon should be facing the camera

% *** Fill in your code ***


% Calculate a rotation matrix which will align the polygon normal with
% the optical axis of the camera.  We choose the new x axis so that it
% is perpendicular to the new z and old y axes.  The new y axis is
% chosen to be perpendicular to the new x and z axes.

% *** Fill in your code *** z =
% *** Fill in your code *** x =
% *** Fill in your code *** y =
% *** Fill in your code *** S = 


% Construct homography that will rectify image.  Be sure to take into
% account the rotation of the camera (R) and the camera calibration
% (K) in a manner similar to that of problem set 3.

% *** Fill in your code *** H =


% Calculate the new texture coordinates by applying H to the image
% coordinates (in the appropriate image) of the vertices of the
% polygon

% *** Fill in your code *** tch = 


% Find the minimum and maximum coordinates of the polygon we're after
tcmin = min(tch');
tcmax = max(tch');


% Transform just the region of the image we're after
T = maketform('projective', H');
texture = imtransform(image, T, 'XData', [tcmin(1,1) tcmax(1,1)], ...
		      'YData', [tcmin(1,2) tcmax(1,2)]);


% Get the size of the resulting image
[height width depth] = size(texture);


% Adjust the texture coordinates so they range from 0 to 1 with the
% origin in the bottom left of the image.

% *** Fill in your code *** tch = 


% Convert the texture coordinates back to non-homgeneous coordinates

% *** Fill in your code *** tc =
