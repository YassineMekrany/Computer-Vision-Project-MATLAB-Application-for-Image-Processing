function [x,y]=susan1(im, b_thr)  
%===========================================================
% check inputs and fill in the blank variables
%===========================================================
% convert to double image format
I = double(im);
[y_size, x_size] = size(I);

% prepare the inputs and outputs
C = zeros(y_size, x_size);
cgx = zeros(y_size, x_size);
cgy = zeros(y_size, x_size);
thresh = b_thr;
max_corners = 1700;

%===========================================================
% create the brightness look up table (LUT)
%===========================================================

k = [(-256:256)/thresh];
k = k.^6;
k = fix(100*exp(-k));
bright_LUT = [0,k,0];

% set up the variables
r = zeros(y_size, x_size);

%===========================================================
% set up the circular masks
%===========================================================

% 37 pixel circular mask
w = [ 0, 0, 1, 1, 1, 0, 0;
      0, 1, 1, 1, 1, 1, 0;
      1, 1, 1, 1, 1, 1, 1;
      1, 1, 1, 0, 1, 1, 1;
      1, 1, 1, 1, 1, 1, 1;
      0, 1, 1, 1, 1, 1, 0;
      0, 0, 1, 1, 1, 0, 0];

% 37 pixel circular mask for x
wx = [ 0, 0,-1, 0, 1, 0, 0;
       0,-2,-1, 0, 1, 2, 0;
      -3,-2,-1, 0, 1, 2, 3;
      -3,-2,-1, 0, 1, 2, 3;
      -3,-2,-1, 0, 1, 2, 3;
       0,-2,-1, 0, 1, 2, 0;
       0, 0,-1, 0, 1, 0, 0];

% 37 pixel circular mask for y
wy = wx';

%===========================================================
% compute the USAN response
%===========================================================

for i = 6:y_size-6
    for j = 6:x_size-6

        %compute correlation for the window mask w
        p = (258 + I(i,j)) - I(i-3:i+3,j-3:j+3); 
        p = bright_LUT(p);
        p1 = p.*w;
        n = sum(sum(p1));
        
        %if already too big - ignore it
        if n < max_corners,  

            %compute correlation for the window mask wx
            p1 = p.*wx;
            x = sum(sum(p1));
            xx = x^2;

            %compute correlation for the window mask wy
            p1 = p.*wy;
            y = sum(sum(p1));
            yy = y^2;

            %compute the sq response
            sq = xx + yy;
            if sq > ((n*n)/2),
                % check the centre of gravity
                if yy < xx,
                    divide = y/(abs(x));
                    sq1 = abs(x)/x;
                    i1 = (258 + I(i,j)) - I(i + fix(divide), j + sq1);
                    i2 = (258 + I(i,j)) - I(i + fix(2*divide), j + 2*sq1);
                    i3 = (258 + I(i,j)) - I(i + fix(3*divide), j + 3*sq1);
                    sq1 = bright_LUT(i1) + bright_LUT(i2) + bright_LUT(i3);
                else
                    divide = x/(abs(y));
                    sq1 = abs(y)/y;
                    i1 = (258 + I(i,j)) - I(i + sq1, j + fix(divide));
                    i2 = (258 + I(i,j)) - I(i + 2*sq1, j + fix(2*divide));
                    i3 = (258 + I(i,j)) - I(i + 3*sq1, j + fix(3*divide));
                    sq1 = bright_LUT(i1) + bright_LUT(i2) + bright_LUT(i3);
                end
                
                % threshold the response to find the corners
                if sq1 > 290,
                    r(i,j) = max_corners - n;
                    cgx(i,j) = (51*x)/n;
                    cgy(i,j) = (51*y)/n;
                end

            end
        end
    end
end
%===========================================================
% perform nonmaximal suppression (5x5 mask)
%===========================================================

% find the local maxima
max_sup = ordfilt2(r, 25, ones(5,5)); 

% corner must be local maxima
C = (r == max_sup) & (r > 0);   

%===========================================================
% remove any close corners
%===========================================================
    
   
% 5x5 neighbourhood mask (12 points)
 wn1 = [ 1, 1, 1, 1, 1, 
         1, 1, 1, 1, 0, 
         1, 1, 0, 0, 0, 
         1, 0, 0, 0, 0, 
         0, 0, 0, 0, 0 ];
      
% % remove close corners
 C_neigh = ordfilt2(C, 12, wn1);  
 C = (C & (C_neigh == 0));
 [x,y]=find(C);