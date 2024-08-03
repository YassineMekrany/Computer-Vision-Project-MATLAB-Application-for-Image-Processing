function [r,c]=harris1(I,Rmin)
% [corners,R] = harris(I,sigma,Rmin)
% Applies Harris corner detector; plots results
% INPUT 
%    I - image
%    sigma - determines the size of the window function (gaussian)
%    Rmin - threshold for determining corners (cornerness measure R>Rmin)
% OUTPUT
%    corners [2 n_corners] - x and y coordinates of found corners
%    R - the 'cornerness measure' map
Ir=rgb2gray(I);
k = 0.04;
sigma=1;
Rmin=Rmin*60;
% Compute gradiants and the matrix M = [A B;B C] (gradient covariance matrix)
% [Ix,Iy] = gradient(double(Ir));
% gs = fspecial('gaussian',6*sigma,sigma); % size of window = 6*sigma
% A = filter2(gs,Ix.*Ix);
% B = filter2(gs,Iy.*Iy);
% C = filter2(gs,Ix.*Iy);
%===================================================================
dx = [-1 0 1; -1 0 1; -1 0 1];
dy = dx';
Ix = conv2(double(Ir),double(dx),'same');
Iy = conv2(double(Ir), double(dy),'same');
g = fspecial('gaussian',max(1,fix(6*sigma)), sigma);
A = conv2(Ix.^2, g, 'same');
B = conv2(Iy.^2, g, 'same');
C = conv2(Ix.*Iy, g, 'same');
R =(A.*B - C.^2)./(A + B +eps);
% Compute determinant and trace of M; and cornerness measure R
% detM = A.*B-C.^2;
% traceM = A+B;
% R = detM-k*traceM.^2;

% Threshold R and find its local maxima
thresh = R>Rmin;
maxima = local_maxima(R);
corners_mask = thresh & maxima;
[r,c] = find(corners_mask);

% -------------------------------------
function maxima = local_maxima(f);
% f is 2D
inf_row = Inf*ones(1,size(f,2));
inf_col = Inf*ones(size(f,1),1);

n = Inf*ones([size(f) 8]);
n(1:end-1,:,1) = f(2:end,:);
n(2:end,:,2) = f(1:end-1,:);
n(:,1:end-1,3) = f(:,2:end);
n(:,2:end,4) = f(:,1:end-1);
n(1:end-1,1:end-1,5) = f(2:end,2:end);
n(1:end-1,2:end,6) = f(2:end,1:end-1);
n(2:end,1:end-1,7) = f(1:end-1,2:end);
n(2:end,2:end,8) = f(1:end-1,1:end-1);

neigb_max = max(n,[],3);

maxima = f>neigb_max;