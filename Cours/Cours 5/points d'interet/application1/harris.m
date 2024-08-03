function  harris(I,Rmin)
global nom_img editSeuille axe2 checkBruit

%    sigma - determines the size of the window function (gaussian)
%    Rmin - threshold for determining corners (cornerness measure R>Rmin)

Ir=rgb2gray(I);
sigma=1;
Rmin=Rmin*60;

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

% Threshold R and find its local maxima
thresh = R>Rmin;
maxima = local_maxima(R);
corners_mask = thresh & maxima;
[r,c] = find(corners_mask);

    set(axe2,'HandleVisibility','ON');
     axes(axe2);
     hold off,
     image(I); hold on,
     a=get(checkBruit,'value');
      if a 
          plot(c,r,'r+');
      else
          plot(c,r,'b+');
      end
    %  axis equal;
    %  axis tight;
     axis off;

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
