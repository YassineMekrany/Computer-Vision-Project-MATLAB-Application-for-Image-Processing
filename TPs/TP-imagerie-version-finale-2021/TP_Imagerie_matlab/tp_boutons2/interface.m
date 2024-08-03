function varargout = interface(varargin)
% INTERFACE M-file for interface.fig
%      INTERFACE, by itself, creates a new INTERFACE or raises the existing
%      singleton*.
%
%      H = INTERFACE returns the handle to a new INTERFACE or the handle to
%      the existing singleton*.
%
%      INTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INTERFACE.M with the given input arguments.
%
%      INTERFACE('Property','Value',...) creates a new INTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before interface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to interface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help interface

% Last Modified by GUIDE v2.5 01-Jun-2012 08:44:36

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interface_OpeningFcn, ...
                   'gui_OutputFcn',  @interface_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before interface is made visible.
function interface_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interface (see VARARGIN)

% Choose default command line output for interface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes interface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes on button press in ouvrir.
function ouvrir_Callback(hObject, eventdata, handles)
% hObject    handle to ouvrir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[file,path] = uigetfile('*.*');
%Chargement de l'image et affichage
handles.ima = imread(sprintf('%s',path,file));
%Affichage de l'aperçu
axes(handles.imgO)
handles.courant_data = handles.ima;
subimage(handles.courant_data);
axes(handles.imgT)
handles.ima_traite = 256;
subimage(handles.ima_traite);

%Grrrrrrrr
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in enregistrer.
function enregistrer_Callback(hObject, eventdata, handles)
% hObject    handle to enregistrer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image = handles.ima_traite;
[file,path] = uiputfile('*.png','Enregistrer Votre Image ...');
imwrite(image, sprintf('%s',path,file),'png');




% --- Executes on button press in quitter.
function quitter_Callback(hObject, eventdata, handles)
% hObject    handle to quitter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1)

% --- Executes on button press in btnlaplacien.
function btnlaplacien_Callback(hObject, eventdata, handles)
% hObject    handle to btnlaplacien (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

img=handles.courant_data;
img=double(img);
[n m]=size(img);
Resultat=zeros(n,m);
%M1=[0 1 0;1 -4 1;0 1 0];
M1=[-1 -1 -1;-1 8 -1;-1 -1 -1];
for i=2:n-1
    for j=2:m-1
        V=img((i-1:i+1),(j-1:j+1));
        S=V.*M1;
        Resultat(i,j)=sum(S(:));
    end
end
Resultat=uint8(Resultat);
%figure,imshow(Resultat),title('laplacien');

axes(handles.imgT);
subimage(Resultat);


% --- Executes on button press in btngradient.
function btngradient_Callback(hObject, eventdata, handles)
% hObject    handle to btngradient (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
%[n,m]=size(image);
%image = double(image);
%output=image;
%image=rgb2gray(image);
image=double(image);
[m,n] = size(image);
output=image;
output=zeros(size(image)); 
outputhor=zeros(size(image)); 
outputver=zeros(size(image)); 
maskhor = [0,0,0;-1,0,1;0,0,0]; 
maskver = [0,-1,0;0,0,0;0,1,0];
for i=4:(m-3)
   for j=4:(n-3) 
      for k=1:3         
          for l=1:3
            outputhor(i,j) = outputhor(i,j)+image(i-k,j-l)*maskhor(k,l);            
            outputver(i,j) = outputver(i,j)+image(i-k,j-l)*maskver(k,l);          
          end
      end
    end
 end
%mymin=min(min(output))
%mymax=max(max(output))
for i=4:(m-3)
for j=4:(n-3)       
    output(i,j)=sqrt(outputhor(i,j)*outputhor(i,j) + outputver(i,j)*outputver(i,j));
end 
end 
%outputhor=uint8(outputhor); 
%outputver=uint8(outputver); 
output=uint8(output); 

%b=uint8(b);
axes(handles.imgT);
subimage(output);

%figure(10);colormap(gray(256));imagesc(outputhor);title('gradient hor'); 
%figure(11);colormap(gray(256));imagesc(outputver);title('gradient ver'); 
%figure(12);colormap(gray(256));imagesc(output);title('gradient');

% --- Executes on button press in btnsobel.
function btnsobel_Callback(hObject, eventdata, handles)
% hObject    handle to btnsobel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
[n,m]=size(image);
image = double(image);
output=image;
%image=rgb2gray(image);
image=double(image);
[m,n] = size(image);

output=zeros(size(image)); 
outputhor=zeros(size(image)); 
outputver=zeros(size(image)); 
%maskhor = [-1,0,1;-b,0,b;-1,0,1]; 
%maskver = [-1,-b,-1;0,0,0;1,b,1];
%b=2 pour sobel
maskhor = [-1,0,1;-2,0,2;-1,0,1]; 
maskver = [-1,-2,-1;0,0,0;1,2,1];

for i=4:(m-3)
   for j=4:(n-3) 
      for k=1:3          
          for l=1:3
            outputhor(i,j) = outputhor(i,j)+image(i-k,j-l)*maskhor(k,l);             
            outputver(i,j) = outputver(i,j)+image(i-k,j-l)*maskver(k,l);          
          end
      end
    end
 end
%mymin=min(min(output))
%mymax=max(max(output))
for i=4:(m-3)
   for j=4:(n-3) 
output(i,j)=sqrt(outputhor(i,j)*outputhor(i,j) + outputver(i,j)*outputver(i,j)); 
   end
end
%outputhor=uint8(outputhor); 
%outputver=uint8(outputver); 
output=uint8(output); 
axes(handles.imgT);
subimage(output);

%figure(10);colormap(gray(256));imagesc(outputhor);title(gradient hor); 
%figure(11);colormap(gray(256));imagesc(output);title(gradient ver); 
%figure(12);colormap(gray(256));imagesc(output);title(gradient);



% --- Executes on button press in btnprewitt.
function btnprewitt_Callback(hObject, eventdata, handles)
% hObject    handle to btnprewitt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image=handles.courant_data;
image=double(image);
[m,n] = size(image);
output=zeros(size(image)); outputhor=zeros(size(image)); outputver=zeros(size(image)); 
maskhor = [-1,0,1;-1,0,1;-1,0,1]; 
maskver = [-1,-1,-1;0,0,0;1,1,1];
for i=4:(m-3)
   for j=4:(n-3) 
      for k=1:3          
		for l=1:3
            	
		 outputhor(i,j) = outputhor(i,j)+image(i-k,j-l)*maskhor(k,l);             
		 outputver(i,j) = outputver(i,j)+image(i-k,j-l)*maskver(k,l);        		 
        end       
      end
    end
 end
%mymin=min(min(output))
%mymax=max(max(output))
for i=4:(m-3)
   for j=4:(n-3) 
	output(i,j)=sqrt(outputhor(i,j)*outputhor(i,j) + outputver(i,j)*outputver(i,j)); 
   end 
end
	outputhor=uint8(outputhor); 
    outputver=uint8(outputver); 
	output=uint8(output); 	
     % num = get(handles.slider1, 'Value');
    % set(handles.txt1, 'String', num2str(num));
        %Seuillage
        [n,m]=size(image);
        for i=1:n
         for j=1:m
          if output(i,j) < 30
            output(i,j)=0;
          end
         end
        end
           %
%avec Matlab:    
%b = edge(I,'prewitt',handles.seuil); 
%handles.ima_traite = b;
handles.ima_traite = output;
axes(handles.imgT);
subimage(output);
%subimage(b);
%Grrr
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);




% --- Executes on button press in btnrobert.
function btnrobert_Callback(hObject, eventdata, handles)
% hObject    handle to btnrobert (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image = handles.courant_data;
[n,m]=size(image);
image = double(image);
 %num = get(handles.slider1, 'value');
% set(handles.edit1, 'String', num2str(num));
for x=1:n-1
 for y=1:m-1
  b(x,y)= abs(uint8( double(image(x,y))-double(image(x+1,y+1))))+ abs(uint8( double(image(x,y+1)) - double(image(x+1,y))));
 end
end
    % num = get(handles.slider1, 'Value');
    % set(handles.txt1, 'String', num2str(num));
        %Seuillage
        [n,m]=size(image);
        for i=1:n-1
         for j=1:m-1
          if b(i,j) < 25
            b(i,j)=0;
          end
         end
        end
           %
  handles.ima_traite = b;
  axes(handles.imgT);
  subimage(b);
%Grrr
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in btnMoy3.
function btnMoy3_Callback(hObject, eventdata, handles)
% hObject    handle to btnMoy3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/9)*[1 1 1 ; 1 1 1 ; 1 1 1 ];
for x = 2 : n-1
    for y = 2 : m-1
     %img(x,y)=mean([image(x-1,y-1)+image(x-1,y)+image(x-1,y+1)+image(x,y-1)+image(x,y)+image(x,y+1)+image(x+1,y-1)+image(x+1,y)+image(x+1,y+1)]);
      f=image(x-1:x+1,y-1:y+1);
      v=f.*H;
      %b=conv2(img,H);
      b(x,y)=sum(v(:));
      %b(x,y)=mean(f(:));
    end 
end
b=uint8(b);
%imshow(b);
axes(handles.imgT);
subimage(b);

% --- Executes on button press in btnGau3.
function btnGau3_Callback(hObject, eventdata, handles)
% hObject    handle to btnGau3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/16)*[1 2 1 ;2 4 2 ; 1 2 1];
for x = 2 : n-1
    for y = 2 : m-1
    f=image(x-1:x+1,y-1:y+1);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end
b=uint8(b);
axes(handles.imgT);
subimage(b);
handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);



% --- Executes on button press in btnMoy5.
function btnMoy5_Callback(hObject, eventdata, handles)
% hObject    handle to btnMoy5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/25)*[1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1 ; 1 1 1 1 1];
for x = 3 : n-2
    for y = 3 : m-2
     f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end
b=uint8(b);
axes(handles.imgT);
     subimage(b);
handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in btnGau5.
function btnGau5_Callback(hObject, eventdata, handles)
% hObject    handle to btnGau5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/256)*[1 4 6 4 1 ; 4 16 24 16 4 ; 6 24 36 24 6 ; 4 16 24 16 4 ; 1 4 6 4 1];
for x = 3 : n-2
    for y = 3 : m-2
  f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end
b=uint8(b);
axes(handles.imgT);
subimage(b);
handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in btnconique.
function btnconique_Callback(hObject, eventdata, handles)
% hObject    handle to btnconique (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[ n,m]=size(image);
image = double(image);
b=image;
H=(1/25)*[0 0 1 0 0 ; 0 2 2 2 0 ; 1 2 5 2 1 ; 0 2 2 2 0 ; 0 0 1 0 0];
for x = 3 : n-2
    for y = 3 : m-2
       f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end
b=uint8(b);
axes(handles.imgT);
subimage(b);
handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in btnpyrmid.
function btnpyrmid_Callback(hObject, eventdata, handles)
% hObject    handle to btnpyrmid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

image=handles.courant_data;
[n,m]=size(image);
image = double(image);
b=image;
H=(1/81)*[1 2 3 2 1 ; 2 4 6 4 2 ; 3 6 9 6 3 ; 2 4 6 4 2 ; 1 2 3 2 1];
for x = 3 : n-2
    for y = 3 : m-2
          f=image(x-2:x+2,y-2:y+2);
      v=f.*H;
      b(x,y)=sum(v(:));
    end 
end
b=uint8(b);
axes(handles.imgT);
subimage(b);
handles.ima_traite = b;
handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in btnMediane.
function btnMediane_Callback(hObject, eventdata, handles)
% hObject    handle to btnMediane (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imageO=handles.courant_data;
%image=imnoise(imageO,'salt & pepper', 0.05);
image=double(imageO);
[n,m]=size(image);
img=image;
for i=2:n-1
    for j=2:m-1
       fenetre=image(i-1:i+1,j-1:j+1);
       v=[fenetre(1,:) fenetre(2,:) fenetre(3,:)];
       sort(v);
       a=median(v);
       img(i,j)=a;
    end
end
b=uint8(img);
%imshow(b);
%figure(1),imshow(b);

axes(handles.imgT);
subimage(b);


% --- Executes on button press in btninversion.
function btninversion_Callback(hObject, eventdata, handles)
% hObject    handle to btninversion (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img = handles.courant_data;
img=uint8(-double(img)+255);
axes(handles.imgT);
subimage(img);



% --- Executes on button press in btnBin.
function btnBin_Callback(hObject, eventdata, handles)
% hObject    handle to btnBin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
image = handles.courant_data;
[n,m]=size(image);
image = double(image);
 %num2 = get(handles.slider2, 'value');
 %set(handles.txt2, 'String', num2str(num2));
for i=1:n
 for j=1:m
  if image(i,j) < 200
    bin(i,j)=0;
  else
    bin(i,j)=255;
  end
 end
end
%Avec Matlab:
%bin = im2bw(image,get(handles.slider2,'value') );
%
%set(handles.txtmsg,'visible','on');
%set(handles.txtmsg,'string','Choisissez un seuil');
%
axes(handles.imgT);
handles.ima_traite = bin;
subimage(handles.ima_traite);
%Grrr
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in btnContraste.
function btnContraste_Callback(hObject, eventdata, handles)
% hObject    handle to btnContraste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


image=handles.courant_data;
%[n,m]=size(image);
image = double(image);
%output=image;

%ima=imread('cameraman.tif');
[l c]=size(image);
image = double(image);
v=image;
for i=1:l
    for j=1:c
      fpixel = (image(i,j)-128)*5 + 128; 
    % on vérifie que la valeur obtenue est bien dans [0..255]
    if( fpixel>255 )
      fpixel = 255;
    else if( fpixel<0 )
      fpixel = 0;
        end 
    end
    
   v(i,j) = fpixel;
    end
end  
v=uint8(v); 
axes(handles.imgT);
subimage(v);



% --- Executes on button press in btnDiv.
function btnDiv_Callback(hObject, eventdata, handles)
% hObject    handle to btnDiv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ima=handles.courant_data;
[l c]=size(ima);
v=ima;
for i=1:l
    for j=1:c
        v(i,j)=ima(i,j)/5;
    end
end    
axes(handles.imgT);
subimage(v);


% --- Executes on button press in btnNiv.
function btnNiv_Callback(hObject, eventdata, handles)
% hObject    handle to btnNiv (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ima=handles.courant_data;
d = length(size(ima));
if d==3
    imagray=rgb2gray(ima);
elseif d==2
   imagray=ima;
end
axes(handles.imgT);
subimage(imagray);



% --- Executes on button press in btnHist.
function btnHist_Callback(hObject, eventdata, handles)
% hObject    handle to btnHist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


ima=handles.courant_data;
 
[nl nc]=size(ima);
v=double(ima);
vec=[1:256];
l=0;
for k=0:255 
    for i=1:nl
        for j=1:nc
            if v(i,j)==k 
               l=l+1;
            end
        end
    end
    vec(k+1)=l;
    l=0;
end
axes(handles.imgT);
plot(vec);


% --- Executes on button press in btnFpb.
function btnFpb_Callback(hObject, eventdata, handles)
% hObject    handle to btnFpb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = handles.courant_data;
 F=fftshift(fft2(I)); 
% %calcul de la taille de l'image; 
 M=size(F,1); 
 N=size(F,2); 
 P=size(F,3); 
 H0=zeros(M,N); 
 D0=10; 
 M2=round(M/2); 
 N2=round(N/2); 
 H0(M2-D0:M2+D0,N2-D0:N2+D0)=1; 
 for i=1:M 
  for j=1:N 
      G(i,j)=F(i,j)*H0(i,j); 
 end 
 end 
 g=ifft2(G); 
 %subplot(1,2,1);imshow(I);title('image originale'); 
 %subplot(1,2,2);
 imshow(abs(g),[0,255]);%title('image filtrée');


% --- Executes on button press in btnFpbb.
function btnFpbb_Callback(hObject, eventdata, handles)
% hObject    handle to btnFpbb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I = handles.courant_data;
%I = imread('eight.tif');

F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3);

H0=zeros(M,N); 
D0=20; 
M2=round(M/2); 
N2=round(N/2); 
H0(M2-D0:M2+D0,N2-D0:N2+D0)=1; 

n=3; 

for i=1:M 
for j=1:N 
%H(i,j)=1/(1+(H0(i,j)/D0)^(2*n)); 
G(i,j)=F(i,j)*H0(i,j); 
end 
end 

g=ifft2(G); 

%subplot(1,2,1);imshow(I);title('image originale'); 
%subplot(1,2,2);
imshow(abs(g),[0,255]);%title('image filtrée'); 



% --- Executes on button press in btnFph.
function btnFph_Callback(hObject, eventdata, handles)
% hObject    handle to btnFph (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I=handles.courant_data;
%charge; 
F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 

H1=ones(M,N); 
D0=3; 
M2=round(M/2); 
N2=round(N/2); 
H1(M2-D0:M2+D0,N2-D0:N2+D0)=0; 
for i=1:M 
for j=1:N 
G(i,j)=F(i,j)*H1(i,j); 
end 
end 
g=ifft2(G); 
%subplot(1,2,1);imshow(I);title('image originale'); 
%subplot(1,2,2);
imshow(255-abs(g),[0,255]);
%title('image filtrée');



% --- Executes on button press in btnFphb.
function btnFphb_Callback(hObject, eventdata, handles)
% hObject    handle to btnFphb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I=handles.courant_data;

F=fftshift(fft2(I)); 
%calcul de la taille de l'image; 
M=size(F,1); 
N=size(F,2); 
P=size(F,3); 

H1=ones(M,N); 
D0=3; 
M2=round(M/2); 
N2=round(N/2); 
H1(M2-D0:M2+D0,N2-D0:N2+D0)=0; 

n=3; 

for i=1:M 
for j=1:N 
H(i,j)=1/(1+(H1(i,j)/D0)^(2*n)); 
G(i,j)=F(i,j)*H(i,j); 
end 
end 

g=ifft2(G); 

%subplot(1,2,1);imshow(I);title('image originale'); 
%subplot(1,2,2);
imshow(255-abs(g),[0,255]);%title('image filtrée');




