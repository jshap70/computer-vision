% drawLine - draws a line within the bounding box in bbox by
% [xmin xmax ymin ymax] ie axis form.
%
% Usage: h = drawLine(line, bbox)
%
% Arguments:
%            line - a 3x1 column vector representing a line
%            bbox - a row vector containing scaling factors for the
%                   x- and y-axis of a figure.
%
% Returns:
%            h - returns a handle to the plotted line
%

function h = drawLine(line, bbox);

lxmin = [1; 0; -bbox(1)];
lxmax = [1; 0; -bbox(2)];
lymin = [0; 1; -bbox(3)];
lymax = [0; 1; -bbox(4)];

p1 = cross(line, lxmin);
p1 = p1/p1(3,1);
p2 = cross(line, lxmax);
p2 = p2/p2(3,1);
p3 = cross(line, lymin);
p3 = p3/p3(3,1);
p4 = cross(line, lymax);
p4 = p4/p4(3,1);

inbox = zeros(1, 4);
if p1(2) >= bbox(3) & p1(2) <= bbox(4) 
  inbox(1) = 1; 
end
if p2(2) >= bbox(3) & p2(2) <= bbox(4) 
  inbox(2) = 1; 
end
if p3(1) >= bbox(1) & p3(1) <= bbox(2) 
  inbox(3) = 1; 
end
if p4(1) >= bbox(1) & p4(1) <= bbox(2) 
  inbox(4) = 1; 
end

%inbox
I = find(inbox == 1);

if isempty(I)
  disp('Line lies outside bounding box');
  h = [];
else  
  p = [p1 p2 p3 p4];
  h = plot([p(1, I(1)) p(1, I(2))], [p(2, I(1)) p(2, I(2))], 'LineWidth', 2);
end
