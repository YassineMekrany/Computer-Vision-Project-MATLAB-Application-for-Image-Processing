close all
clear all

T=100;
f=zeros(128,128);
f(32:96,32:96)=255;
[g1, t1]=edge(f, 'sobel', 'vertical');
figure(1),imshow(g1);
t1
sigma=1;
f=zeros(128,128);
f(32:96,32:96)=255;
[g3, t3]=edge(f, 'canny', [0.04 0.10], sigma);
figure(2),imshow(g3);
t3
f=zeros(101,101);
f(1,1)=1;
H=hough(f);
imshow(H,[])
f(101,1)=1;
H=hough(f);
imshow(H,[])
f(1,101)=1;
H=hough(f);
imshow(H,[])
f(101,101)=1;
H=hough(f);
imshow(H,[])
f(51,51)=1;
%generate the picture
f=zeros(128,128);
f(32:96,32:96)=255;

%find edges
sigma=1;
[g3, t3]=edge(f, 'canny', [0.04 0.10], sigma);

%Do the hough transform
[H t r] = hough(g3); %r and c store column labels...

%Display the transform in such a way that we can draw points on it later...
imshow(H, [], 'XData', t, 'YData', r );

%Add axis labels to the picture
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;

%detect four peaks
P  = houghpeaks(H,4);

%draw peaks over hough transform
%don't replace the picture when we start to draw
hold on; 
plot( t( P(:,2) ), r( P(:,1) ), 's', 'color', 'green'); 


