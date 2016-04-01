% combineImages
%
% Function scales and combines a set of images of the same size into a
% single image.  Each pixel value is scaled by the number of images
% that contribute to it.
%
% Usage:  combinedImages = scale&combine(images)
%
% Arguments:
%               images - A cell array containing the images to be
%                        combined.  The images must all be of the
%                        same size.
%
% Returns:
%               combinedImage - The scaled and combined image

function combinedImage = combineImages(images)

n = length(images);

sum = double(images{1});
mask1 = double(im2bw(images{1}, 1/255));
for i = 1:n
  sum = sum + double(images{i});
  mask1 = mask1 + double(im2bw(images{i}, 1/255));
end

mask2 = double(im2bw(imcomplement(mask1), 1));

mask(:,:,1) = imlincomb(1, mask1, 1, mask2, 'double');
mask(:,:,2) = mask(:,:,1);
mask(:,:,3) = mask(:,:,1);

% replace 0's with 1's
mask = max(mask, ones(size(mask)));

combinedImage = uint8(imdivide(sum, mask));

return
