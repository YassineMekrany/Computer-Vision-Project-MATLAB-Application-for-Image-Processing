function moins_seuille
% pour decrementer seuil
global editSeuille startMoins startPlus

str=get(editSeuille,'String');
a=Str2num(char(str));
a=a-1;
st=num2str(a);
set(editSeuille,'String',st);

    if a==10 
        set(startMoins,'enable','off');
    else 
        set(startPlus,'enable','on');
    end