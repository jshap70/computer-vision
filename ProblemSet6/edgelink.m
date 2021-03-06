% EDGELINK - Link edge points in an image into lists
%
% Usage: [edgelist edgeim] = edgelink(im, minlength)
%
% Arguments:  im         - Binary edge image, it is assumed that edges
%                          have been thinned.
%             minlength  - Minimum edge length of interest
%
% Returns:  edgelist - a cell array of edge lists in row,column coords in
%                      the form
%                     { [r1 c1   [r1 c1   etc }
%                        r2 c2    ...
%                        ...
%                        rN cN]   ....]   
%
%           edgeim   - Image with pixels labeled with edge number.
%
%
% This function links edge points together into chains.  Where an edge
% diverges at a junction the function simply tracks one of the branches.
% The other branch is eventually processed as another edge.  These `broken
% branches' can be remerged by MERGESEG after a call to LINESEG.
%
% See also:  LINESEG, MAXLINEDEV, MERGESEG, DRAWSEG

% Acknowledgement:
% This code is inspired by David Lowe's Link.c function from the Vista image
% processing library developed at the University of British Columbia
%    http://www.cs.ubc.ca/nest/lci/vista/vista.html
%
% Peter Kovesi  
% School of Computer Science & Software Engineering
% The University of Western Australia
% pk @ csse uwa edu au
% http://www.csse.uwa.edu.au/~pk
%
% February 2001

function [edgelist, edgeim] = edgelink(im, minlength)
    
    global EDGEIM;      % Some global variables to avoid passing (and
                        % copying) of arguments, this improves speed.
    global ROWS;
    global COLS;
    
    elist = {};
    
    EDGEIM = im ~= 0;                     % make sure image is binary.
    EDGEIM = bwmorph(EDGEIM,'thin',Inf);  % make sure edges are thinned.
    
%   show(EDGEIM,1)
    EDGEIM = double(EDGEIM);
    [ROWS, COLS] = size(EDGEIM);
    edgeNo = 1;
        
    
    % Perform raster scan through image looking for edge points.  When a
    % point is found trackedge is called to find the rest of the edge
    % points.  As it finds the points the edge image pixels are labeled
    % with the -ve of their edge No
    
    for r = 1:ROWS
	for c = 1:COLS
	    if EDGEIM(r,c) == 1
		edgepoints = trackedge(r,c, edgeNo, minlength);
		if ~isempty(edgepoints)
		    edgelist{edgeNo} = edgepoints;
		    edgeNo = edgeNo + 1;
		end
	    end
	end
    end
    
    edgeim = -EDGEIM;  % Finally negate image to make edge encodings +ve.
%   show(edgeim,2), colormap(flag);
    
%----------------------------------------------------------------------    
% TRACKEDGE
%
% Function to track all the edge points associated with a start point.  From
% a given starting point it tracks in one direction, storing the coords of
% the edge points in an array and labelling the pixels in the edge image
% with the -ve of their edge number.  When no more connected points are
% found the function returns to the start point and tracks in the opposite
% direction.  Finally a check for the overall number of edge points found is
% made and the edge is ignored if it is too short.
%
% Note that when a junction is encountered along an edge the function
% simply tracks one of the branches.  The other branch is eventually
% processed as another edge.  These `broken branches' can be remerged by
% MERGESEG.
%
% Usage:   edgepoints = trackedge(rstart, cstart, edgeNo, minlength)
% 
% Arguments:   rstart, cstart   - row and column No of starting point
%              edgeNo           - the current edge number
%              minlength        - minimum length of edge to accept
%
% Returns:     edgepoints       - Nx2 array of row and col values for
%                                 each edge point.
%                                 An empty array is returned if the edge
%                                 is less than minlength long.


function edgepoints = trackedge(rstart, cstart, edgeNo, minlength)
    
    global EDGEIM;
    global ROWS;
    global COLS;    

    edgepoints = [rstart cstart];      % Start a new list for this edge.
    EDGEIM(rstart,cstart) = -edgeNo;   % Edge points in the image are 
			               % encoded by -ve of their edgeNo.
    
    [thereIsAPoint, r, c] = nextpoint(rstart,cstart); % Find next connected
                                                      % edge point.
    
    while thereIsAPoint
	edgepoints = [edgepoints             % Add point to point list
		     r    c   ];
	EDGEIM(r,c) = -edgeNo;               % Update edge image
	[thereIsAPoint, r, c] = nextpoint(r,c);
    end
    
    edgepoints = flipud(edgepoints);  % Reverse order of points

    % Now track from original point in the opposite direction
    
    [thereIsAPoint, r, c] = nextpoint(rstart,cstart);
    
    while thereIsAPoint
	edgepoints = [edgepoints
		     r    c   ];
	EDGEIM(r,c) = -edgeNo;
	[thereIsAPoint, r, c] = nextpoint(r,c);
    end
    
    % Reject short edges
    Npoints = size(edgepoints,1);
    if Npoints < minlength            
	for i = 1:Npoints   % Clear pixels in the edge image
	    EDGEIM(edgepoints(i,1), edgepoints(i,2)) = 0;
	end
	edgepoints = [];    % Return empty array
    end
    
	
%----------------------------------------------------------------------    
%
% NEXTPOINT
%
% Function finds a point that is 8 connected to an existing edge point
%

function [thereIsAPoint, nextr, nextc] = nextpoint(rp,cp);

    global EDGEIM;
    global ROWS;
    global COLS;
    
    % row and column offsets for the eight neighbours of a point
    % starting with those that are 4-connected.
    roff = [1  0 -1  0  1  1 -1 -1];
    coff = [0  1  0 -1  1 -1 -1  1];
    
    r = rp+roff;
    c = cp+coff;
    
    % Search through neighbours and return first connected edge point
    for i = 1:8
	if r(i) >= 1 & r(i) <= ROWS & c(i) >= 1 & c(i) <= COLS
	    if EDGEIM(r(i),c(i)) == 1
		nextr = r(i);
		nextc = c(i);
		thereIsAPoint = 1;
		return;             % break out and return with the data
	    end
	end
    end

    % If we get here there was no connecting next point.    
    nextr = 0;   
    nextc = 0;
    thereIsAPoint = 0;
