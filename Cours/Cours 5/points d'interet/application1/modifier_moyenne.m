function modifier_moyenne
global baravancM edittext1
    m=get(baravancM,'Value');
    moy=num2str(m);
    set(edittext1,'String',moy);
    
    
    
    