function plus_seuille
% pour incrementer seuil
global editSeuille startPlus startMoins

str=get(editSeuille,'String');
a=Str2num(char(str));
a=a+1;
st=num2str(a);
set(editSeuille,'String',st);

    if a==30 
        set(startPlus,'enable','off');
    else 
        set(startMoins,'enable','on');
    end