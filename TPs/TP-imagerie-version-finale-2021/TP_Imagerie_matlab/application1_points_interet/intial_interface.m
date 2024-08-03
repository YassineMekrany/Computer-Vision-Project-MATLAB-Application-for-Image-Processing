function intial_interface
global axe1 editSeuille axe3

i=imread('Chaise.jpg');
set(axe1,'HandleVisibility','on');
axes(axe1);
image(i);
axis tight;
axis off;

%================================================================

str=get(editSeuille,'String');
th=Str2num(char(str));
harris(i,th);

%================================================================

t=10:30;
Harris_SB=[120 109 96 87 82 77 74 74 72 71 68 65 61 55 54 53 50 47 45 43 42];
Harris_AB=[1884  1624  1386  1168  1005  849  726 615  533  476 402 343 317 294 266  233  211  195 178  164  150];
set(axe3,'HandleVisibility','ON');
axes(axe3);
plot(t,Harris_SB,'b-*');hold all ,plot(t,Harris_AB,'r-*');legend('sans bruit','avec bruit',1);;set(axe3,'color',[0.9 0.9 0.8]);  
% tracer;