function  ajouter_bruit(I)
global checkBruit popupMethodebruit baravancM baravancV baravancD
global axe2 axe1 editSeuille MenuMethodedetect

a=get(checkBruit,'value');

if a 
 
    num_bruit = get(popupMethodebruit, 'Value');

    if num_bruit==1
        m=get(baravancM,'Value');
        v=get(baravancV,'Value');
        J=imnoise(I,'gaussian',m,v); 
    end  

    if num_bruit==2
        d=get(baravancD,'Value');
        J=imnoise(I,'Salt & Pepper',d); 
    end
    if num_bruit==3
       v=get(baravancD,'Value');
       J=imnoise(I,'Speckle',v);     
    end
    set(axe1,'HandleVisibility','ON');
    axes(axe1);
    image(J);
    % axis equal;
    axis tight;
    axis off;

    det = get(MenuMethodedetect, 'value');

     if det==1
            str=get(editSeuille,'String');
            thresh=Str2num(char(str));
            harris(J,thresh);

     end
     if det==2
            str=get(editSeuille,'String');
            thresh=Str2num(char(str));
            susan(J,thresh);

     end
end 