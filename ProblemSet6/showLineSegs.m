figure(1); clf; imshow(im); hold on; zoom off;
% Change seg1, seg2, seg3 to the variables holding your mutually
% orthogonal segments
%drawseg2(seg1, [1 0 0]);
%drawseg2(seg2, [0 1 0]);
%drawseg2(seg3, [0 0 1]);

drawseg(seg1, 1, 1, [1 0 0]);
drawseg(seg2, 1, 1, [0 1 0]);
drawseg(seg3, 1, 1, [0 0 1]);
