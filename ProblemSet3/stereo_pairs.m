% load images
L = imread('left_converge.ppm');
R = imread('right_converge.ppm');

% load knowns
Kl = [1024, 0, 127.5; 0, 1024, 127.5; 0, 0, 1];
Kr = [1024, 0, 127.5; 0, 1024, 127.5; 0, 0, 1];

Rl = [2/sqrt(5), 0,  1/sqrt(5); 0, 1, 0;  1/sqrt(5), 0, -2/sqrt(5)];
Rr = [2/sqrt(5), 0, -1/sqrt(5); 0, 1, 0; -1/sqrt(5), 0, -2/sqrt(5)];

Cl = [-50, 0, 100];
Cr = [ 50, 0, 100];

% semantics 
Krect = Kl;

% making Rrect
Xrect = (minus(Cr, Cl)/ norm(abs(minus(Cr, Cl))))';

Yrect = cross( Rl(3, :)', Xrect);

Zrect = cross( Xrect, Yrect);

% Rrect
Rrect = [Xrect'; Yrect'; Zrect'];

%
HL = Krect * Rrect * inv(Rl) * inv(Kl);
HR = Krect * Rrect * inv(Rr) * inv(Kr);

tl = maketform('projective',HL');
LIR = imtransform(L, tl);

tr = maketform('projective',HR');
RIR = imtransform(R, tr);


% Display and save the rectified images
figure, imshow(LIR)
imwrite(LIR,'fix_dot_left.ppm');

figure, imshow(RIR)
imwrite(RIR,'fix_dot_right.ppm');
