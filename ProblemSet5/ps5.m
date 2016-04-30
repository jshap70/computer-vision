image1 = imread('myers2.ppm');
image2 = imread('myers3.ppm');
load('correspondences.mat');

%[input_points, base_points] = cpselect(image1, image2, input_points, base_points, 'Wait', true);

%showPoints(image1, image2, input_points', base_points');

%save('correspondences.mat', 'input_points', 'base_points');
ps1 = [input_points'; ones(1, size(input_points, 1))];
ps2 = [base_points'; ones(1, size(base_points, 1))];

% build normalization matrices
T1n = normalizePoints(ps1);
T2n = normalizePoints(ps2);

ps1n = T1n * ps1;
ps2n = T2n * ps2;

% Build A
A = buildFcoef(ps1n, ps2n);
% Find Fn
[~, ~, v] = svd(A);
Fn = reshape(v(:,9), 3, 3)';
[u, d, v] = svd(Fn);
d(3,3) = 0;
Fn = u*d*v';
F = T1n' * Fn * T2n;

% Verify that xFx' is close to 0
[~,numpoints] = size(ps2);
for i = 1:numpoints
    if (abs(ps1(:,i)' * F * ps2(:,i)) > .005) 
        disp('bad F value')
    end
end

% construct K
fl = 1584;
pP = [593, 380]';
K = [fl, 0, pP(1);
     0, fl, pP(2);
     0,  0, 1];

% get E
Ep = K' * F * K;
[u, d, v] = svd(Ep);
dcrossAvg = (d(1,1) + d(2,2)) / 2;
d(1,1) = dcrossAvg;
d(2,2) = dcrossAvg;
d(3,3) = 0;
E = u*d*v';
if (E(3,3) < 0) 
    E = E * -1;
end

W = [0 -1 0; 1 0 0; 0 0 1];

R1 = u*W*v';
R2 = u*W'*v';
T1 = u(:,3);
T2 = -u(:,3);

P2 = K*[eye(3) zeros(3,1)];

% leaving out K so I can pull out R and T inside findp
P1full(:,:,1) = [R1, T1];
P1full(:,:,2) = [R1, T2];
P1full(:,:,3) = [R2, T1];
P1full(:,:,4) = [R2, T2];

if (P1full(3,3,1) < 0)
    disp('p1_1 was negative')
    P1full(:,:,1) = P1full(:,:,1) * -1;
end

if (P1full(3,3,2) < 0)
    disp('p1_2 was negative')
    P1full(:,:,2) = P1full(:,:,2) * -1;
end

if (P1full(3,3,3) < 0)
    disp('p1_3 was negative')
    P1full(:,:,3) = P1full(:,:,3) * -1;
end

if (P1full(3,3,4) < 0)
    disp('p1_4 was negative')
    P1full(:,:,4) = P1full(:,:,4) * -1;
end


[P1, X] = findp(P1full, P2, ps1, ps2, K);
%save('structure.mat', 'P1', 'P2', 'X');

% LOOK INSIDE finding_more_points.m to find how I got these extra points

load('points_picked_by_hand.mat')
X = [ X, moreX ];
figure(3);
plotPoints(X);
figure(1);
showPoints(image1, image2, impoints1, impoints2);

polys = {};
polys{1} = [3, 27, 28, 14];
polys{2} = [14, 13, 17, 3];
polys{3} = [1, 2, 13, 29];
polys{4} = [1, 29, 38, 4];
polys{5} = [38, 39, 5, 4];
polys{6} = [6, 5, 39, 40];

makeWireframe('myersWire.wrl', X, polys, [0 0 1 3.14], 1)
makeUntexturedModel('myersUntex.wrl', X, polys, [0 0 1 3.14], 1)

world = vrworld('myersUntex.wrl');
open(world);
view(world);








































































































































