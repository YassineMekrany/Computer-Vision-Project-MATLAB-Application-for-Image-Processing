function detection(action,varargin)
%%
%%
if nargin<1,
   action='InitDetection';
end;

feval(action,varargin{:});
return;
%%
%%
%%
function InitDetection()

% si la fonction "detection" est d�j� lanc�e
H = findobj(allchild(0), 'tag', 'D�tection des points d''int�r�ts');
if ~isempty(H)
   figure(H(1))
   return
end

%/*** la figure principale
DetectionFig=figure('Name','D�tection des Points d''Int�r�ts', ...
   'NumberTitle','off', ...
   'tag', 'D�tection des points d''int�r�ts', ...
   'Visible','off', 'Resize', 'off',...
   'BusyAction','Queue','Interruptible','off', ...
   'Color', [.8 .8 .8],...
   'position',[180 120 630 500],...
   'IntegerHandle', 'off', ...
   'Colormap', gray(256));

%==========================================================================
%======================== les menus et les boutons  =======================
%==========================================================================
%=****** les parametres pour tous les bouton et les menu  *****************

Std.Interruptible = 'off';
Std.BusyAction = 'queue';
Ctl = Std;
Ctl.Units = 'Pixels';
Ctl.Parent = DetectionFig;

%****** text
Texte=Ctl;
Texte.Style='text';
Texte.Horiz='left';
Texte.Background=[0.7 0.8 0.9];
Texte.Foreground='black';
Texte.FontWeight='bold';

%******* edit
Edit=Ctl;
Edit.Style='edit';
Edit.Horiz='right';
Edit.Background=[1 1 1];
Edit.Foreground='black';
Edit.FontWeight='bold';

%******* axes
Axe=Ctl;
Axe.ydir= 'reverse';
Axe.FontWeight='bold';
Axe.XLim= [0 256];
Axe.YLim= [0 256];
Axe.CLim= [0 1];
Axe.XTick=[];
Axe.YTick=[];

%******* menu
Menu=Ctl;
Menu.Style='popupmenu';
Menu.Enable='on';
Menu.Background=[1 1 1];
Menu.FontWeight='bold';
% Menu.Tag='ImagesPop';

%******* checkbox
Chek=Ctl;
Chek.Style='checkbox';
Chek.Enable='on';
Chek.Background=[0.7 0.8 0.9];
Chek.FontWeight='bold';

%****** bouton
Btn=Ctl;
Btn.Style='pushbutton';
Btn.Units='pixels';
Btn.FontWeight='bold';

%****** image
Img=Std;
Img.CData= [];
Img.CDataMapping= 'scaled';
Img.Xdata=[0 256];
Img.Ydata=[0 256];
Img.EraseMode='normal';

%%%%%%%%%%=================================================%%%%%%%%%%%%%%%%
%%%%%%%%%%=================================================%%%%%%%%%%%%%%%%

%/*** les axes de l'image du fond
h.hAxImgFond=axes(Axe,...   
   'Position', [0 0 640 505]);

%==========================================================================
%/*** initialiser les axes de l'images du fond
h.hImgFond = image(Img,'Parent', h.hAxImgFond);

imagfond=imread('mur3.jpg');
imagefond=double(imagfond)/255;
set(h.hImgFond, 'Cdata', imagefond);

%==========================================================================
%/*** les axes de
h.hAxStatus=axes(Axe,...
   'Color', [165 95 61]/255,...
   'Xcolor',[165 95 61]/255,...
   'Ycolor',[165 95 61]/255,...
   'Fontsize', 11 , ...
   'Position',[10 10 330 0.001]);
title('','color','white');

%==========================================================================
%/*** les axes de l'image originale
h.hAxImgOri=axes(Axe,...
   'Position', [30 210 256 256]);
title('L''image Originale','color','white');

%/*** initialiser les axes de l'images originale
h.hImgOri = image(Img,...
    'Parent', h.hAxImgOri,...
    'EraseMode','none');

%==========================================================================
%/*** les axes de l'image calcul�e
h.hAxImgCal=axes(Axe,...
   'Position', [340 210 256 256]);
title('L''image Calcul�e','color','white');

%/*** initialiser les axes de l'images calcul�e
h.hImgCal = image(Img,'Parent', h.hAxImgCal);

%==========================================================================
%/*** cadre 1 (� gauche)
h.Cadre1=uicontrol('parent',DetectionFig,...
    'Units','pixels',...
    'BusyAction','Queue','Interruptible','off',...
    'Style', 'frame',...
    'Backgroundcolor', [0.7 0.8 0.9],...
    'Position', [10 90 170 100]);
 
%==========================================================================
% Text label pour le menu image
h.TexteIm=uicontrol(Texte,...
   'Position',[15 165 140 20], ...
   'String','S�lectionner une image :');

%==========================================================================
%/*** les images charg�s
h.hPopImg= uicontrol(Menu,...
    'String', 'Lena|Marteau|Cube|Nombre|Checkboard1|Checkboard2|Checkboard3|Matricule|Maison|Chambre|Clavier|Kids|Objets|SIS|Th�',...
    'Position', [15 116 140 50],...
    'Callback', 'detection(''ChargerImage'')');

%==========================================================================
% Text label pour le type du detecteur
h.TexteMeth=uicontrol(Texte,...
   'Position',[15 115 140 20], ...
   'String','Choisir un d�tecteur :');

%==========================================================================
%/*** menu m�thode de detection
h.hPopMethode= uicontrol(Menu,...
    'String', 'Harris|Mod�le El�ctrostatique|CSS|Susan',...
    'Position', [15 68 140 50],...
    'Callback','detection(''UpdateDetecteur'')');

%==========================================================================
%/*** cadre 2 (milieu)
h.Cadre2=uicontrol('parent',DetectionFig,...
    'Units','pixels',...
    'BusyAction','Queue','Interruptible','off',...
    'Style', 'frame',...
    'Backgroundcolor', [0.7 0.8 0.9],...
    'Position', [190 90 200 100]);

%==========================================================================
%/*** case � cocher ajouter du bruit
h.hAjouterBruit= uicontrol(Chek,...
    'String', 'Ajouter un Bruit :',...
    'Position', [200 165 140 20],...
    'callback','detection(''ActiverBruit'')');

%==========================================================================
%/*** menu type de bruit
h.hPopBruit= uicontrol(Menu,...
    'String', 'Gaussien|Sel & Poivre|Speckle',...
    'Position', [220 115 120 50],...
    'Callback','detection(''UpdateTypeBruit'')');

%==========================================================================
%================ les controles des differents types de bruits ============
%==========================================================================
 
%=============== les parametres des controls de bruit gaussien  ===========
%  Moyenne et Variance pour bruit Gaussien
h.hMoyenneGaussian = uicontrol(Edit, ...
   'Position',[280 120 80 20], ...
   'String','0.0',...
   'callback','detection(''EditBoxUpdate2'',''MoyenneGaussian'')');
h.hTxtMoyenneGaussian = uicontrol( Texte, ...
   'Position',[200 117 60 20], ...
   'String','Moyenne :');
h.MoyenneGaussian = 0.0;

h.hVarianceGaussian = uicontrol(Edit, ...
   'Position',[280 98 80 20], ...
   'String','0.005',...
   'callback','detection(''EditBoxUpdate2'',''VarianceGaussian'')');
h.hTxtVarianceGaussian = uicontrol( Texte, ...
   'Position',[200 95 60 20], ...
   'String','Variance :');
h.VarianceGaussian =0.005;

%=============== les parametres des controls de bruit sel & poivre ========
%  densit� pour bruit Sel & Poivre
h.hSelPoivreDensite = uicontrol(Edit, ...
   'Position',[280 115 80 20], ...
   'String','0.1',...
   'callback','detection(''EditBoxUpdate2'',''SelPoivreDensite'')');
h.hTxtSelPoivreDensite = uicontrol( Texte, ...
   'Position',[200 112 60 20], ...
   'String','Densit� :');
h.SelPoivreDensite = 0.1;

%================= les parametres des controls de bruit speckel  ==========
%  Variance pour bruit Speckle
h.hSpeckleVariance = uicontrol(Edit, ...
   'Position',[280 115 80 20], ...
   'String','0.04',...
   'callback','detection(''EditBoxUpdate2'',''SpeckleVariance'')');
h.hTxtSpeckleVariance = uicontrol( Texte, ...
   'Position',[200 112 60 20], ...
   'String','Variance :');
h.SpeckleVariance = 0.04;

%==========================================================================
%/*** cadre 3 (a droite)
h.Cadre3=uicontrol('parent',DetectionFig,...
    'Units','pixels',...
    'BusyAction','Queue','Interruptible','off',...
    'Style', 'frame',...
    'Backgroundcolor', [0.7 0.8 0.9],...
    'Position', [400 90 220 100]);

%==========================================================================
%================ les controles des differents detecteur ==================
%==========================================================================
% Text label pour les parametres des detecteur
h.TextePara=uicontrol(Texte, ...
   'Position',[410 160 205 25]);
 
%=============== les parametres des controls de HARRIS  ===================

%%/ text label seuil de detection de harris
h.hTxtHarrisSeuil=uicontrol(Texte, ...
   'Position',[410 100 120 20], ...
   'String','Seuil de D�tection :');

%%/ champ texte pour seuil de detection de harris
h.hHarrisSeuil=uicontrol(Edit, ...
   'Position',[530 103 80 20], ...
   'String','50',...
   'callback','detection(''EditBoxUpdate1'',''HarrisSeuil'')');
% h.HarrisSeuil=10;

%%/ text label variance sigma Harris
h.hTxtHarrisSigma=uicontrol(Texte,...
   'Position',[410 130 120 20], ...
   'String','Variance (Sigma) :');

%%/ champ texte pour variance sigma  Harris
h.hHarrisSigma=uicontrol(Edit, ...
   'Position',[530 133 80 20], ...
   'String','2',...
   'callback','detection(''EditBoxUpdate1'',''HarrisSigma'')');
% h.HarrisSigma=1;

%**************************************************************************
%================== les controle de Mod�le Electrostatique  ===============

%%/ text label seuil de detection de Mod�le Electrostatique
h.hTxtHarAmeSeuil=uicontrol(Texte,...
   'Position',[410 100 120 20], ...
   'String','Seuil de D�tection :');

%%/ champ texte pour seuil de detection de Mod�le Electrostatique
h.hHarAmeSeuil=uicontrol(Edit,...
   'Position',[530 103 80 20], ...
   'String','50',...
   'callback','detection(''EditBoxUpdate1'',''HarAmeSeuil'')');
% h.HarAmeSeuil=10;

%%/ text label variance sigma Mod�le Electrostatique
h.hTxtHarAmeSigma=uicontrol(Texte,...
   'Position',[410 130 120 20], ...
   'String','Variance (Sigma) :');

%%/ champ texte pour variance  Mod�le Electrostatique
h.hHarAmeSigma=uicontrol(Edit, ...
   'Position',[530 133 80 20], ...
   'String','2',...
   'callback','detection(''EditBoxUpdate1'',''HarAmeSigma'')');
% h.HarAmeSigma=1;

%**************************************************************************
%===================== les controle de CSS ================================

%%/ text label seuil de detection de CSS
h.hTxtCssSeuil=uicontrol(Texte,...
   'Position',[410 100 120 20], ...
   'String','Seuil de D�tection :');

%%/ champ texte pour seuil de detection de CSS
h.hCssSeuil=uicontrol(Edit,...
   'Position',[530 103 80 20], ...
   'String','0.35',...
   'callback','detection(''EditBoxUpdate1'',''CssSeuil'')');
% h.CssSeuil=10;

%%/ text label variance sigma CSS
h.hTxtCssSigma=uicontrol(Texte,...
   'Position',[410 130 120 20], ...
   'String','Variance (Sigma) :');

%%/ champ texte pour variance sigma CSS
h.hCssSigma=uicontrol(Edit, ...
   'Position',[530 133 80 20], ...
   'String','3',...
   'callback','detection(''EditBoxUpdate1'',''CssSigma'')');
% h.CssSigma=1;

%**************************************************************************
%======================== les controls de SUSAN   =========================

%%/ text label seuil de detection de Susan
h.hTxtSusanSeuil=uicontrol(Texte,...
   'Position',[410 100 120 20], ...
   'String','Seuil de D�tection :');

%%/ champ texte pour seuil de detection de Susan
h.hSusanSeuil=uicontrol(Edit,...
   'Position',[530 103 80 20], ...
   'String','50',...
   'callback','detection(''EditBoxUpdate1'',''SusanSeuil'')');
% h.SusanSeuil=10;

%%/ text label rayon Susan
h.hTxtSusanRayon=uicontrol(Texte,...
   'Position',[410 130 120 20], ...
   'String','Rayon :');

%%/ champ texte pour rayon  Susan
h.hSusanRayon=uicontrol(Edit, ...
   'Position',[530 133 80 20], ...
   'String','2',...
   'callback','detection(''EditBoxUpdate1'',''SusanRayon'')');
% h.SusanRayon=1;

%==========================================================================
%/*** le bouton appliquer
h.hBtnAppliquer=uicontrol(Btn, ...
   'Position',[435 55 140 30], ...
   'String','Appliquer',...
   'Callback','detection(''AppliquerDetecteur'')');

%==========================================================================
%/*** le bouton ajouter bruit
h.hBtnAjouter=uicontrol(Btn, ...
   'Position',[215 55 140 30], ...
   'String','Ajouter Bruit',...
   'Callback','detection(''AjouterBruit'')');

%==========================================================================
%/*** le bouton fermer
h.hBtnFermer=uicontrol(Btn, ...
   'Position',[500 15 120 30], ...
   'String','Fermer', ...
   'Callback','close(gcf)');

%==========================================================================
%/*** le bouton A propos
h.hBtnInfo=uicontrol(Btn, ...
   'Position',[360 15 120 30], ...
   'String','A propos', ...
   'Callback','Apropos');

 %=========================================================================
set(DetectionFig, 'UserData', h,'Visible','on');
UpdateDetecteur(DetectionFig);
ChargerImage(DetectionFig);
UpdateTypeBruit(DetectionFig);
ActiverBruit(DetectionFig);
set(h.hBtnAppliquer,'Enable','on');
drawnow
return

%%*************************************************************************
%%********************* les fonctions utilis�es  **************************
%%*************************************************************************
%% ========================================================================
%%/=========================  charger une image ===========================
%%=========================================================================
function ChargerImage(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h=get(ImgFig,'UserData');
set(h.hImgOri, 'Cdata', []);
v1=get(h.hPopImg,{'value','String'});
nom=deblank(v1{2}(v1{1},:));
drawnow
switch nom

    case 'Lena',
   img = imread('lena.jpg');
case 'Marteau',
   img = imread('marteau.jpg');
case 'Cube',
    img = imread('cube.jpg');
case 'Nombre',
    img = imread('nombre.jpg');
case 'Matricule'
    img = imread('car3.jpg');
case 'Maison'
    img = imread('maison.jpg');
case 'Chambre'
    img = imread('chambre.jpg');
case 'Checkboard1',
   img= checkerboard(21,3,3)>0.5;
   img=img*255;
case 'Checkboard2',
   img= checkerboard(21,3,3);
   img=img*255;
case 'Clavier'
    img = imread('clavier.jpg');
case 'Kids'
    img = imread('kids.jpg');
case 'Objets'
    img = imread('objet.jpg');
case 'SIS'
    img = imread('sis.bmp');
case 'Th�'
    img = imread('th�.jpg');
case 'Checkboard3'
    im = checkerboard(21,3,3);
    img=im*255;
    t=maketform('affine',[1 0.2;0.1 1;0 0]);
    img=imtransform(img,t,'Size',[256 256],'fill',128);
otherwise 
   error('il y''a une erreur ');
end
if(size(img,3)==3)
    %display('l''image est en couleur')
    img=rgb2gray(img);
end
img = double(img)/255;
set(h.hImgOri, 'Cdata', img);
cla(h.hImgCal);
set(h.hImgCal, 'Cdata', img);

var = (get(h.hAjouterBruit, 'Value') == 1);
if var
    UpdateTypeBruit(ImgFig);
    AjouterBruit(ImgFig);
end
AppliquerDetecteur(ImgFig);
return

%%=========================================================================
%%========================== appliquer le detecteur =======================
%%=========================================================================
function AppliquerDetecteur(ImgFig)

if nargin<1
   ImgFig = gcbf;
end
h=get(ImgFig,'UserData');
% cla(h.hImgCal);
set(ImgFig,'Pointer','watch');
set(h.hBtnAppliquer, 'Enable', 'off');
set(get(h.hAxStatus,'title'),'string',['Calcul des points d''int�r�ts en cours ...']);
orig = getimage(h.hImgCal);
r=6; sze=2*r+1;

[m,n]=size(orig);
imd=double(orig)*255;

v2 = get(h.hPopMethode,{'value','String'});
methode = deblank(v2{2}(v2{1},:));
drawnow
switch methode
case 'Harris'
%==========================================================================
%=========================== Detecteur de Harris ==========================
%==========================================================================
    sigma=get(h.hHarrisSigma,'String');
    seuil=get(h.hHarrisSeuil,'String');
    sigma=str2num(sigma);
    seuil=str2num(seuil);
    %/*****************************************
    lambda=0.04; w=5*sigma;
    dx=[-1 0 1];
    dy=dx';
    g = fspecial('gaussian',max(1,fix(w)), sigma); % taille de gaussien (5 ou 7)
    Ix=conv2(imd,dx,'same');
    Iy=conv2(imd,dy,'same');
    Ix2 = conv2(Ix.^2, g, 'same');  
    Iy2 = conv2(Iy.^2, g, 'same');
    Ixy = conv2(Ix.*Iy, g,'same');
    detM=Ix2.*Iy2-Ixy.^2;
    trM=Ix2+Iy2;
    R=detM-lambda*trM.^2;
    R1=(1000/(max(max(R))))*R;
    %**************** Etape de filtrage des points d'interets *************
%     [u,v]=find(R1<=seuil);
%     nb=length(u);
%     for k=1:nb
%         R1(u(k),v(k))=0;
%     end
%     R11=zeros(m+2*r,n+2*r);
%     R11(r+1:m+r,r+1:n+r)=R1;
%     [m1,n1]=size(R11);
%     for i=r+1:m1-r
%         for j=r+1:n1-r
%             fenetre=R11(i-r:i+r,j-r:j+r);
%             ma=max(max(fenetre));
%             if fenetre(r+1,r+1)<ma
%                 R11(i,j)=0;
%             end
%         end
%     end
%     R11=R11(r+1:m+r,r+1:n+r);
%     [x,y]=find(R11);
    %======================================================================
    MX=ordfilt2(R1,sze^2,ones(sze));
    R11 = (R1==MX)&(R1>seuil);
    [x,y]=find(R11);
    %======================================================================
%**************************************************************************
case 'Mod�le El�ctrostatique'
    %/*********************************************************************
    %=================== Detecteur de Harris Am�lior� =====================
    sigma=get(h.hHarAmeSigma,'String');
    seuil=get(h.hHarAmeSeuil,'String');
    sigma=str2num(sigma);
    seuil=str2num(seuil);
    lambda=0.04; w=5*sigma;
    dxa=[sqrt(2)/4 0 -sqrt(2)/4
        1 0 -1
        sqrt(2)/4 0 -sqrt(2)/4]; % deriv�e horizontale : 
    dya=dxa'; % deriv�e verticale :
    g = fspecial('gaussian',max(1,fix(w)), sigma);
    Ixa=conv2(imd,dxa,'same');
    Iya=conv2(imd,dya,'same');
    Ixa2 = conv2(Ixa.^2, g, 'same');  
    Iya2 = conv2(Iya.^2, g, 'same');
    Ixya = conv2(Ixa.*Iya, g,'same');
    % M=[Ix2 Ixy
    %     Ixy Iy2];
    detM=Ixa2.*Iya2-Ixya.^2;
    trM=Ixa2+Iya2;
    R=detM-lambda*trM.^2;
    R1=(1000/(1+max(max(R))))*R;
    %======================================================================
    %**************** Etape de filtrage des points d'interets *************
%     [u,v]=find(R1<=seuil);
%     nb=length(u);
%     for k=1:nb
%         R1(u(k),v(k))=0;
%     end
%     R11=zeros(m+2*r,n+2*r);
%     R11(r+1:m+r,r+1:n+r)=R1;
%     [m1,n1]=size(R11);
%     for i=r+1:m1-r
%         for j=r+1:n1-r
%             fenetre=R11(i-r:i+r,j-r:j+r);
%             ma=max(max(fenetre));
%             if fenetre(r+1,r+1)<ma
%                 R11(i,j)=0;
%             end
%         end
%     end
%     R11=R11(r+1:m+r,r+1:n+r);
%     [x,y]=find(R11);
%**************************************************************************
    %======================================================================
    MX=ordfilt2(R1,sze^2,ones(sze));
    R11 = (R1==MX)&(R1>seuil);
    [x,y]=find(R11);
    %======================================================================
case 'CSS'
    %/*********************************************************************
    %=================== Detecteur de CSS ========================
    sigma=get(h.hCssSigma,'String');
    seuil=get(h.hCssSeuil,'String');
    sigma=str2num(sigma);
    seuil=str2num(seuil);
    
    H=seuil; C=1.5; T_angle=162; L=0; Endpoint=1; Gap_size=1;

    BW=edge(orig,'canny',[L,H]);  % Detect edges

    [curve,curve_start,curve_end,curve_mode,curve_num]=extract_curve(BW,Gap_size);  % Extract curves

    cout=get_corner(curve,curve_start,curve_end,curve_mode,curve_num,BW,sigma,Endpoint,C,T_angle); % Detect corners
    if size(cout)==[0,0]
        x=[];
        y=[];
    else
        x=cout(:,1);
        y=cout(:,2);
    end
%**************************************************************************

case 'Susan'
    
%/*************************************************************************
%========================= Detecteur de Susan =============================
    rayon=get(h.hSusanRayon,'String');
    seuil=get(h.hSusanSeuil,'String');
    rayon=str2num(rayon);
    seuil=str2num(seuil);
    alpha=seuil/100;
    % ========================g�neration du mask===========================
    mask=zeros(2*rayon+1);
    b=ones(rayon+1);
    for i=1:rayon+1
        for j=1:rayon+1
            if (rayon==1)
                if(j>i)
                    b(i,j)=0;
                end
            else
                if(j>i+1)
                    b(i,j)=0;
                end
            end
        end
    end
    mask(1:rayon+1,rayon+1:2*rayon+1)=b;
    mask(1:rayon+1,1:rayon+1)=rot90(b);
    mask0=mask;
    mask0=flipdim(mask0,1);
    mask=mask0+mask;
    mask(rayon+1,:)=mask(rayon+1,:)-1;
    % =====================================================================
    max_reponse=sum(sum(mask));
    [n,m]=size(imd);
    % =================balayage de toute l'image==============
    f=zeros(n,m);
    for i=(rayon+1):n-rayon
        for j=(rayon+1):m-rayon
            image_courant=imd(i-rayon:i+rayon,j-rayon:j+rayon);
            image_courant_mask=image_courant.*mask;
            inteniste_cental= image_courant_mask(rayon+1,rayon+1);
            s=exp(-1*(((image_courant_mask-inteniste_cental)/max_reponse).^6));
            somme=sum(sum(s));
    % si le centre du mask est un 0 il faut soustraire les zeros des filtres
            if (inteniste_cental==0)
               somme=somme-length((find(mask==0)));
            end       
            f(i,j)=somme;           
         end
    end
% =============selection et seuillage des points d'inter�t=================
    ff=f(rayon+1:n-(rayon+1),rayon+1:m-(rayon+1));
    minf=min(min(ff));
    maxf=max(max(f));
    fff=f;
    d=2*r+1;
    temp1=round(n/d);
    if (temp1-n/d)<0.5 &(temp1-n/d)>0
        temp1=temp1-1;
    end
    temp2=round(m/d);
    if (temp2-m/d)<0.5 &(temp2-m/d)>0
        temp2=temp2-1;
    end
    fff(n:temp1*d+d,m:temp2*d+d)=0;
    sizefff=size(fff);
    for i=(r+1):d:temp1*d+d
        for j=(r+1):d:temp2*d+d
            window=fff(i-r:i+r,j-r:j+r);
            window0=window;
            [xx,yy]=find(window0==0);
            for k=1:length(xx)
                window0(xx(k),yy(k))=max(max(window0));
            end
            minwindow=min(min(window0));
            [y,x]=find(minwindow~=window & window<=minf+alpha*(maxf-minf) & window>0);
            [u,v]=find(minwindow==window);
            if length(u)>1
                for l=2:length(u) 
                    fff(i-r-1+u(l),j-r-1+v(l))=0   ;       
                end
            end
            if length(x)~=0
                for l=1:length(y) 
                    fff(i-r-1+y(l),j-r-1+x(l))=0   ;
                end
            end
        end
    end
    seuil=minf+alpha*(maxf-minf);
    [m,n]=size(imd);
    [x,y]=find(minf<=fff & fff<=seuil );
end          %===== fin switch
%********************  affichage des points d'interets ********************
nb=length(x);
set(get(h.hAxStatus,'title'),'string',['Nombre des points d''int�r�ts est : ' num2str(nb) ' Points']);
set(h.hAxImgCal, 'Xlim', [0 n], 'Ylim', [0 m]);
set(h.hImgCal, 'Xdata', [0 n], 'Ydata', [0 m]);
cla(h.hImgCal);
hold on
plot(y,x,'r.')
set(ImgFig,'Pointer','custom');
drawnow

%**************************************************************************
%% ========================================================================
%% ================  mise a joure les champs dentr�e ======================
%%=========================================================================
function EditBoxUpdate1(ChampEntree)
ImgFig = gcbf;
h=get(ImgFig,'Userdata');

switch ChampEntree
case 'HarrisSeuil'
   str = get(h.hHarrisSeuil, 'String');
   new = str2double(str);
   h.HarrisSeuil = real(new(1));
   set(h.hHarrisSeuil, 'String', num2str(h.HarrisSeuil));
case 'HarrisSigma'
   str = get(h.hHarrisSigma, 'String');
   new = str2double(str);
   h.HarrisSigma = real(new(1));
   set(h.hHarrisSigma, 'String', num2str(h.HarrisSigma));
case 'SusanSeuil'
   str = get(h.hSusanSeuil, 'String');
   new = str2double(str);
   h.SusanSeuil = real(new(1));
   set(h.hSusanSeuil, 'String', num2str(h.SusanSeuil));
case 'SusanRayon'
   str = get(h.hSusanRayon, 'String');
   new = str2double(str);
   h.SusanRayon = real(new(1));
   set(h.hSusanRayon, 'String', num2str(h.SusanRayon));
case 'HarAmeSeuil'
   str = get(h.hHarAmeSeuil, 'String');
   new = str2double(str);
   h.HarAmeSeuil = real(new(1));
   set(h.hHarAmeSeuil, 'String', num2str(h.HarAmeSeuil));
case 'HarAmeSigma'
   str = get(h.hHarAmeSigma, 'String');
   new = str2double(str);
   h.HarAmeSigma = real(new(1));
   set(h.hHarAmeSigma, 'String', num2str(h.HarAmeSigma));
case 'CssSeuil'
   str = get(h.hCssSeuil, 'String');
   new = str2double(str);
   h.CssSeuil = real(new(1));
   set(h.hCssSeuil, 'String', num2str(h.CssSeuil));
case 'CssSigma'
   str = get(h.hCssSigma, 'String');
   new = str2double(str);
   h.CssSigma = real(new(1));
   set(h.hCssSigma, 'String', num2str(h.CssSigma));
end
set(get(h.hAxStatus,'title'),'string',['Appuyer sur ''Appliquer''']);
set(h.hBtnAppliquer, 'Enable', 'on');
set(ImgFig,'Userdata',h);
return;

%==========================================================================

function EditBoxUpdate2(ChampEntree)
ImgFig = gcbf;
h=get(ImgFig,'Userdata');

switch ChampEntree
case 'SpeckleVariance'
   str = get(h.hSpeckleVariance, 'String');
   new = str2double(str);
   h.SpeckleVariance = real(new(1));
   set(h.hSpeckleVariance, 'String', num2str(h.SpeckleVariance));
case 'SelPoivreDensite'
   str = get(h.hSelPoivreDensite, 'String');
   new = str2double(str);
   h.SelPoivreDensite = real(new(1));
   set(h.hSelPoivreDensite, 'String', num2str(h.SelPoivreDensite));
case 'VarianceGaussian'
   str = get(h.hVarianceGaussian, 'String');
   new = str2double(str);
   h.VarianceGaussian = real(new(1));
   set(h.hVarianceGaussian, 'String', num2str(h.VarianceGaussian))
case 'MoyenneGaussian'
   str = get(h.hMoyenneGaussian, 'String');
   new = str2double(str);
   h.MoyenneGaussian = real(new(1));
   set(h.hMoyenneGaussian, 'String', num2str(h.MoyenneGaussian))
end
set(h.hBtnAjouter, 'Enable', 'on');
set(get(h.hAxStatus,'title'),'string',['Appuyer sur ''Ajouter Bruit''']);
set(ImgFig,'Userdata',h);
return;

%% ========================================================================
%% ====================  mise a jours le type de detecteur ================
%%=========================================================================
function UpdateDetecteur(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h=get(ImgFig,'Userdata');
set(h.hBtnAppliquer,'Enable','on');
set(get(h.hAxStatus,'title'),'string',['Appuyer sur ''Appliquer''']);
v = get(h.hPopMethode,{'value','String'});
methode = deblank(v{2}(v{1},:));

set(h.TextePara,'String',['Param�tres du d�tecteur de ',methode,' :']);
drawnow
switch methode
case 'Harris'
   MettreHarrisControls(ImgFig);
case 'Susan'
   MettreSusanControls(ImgFig);
case 'Mod�le El�ctrostatique'
   MettreHarAmeControls(ImgFig);
case 'CSS'
   MettreCssControls(ImgFig);
end
return
%/*************************************************************************
%% ========================================================================
%% ==============  mettre les controles de harris =========================
%%=========================================================================
function MettreHarrisControls(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h = get(ImgFig,'Userdata');
% Detecteur de Harris
set([h.hHarrisSeuil h.hTxtHarrisSeuil ...
    h.hHarrisSigma h.hTxtHarrisSigma], ...
   'Enable', 'on', 'visible', 'on');
% Detecteur de Susan
set([h.hSusanSeuil h.hTxtSusanSeuil ...
    h.hSusanRayon h.hTxtSusanRayon], ...
   'Enable', 'off', 'visible', 'off');
% Detecteur de Harris Am�lior�
set([h.hHarAmeSeuil h.hTxtHarAmeSeuil ...
    h.hHarAmeSigma h.hTxtHarAmeSigma],...
    'Enable', 'off', 'visible', 'off');
% Detecteur de CSS
set([h.hCssSeuil h.hTxtCssSeuil ...
    h.hCssSigma h.hTxtCssSigma],...
    'Enable', 'off', 'visible', 'off');
return
%/*************************************************************************
%% ========================================================================
%% ===============  mettre les controles de susan =========================
%%=========================================================================
function MettreSusanControls(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h = get(ImgFig,'Userdata');
% Detecteur de Harris
set([h.hHarrisSeuil h.hTxtHarrisSeuil ...
    h.hHarrisSigma h.hTxtHarrisSigma], ...
   'Enable', 'off', 'visible', 'off');
% Detecteur de Susan
set([h.hSusanSeuil h.hTxtSusanSeuil ...
    h.hSusanRayon h.hTxtSusanRayon], ...
   'Enable', 'on', 'visible', 'on');
% Detecteur de Harris Am�lior�
set([h.hHarAmeSeuil h.hTxtHarAmeSeuil ...
    h.hHarAmeSigma h.hTxtHarAmeSigma],...
    'Enable', 'off', 'visible', 'off');
% Detecteur de CSS
set([h.hCssSeuil h.hTxtCssSeuil ...
    h.hCssSigma h.hTxtCssSigma],...
    'Enable', 'off', 'visible', 'off');
return
%/*************************************************************************
%% ========================================================================
%% ==========  mettre les controles de Harris Amelior� =====================
%%=========================================================================
function MettreHarAmeControls(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h = get(ImgFig,'Userdata');
% Detecteur de Harris
set([h.hHarrisSeuil h.hTxtHarrisSeuil ...
    h.hHarrisSigma h.hTxtHarrisSigma], ...
   'Enable', 'off', 'visible', 'off');
% Detecteur de Susan
set([h.hSusanSeuil h.hTxtSusanSeuil ...
    h.hSusanRayon h.hTxtSusanRayon], ...
   'Enable', 'off', 'visible', 'off');
% Detecteur de Harris Am�lior�
set([h.hHarAmeSeuil h.hTxtHarAmeSeuil ...
    h.hHarAmeSigma h.hTxtHarAmeSigma],...
    'Enable', 'on', 'visible', 'on');
% Detecteur de CSS
set([h.hCssSeuil h.hTxtCssSeuil ...
    h.hCssSigma h.hTxtCssSigma],...
    'Enable', 'off', 'visible', 'off');
return
%/*************************************************************************
%% ========================================================================
%% ==========  mettre les controles de CSS ================================
%%=========================================================================
function MettreCssControls(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h = get(ImgFig,'Userdata');
% Detecteur de Harris
set([h.hHarrisSeuil h.hTxtHarrisSeuil ...
    h.hHarrisSigma h.hTxtHarrisSigma], ...
   'Enable', 'off', 'visible', 'off');
% Detecteur de Susan
set([h.hSusanSeuil h.hTxtSusanSeuil ...
    h.hSusanRayon h.hTxtSusanRayon], ...
   'Enable', 'off', 'visible', 'off');
% Detecteur de Harris Am�lior�
set([h.hCssSeuil h.hTxtCssSeuil ...
    h.hCssSigma h.hTxtCssSigma],...
    'Enable', 'off', 'visible', 'off');
% Detecteur de CSS
set([h.hCssSeuil h.hTxtCssSeuil ...
    h.hCssSigma h.hTxtCssSigma],...
    'Enable', 'on', 'visible', 'on');
return
%/*************************************************************************
%% ========================================================================
%% ============================= Ajouter Bruit ============================
%%=========================================================================
function AjouterBruit(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h=get(ImgFig,'Userdata');
set(ImgFig,'Pointer','watch');

set(h.hBtnAjouter,'Enable','off');
v = get(h.hPopBruit,{'value','String'});
bruit = deblank(v{2}(v{1},:));
orig = getimage(h.hImgOri);

switch bruit
case 'Sel & Poivre'
   bruite = imnoise(orig, 'salt & pepper', h.SelPoivreDensite);
case 'Gaussien'
   bruite = imnoise(orig, 'gaussian', h.MoyenneGaussian, h.VarianceGaussian);
case 'Speckle'
   bruite = imnoise(orig, 'speckle', h.SpeckleVariance);
end

set(h.hImgCal, 'Cdata', bruite);
set(ImgFig,'Pointer','custom');
set(get(h.hAxStatus,'title'),'string',['Appuyer "Appliquer"']);
set(ImgFig, 'UserData', h);
set(h.hBtnAppliquer,'Enable','on');
cla(h.hImgCal);
drawnow
return;

%% ========================================================================
%% ====================  mise a jours le type de bruit ====================
%%=========================================================================
function UpdateTypeBruit(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h=get(ImgFig,'Userdata');
set(h.hBtnAjouter,'Enable','on');
v = get(h.hPopBruit,{'value','String'});
bruit = deblank(v{2}(v{1},:));

drawnow
switch bruit
case 'Gaussien'
   MettreGaussienControls(ImgFig);
case 'Sel & Poivre'
   MettreSelControls(ImgFig);
case 'Speckle'
   MettreSpeckleControls(ImgFig);
end
return
%/*************************************************************************
%% ========================================================================
%% ==============  mettre les controles de bruit gaussien =================
%%=========================================================================
function MettreGaussienControls(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h = get(ImgFig,'Userdata');
% bruit gaussien
set([h.hMoyenneGaussian h.hTxtMoyenneGaussian ...
    h.hVarianceGaussian h.hTxtVarianceGaussian], ...
   'Enable', 'on', 'visible', 'on');
% bruit sel & poivre
set([h.hSelPoivreDensite h.hTxtSelPoivreDensite], ...
   'Enable', 'off', 'visible', 'off');
% bruit speckle
set([h.hSpeckleVariance h.hTxtSpeckleVariance],...
    'Enable', 'off', 'visible', 'off');
return

%/*************************************************************************
%% ========================================================================
%% ==============  mettre les controles de bruit sel & poivre =============
%%=========================================================================
function MettreSelControls(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h = get(ImgFig,'Userdata');
% bruit gaussien
set([h.hMoyenneGaussian h.hTxtMoyenneGaussian ...
    h.hVarianceGaussian h.hTxtVarianceGaussian], ...
   'Enable', 'off', 'visible', 'off');
% bruit sel & poivre
set([h.hSelPoivreDensite h.hTxtSelPoivreDensite], ...
   'Enable', 'on', 'visible', 'on');
% bruit speckle
set([h.hSpeckleVariance h.hTxtSpeckleVariance],...
    'Enable', 'off', 'visible', 'off');
return

%/*************************************************************************
%% ========================================================================
%% ==============  mettre les controles de bruit speckle ==================
%%=========================================================================
function MettreSpeckleControls(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h = get(ImgFig,'Userdata');
% bruit gaussien
set([h.hMoyenneGaussian h.hTxtMoyenneGaussian ...
    h.hVarianceGaussian h.hTxtVarianceGaussian], ...
   'Enable', 'off', 'visible', 'off');
% bruit sel & poivre
set([h.hSelPoivreDensite h.hTxtSelPoivreDensite], ...
   'Enable', 'off', 'visible', 'off');
% bruit speckle
set([h.hSpeckleVariance h.hTxtSpeckleVariance],...
    'Enable', 'on', 'visible', 'on');
return

%/*************************************************************************
%% ========================================================================
%% ==============  activer le bruit =======================================
%%=========================================================================
function ActiverBruit(ImgFig)
if nargin<1
   ImgFig = gcbf;
end
h = get(ImgFig,'Userdata');
var = (get(h.hAjouterBruit, 'Value') == 1);
if var
    set([h.hPopBruit h.hMoyenneGaussian h.hTxtMoyenneGaussian ...
    h.hVarianceGaussian h.hTxtVarianceGaussian ...
    h.hSelPoivreDensite h.hTxtSelPoivreDensite ...
    h.hSpeckleVariance h.hTxtSpeckleVariance h.hBtnAjouter], ...
   'Enable', 'on');
else
    set([h.hPopBruit h.hMoyenneGaussian h.hTxtMoyenneGaussian ...
    h.hVarianceGaussian h.hTxtVarianceGaussian ...
    h.hSelPoivreDensite h.hTxtSelPoivreDensite ...
    h.hSpeckleVariance h.hTxtSpeckleVariance h.hBtnAjouter], ...
   'Enable', 'off');
    imag=getimage(h.hImgOri);
    cla(h.hImgCal);
    set(h.hImgCal, 'Cdata', imag);
    set(h.hBtnAppliquer,'Enable','on');
end

return

%/*************************************************************************
%% ========================================================================
%% ================= les fonctions associes a la methode de css ===========
%%=========================================================================

function [curve,curve_start,curve_end,curve_mode,cur_num]=extract_curve(BW,Gap_size)

%   Function to extract curves from binary edge map, if the endpoint of a
%   contour is nearly connected to another endpoint, fill the gap and continue
%   the extraction. The default gap size is 1 pixles.

[L,W]=size(BW);
BW1=zeros(L+2*Gap_size,W+2*Gap_size);
BW_edge=zeros(L,W);
BW1(Gap_size+1:Gap_size+L,Gap_size+1:Gap_size+W)=BW;
[r,c]=find(BW1==1);
cur_num=0;

while size(r,1)>0
    point=[r(1),c(1)];
    cur=point;
    BW1(point(1),point(2))=0;
    [I,J]=find(BW1(point(1)-Gap_size:point(1)+Gap_size,point(2)-Gap_size:point(2)+Gap_size)==1);
    while size(I,1)>0
        dist=(I-Gap_size-1).^2+(J-Gap_size-1).^2;
        [min_dist,index]=min(dist);
        point=point+[I(index),J(index)]-Gap_size-1;
        cur=[cur;point];
        BW1(point(1),point(2))=0;
        [I,J]=find(BW1(point(1)-Gap_size:point(1)+Gap_size,point(2)-Gap_size:point(2)+Gap_size)==1);
    end
    
    % Extract edge towards another direction
    point=[r(1),c(1)];
    BW1(point(1),point(2))=0;
    [I,J]=find(BW1(point(1)-Gap_size:point(1)+Gap_size,point(2)-Gap_size:point(2)+Gap_size)==1);
    while size(I,1)>0
        dist=(I-Gap_size-1).^2+(J-Gap_size-1).^2;
        [min_dist,index]=min(dist);
        point=point+[I(index),J(index)]-Gap_size-1;
        cur=[point;cur];
        BW1(point(1),point(2))=0;
        [I,J]=find(BW1(point(1)-Gap_size:point(1)+Gap_size,point(2)-Gap_size:point(2)+Gap_size)==1);
    end
        
    if size(cur,1)>(size(BW,1)+size(BW,2))/25
        cur_num=cur_num+1;
        curve{cur_num}=cur-Gap_size;
    end
    [r,c]=find(BW1==1);
    
end

for i=1:cur_num
    curve_start(i,:)=curve{i}(1,:);
    curve_end(i,:)=curve{i}(size(curve{i},1),:);
    if (curve_start(i,1)-curve_end(i,1))^2+(curve_start(i,2)-curve_end(i,2))^2<=32
        curve_mode(i,:)='loop';
    else
        curve_mode(i,:)='line';
    end
    
    BW_edge(curve{i}(:,1)+(curve{i}(:,2)-1)*L)=1;
end
return

function cout=get_corner(curve,curve_start,curve_end,curve_mode,curve_num,BW,sigma,Endpoint,C,T_angle)

corner_num=0;
cout=[];

GaussianDieOff = .0001; 
pw = 1:30; 
ssq = sigma*sigma;
width = max(find(exp(-(pw.*pw)/(2*ssq))>GaussianDieOff));
if isempty(width)
    width = 1;  
end
t = (-width:width);
gau = exp(-(t.*t)/(2*ssq))/(2*pi*ssq); 
gau=gau/sum(gau);

for i=1:curve_num;
    x=curve{i}(:,1);
    y=curve{i}(:,2);
    W=width;
    L=size(x,1);
    if L>W
        
        % Calculate curvature
        if curve_mode(i,:)=='loop'
            x1=[x(L-W+1:L);x;x(1:W)];
            y1=[y(L-W+1:L);y;y(1:W)];
        else
            x1=[ones(W,1)*2*x(1)-x(W+1:-1:2);x;ones(W,1)*2*x(L)-x(L-1:-1:L-W)];
            y1=[ones(W,1)*2*y(1)-y(W+1:-1:2);y;ones(W,1)*2*y(L)-y(L-1:-1:L-W)];
        end
       
        xx=conv(x1,gau);
        xx=xx(W+1:L+3*W);
        yy=conv(y1,gau);
        yy=yy(W+1:L+3*W);
        Xu=[xx(2)-xx(1) ; (xx(3:L+2*W)-xx(1:L+2*W-2))/2 ; xx(L+2*W)-xx(L+2*W-1)];
        Yu=[yy(2)-yy(1) ; (yy(3:L+2*W)-yy(1:L+2*W-2))/2 ; yy(L+2*W)-yy(L+2*W-1)];
        Xuu=[Xu(2)-Xu(1) ; (Xu(3:L+2*W)-Xu(1:L+2*W-2))/2 ; Xu(L+2*W)-Xu(L+2*W-1)];
        Yuu=[Yu(2)-Yu(1) ; (Yu(3:L+2*W)-Yu(1:L+2*W-2))/2 ; Yu(L+2*W)-Yu(L+2*W-1)];
        K=abs((Xu.*Yuu-Xuu.*Yu)./((Xu.*Xu+Yu.*Yu).^1.5));
        K=ceil(K*100)/100;
               
        % Find curvature local maxima as corner candidates
        extremum=[];
        N=size(K,1);
        n=0;
        Search=1;
        
        for j=1:N-1
            if (K(j+1)-K(j))*Search>0
                n=n+1;
                extremum(n)=j;  % In extremum, odd points is minima and even points is maxima
                Search=-Search;
            end
        end
        if mod(size(extremum,2),2)==0
            n=n+1;
            extremum(n)=N;
        end
    
        n=size(extremum,2);
        flag=ones(size(extremum));
  
        % Compare with adaptive local threshold to remove round corners
        for j=2:2:n
            %I=find(K(extremum(j-1):extremum(j+1))==max(K(extremum(j-1):extremum(j+1))));
            %extremum(j)=extremum(j-1)+round(mean(I))-1; % Regard middle point of plateaus as maxima
            
            [x,index1]=min(K(extremum(j):-1:extremum(j-1)));
            [x,index2]=min(K(extremum(j):extremum(j+1)));
            ROS=K(extremum(j)-index1+1:extremum(j)+index2-1);
            K_thre(j)=C*mean(ROS);
            if K(extremum(j))<K_thre(j)
                flag(j)=0;
            end
        end
        extremum=extremum(2:2:n);
        flag=flag(2:2:n);
        extremum=extremum(find(flag==1));
        
        % Check corner angle to remove false corners due to boundary noise and trivial details
        flag=0;
        smoothed_curve=[xx,yy];
        while sum(flag==0)>0
            n=size(extremum,2);
            flag=ones(size(extremum)); 
            for j=1:n
                if j==1 & j==n
                    ang=curve_tangent(smoothed_curve(1:L+2*W,:),extremum(j));
                elseif j==1 
                    ang=curve_tangent(smoothed_curve(1:extremum(j+1),:),extremum(j));
                elseif j==n
                    ang=curve_tangent(smoothed_curve(extremum(j-1):L+2*W,:),extremum(j)-extremum(j-1)+1);
                else
                    ang=curve_tangent(smoothed_curve(extremum(j-1):extremum(j+1),:),extremum(j)-extremum(j-1)+1);
                end     
                if ang>T_angle & ang<(360-T_angle)
                    flag(j)=0;  
                end
            end
             
            if size(extremum,2)==0
                extremum=[];
            else
                extremum=extremum(find(flag~=0));
            end
        end
            
        extremum=extremum-W;
        extremum=extremum(find(extremum>0 & extremum<=L));
        n=size(extremum,2);     
        for j=1:n     
            corner_num=corner_num+1;
            cout(corner_num,:)=curve{i}(extremum(j),:);
        end
    end
end


% Add Endpoints
if Endpoint
    for i=1:curve_num
        if size(curve{i},1)>0 & curve_mode(i,:)=='line'
            
            % Start point compare with detected corners
            compare_corner=cout-ones(size(cout,1),1)*curve_start(i,:);
            compare_corner=compare_corner.^2;
            compare_corner=compare_corner(:,1)+compare_corner(:,2);
            if min(compare_corner)>25       % Add end points far from detected corners 
                corner_num=corner_num+1;
                cout(corner_num,:)=curve_start(i,:);
            end
            
            % End point compare with detected corners
            compare_corner=cout-ones(size(cout,1),1)*curve_end(i,:);
            compare_corner=compare_corner.^2;
            compare_corner=compare_corner(:,1)+compare_corner(:,2);
            if min(compare_corner)>25
                corner_num=corner_num+1;
                cout(corner_num,:)=curve_end(i,:);
            end
        end
    end
end
return

function ang=curve_tangent(cur,center)

for i=1:2
    if i==1
        curve=cur(center:-1:1,:);
    else
        curve=cur(center:size(cur,1),:);
    end
    L=size(curve,1);
    
    if L>3
        if sum(curve(1,:)~=curve(L,:))~=0
            M=ceil(L/2);
            x1=curve(1,1);
            y1=curve(1,2);
            x2=curve(M,1);
            y2=curve(M,2);
            x3=curve(L,1);
            y3=curve(L,2);
        else
            M1=ceil(L/3);
            M2=ceil(2*L/3);
            x1=curve(1,1);
            y1=curve(1,2);
            x2=curve(M1,1);
            y2=curve(M1,2);
            x3=curve(M2,1);
            y3=curve(M2,2);
        end
        
        if abs((x1-x2)*(y1-y3)-(x1-x3)*(y1-y2))<1e-8  % straight line
            tangent_direction=angle(complex(curve(L,1)-curve(1,1),curve(L,2)-curve(1,2)));
        else
            % Fit a circle 
            x0 = 1/2*(-y1*x2^2+y3*x2^2-y3*y1^2-y3*x1^2-y2*y3^2+x3^2*y1+y2*y1^2-y2*x3^2-y2^2*y1+y2*x1^2+y3^2*y1+y2^2*y3)/(-y1*x2+y1*x3+y3*x2+x1*y2-x1*y3-x3*y2);
            y0 = -1/2*(x1^2*x2-x1^2*x3+y1^2*x2-y1^2*x3+x1*x3^2-x1*x2^2-x3^2*x2-y3^2*x2+x3*y2^2+x1*y3^2-x1*y2^2+x3*x2^2)/(-y1*x2+y1*x3+y3*x2+x1*y2-x1*y3-x3*y2);
            % R = (x0-x1)^2+(y0-y1)^2;

            radius_direction=angle(complex(x0-x1,y0-y1));
            adjacent_direction=angle(complex(x2-x1,y2-y1));
            tangent_direction=sign(sin(adjacent_direction-radius_direction))*pi/2+radius_direction;
        end
    
    else % very short line
        tangent_direction=angle(complex(curve(L,1)-curve(1,1),curve(L,2)-curve(1,2)));
    end
    direction(i)=tangent_direction*180/pi;
end
ang=abs(direction(1)-direction(2));
return