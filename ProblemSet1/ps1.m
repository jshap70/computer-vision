
function ps1(image1Name, image2Name) 

IMG1 = image1Name;
IMG2 = image2Name;

if (strcmp(IMG1, IMG2))
   return
end

if ((strcmp(IMG1, 'left.ppm') && strcmp(IMG2, 'right.ppm')) || (strcmp(IMG2, 'left.ppm') && strcmp(IMG1, 'right.ppm')))
    BLENGTH = 24; % inches
else 
    BLENGTH = 12; % inches
end

WIDTH = 640; % pixels
FOV = 33.25; % degrees

anglePerPixel = FOV / WIDTH;
imgCenter = WIDTH / 2;

l = imread(IMG1);
m = imread(IMG2);

imshow(l);
pl = ginput(1);
% offset angle from the center of the image
al = (pl(1) - imgCenter) * anglePerPixel; % degrees

imshow(m);
pm = ginput(1);
% offset angle from the center of the image
am = (pm(1) - imgCenter) * anglePerPixel; % degrees

% rearange so they're in the right order
if am > al
    temp = al;
    al = am;
    am = temp;
end

close all

% angles of the triangle
a1 = 90 + abs(al);
a2 = 90 - abs(am);

% the angle on the far inside of the obtuse triangle
farInsideAng = 180 - a1 - a2;

% complement of a1 on the bottom right of the acute triangle
a1comp = 180 - a1;

% 2nd part of the angle that is composed of this and farInsideAng
farOutsideAng = 180 - 90 - a1comp;
farAng = farInsideAng + farOutsideAng;

% distance of horizontal covered per degree in the far angle
distancePerDegree = BLENGTH / farInsideAng; % inches

% far side from the far angle (so the close side that B is on)
bottomLength = farAng * distancePerDegree;

tangent = tand(a2);

% result
distance = tangent * bottomLength;
disp(strcat(num2str(distance / 12), ' feet')) % show in feet so it makes sense

return

