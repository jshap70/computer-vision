image1 = imread('myers2.ppm');

%[ parSet1,parSet2,parSet3 ] = getParSegs(image1);
%save('segments.mat', 'parSet1', 'parSet2', 'parSet3')
load('segments.mat')

%figure(1); clf; imshow(image1); hold on; zoom off;
%drawseg(parSet1(1,:), 1, 2, [1 0 0]);
%drawseg(parSet1(2,:), 1, 2, [1 0 0]);
%drawseg(parSet1(3,:), 1, 2, [1 0 0]);
%drawseg(parSet2(1,:), 1, 2, [0 1 0]);
%drawseg(parSet2(2,:), 1, 2, [0 1 0]);
%drawseg(parSet2(3,:), 1, 2, [0 1 0]);
%drawseg(parSet3(1,:), 1, 2, [0 0 1]);
%drawseg(parSet3(2,:), 1, 2, [0 0 1]);
%drawseg(parSet3(3,:), 1, 2, [0 0 1]);

segsfull(:,:,1) = parSet1;
segsfull(:,:,2) = parSet2;
segsfull(:,:,3) = parSet3;
vanish = [];

for i = 1:3
    tempsegs = segsfull(:,:,i);
    A = [];
    for j = 1:3
        %x1 = tempsegs(j,1);
        %y1 = tempsegs(j,2);
        %x2 = tempsegs(j,3);
        %y2 = tempsegs(j,4);
        p1 = [tempsegs(j,1),tempsegs(j,2)];
        p2 = [tempsegs(j,3),tempsegs(j,4)];
        
        A(j,:) = cross([p1,1]',[p2,1]);
    end
    [u, d, v] = svd(A);
    vanish(:,:,i) = v(:,3)';
end
vanish1 = vanish(:,:,1);
vanish2 = vanish(:,:,2);
vanish3 = vanish(:,:,3);
%save('vanishing.mat', 'vanish1','vanish2','vanish3')








