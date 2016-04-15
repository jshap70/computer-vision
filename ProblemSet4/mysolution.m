image1 = imread('myers2.ppm');
image2 = imread('myers3.ppm');

% imshow(image1);
% imshow(image2);

load('correspondences.mat');

[input_points, base_points] = cpselect(image1, image2, input_points, base_points, 'Wait', true);

% save('correspondences.mat', 'input_points', 'base_points');

showPoints(image1, image2, input_points', base_points');

ps1 = [input_points'; ones(1, size(input_points, 1))];
ps2 = [base_points'; ones(1, size(base_points, 1))];

% build normalization matrices
T1n = normalizePoints(ps1);
T2n = normalizePoints(ps2);

ps1n = T1n * ps1;
ps2n = T2n * ps2;

% save('normalizationMatrices.mat', 'T1n', 'T2n')

% Build A
A = buildFcoef(ps1n, ps2n);

% Find Fn
[~, ~, v] = svd(A);
Fn = reshape(v(:,9), 3, 3)';
[u, d, v] = svd(Fn);
d(3,3) = 0;
Fn = u*d*v';

if (det(Fn) ~= 0)
    % is not equals really ~= instead of !=? that's horrible...
    % this is the thing with floating point roundoff that's messing up
    
    disp('determinant of Fn is non-zero')
end
%save('FnormCorrected.mat', 'Fn')

F = T1n' * Fn * T2n;

% Verify that xFx' is close to 0
[~,numpoints] = size(ps2);
for i = 1:numpoints
    if (abs(ps1(:,i)' * F * ps2(:,i)) > .005) 
        disp('bad F value')
    end
end
%save('Fmatrix.mat', 'F')


% draw epipolar line on figure
figure(1);
ax1 = axis;

% input point 1
figure(2);
ax2 = axis;
pr = ginput(1);
plot(pr(1), pr(2), 'ro', 'LineWidth', 2);

prn = [pr'; 1];
linel = (prn' * F)';
figure(1);
drawLine(linel, ax1);

% input point 2

pl = ginput(1);
plot(pl(1), pl(2), 'ro', 'LineWidth', 2);

pln = [pl'; 1];
liner = (F * pln);
figure(2);
drawLine(liner, ax2);

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

%save('Ematrix.mat', 'E');

W = [0 -1 0; 1 0 0; 0 0 1];

R1 = u*W*v';
R2 = u*W'*v';

T1 = u(:,3);
T2 = -u(:,3);

% save('RandTmatrices.mat', 'R1', 'R2', 'T1', 'T2');

P2 = K*[eye(3) zeros(3,1)];

P1pos1 = [R1, T1];
P1pos2 = [R1, T2];
P1pos3 = [R2, T1];
P1pos4 = [R2, T2];

% save('Ppossibilities.mat', 'P2', 'P1pos1', 'P1pos2', 'P1pos3', 'P1pos4');

% (I tried to set up a 3D matrix with the P1 canidates on the z axis 
% so I could cycle through them but I failed, lol)
% 
% also turns out I don't think I need this
% 
% R = 0;
% T = 0;
% P = 0;
% use = 1;
% 
% for i = 1:numpoints
%     if (ps1(:,i)'
%     
% end















