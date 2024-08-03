function tracer
global  axe3
clc
j=1;
 A=imread('PlancheARepasser.jpg'); % image sans bruit.
 B=imnoise(A,'gaussian',0,0.005); % image avec bruit
t=10:30;
   for i=10:30 
    [x1,y1] = susan1(A,i);
    [x2,y2] = susan1(B,i);
    NB_point = size([x1 y1]);
    NB_points = size([x2 y2]);
    T1(j)=NB_point(1);
    T2(j)=NB_points(1);
    j=j+1;
   end
   sansbruit=T1
   avecbruit=T2
set(axe3,'HandleVisibility','ON');
axes(axe3);
plot(t,T1,'b-*');hold on ,plot(t,T2,'r-*');
%=================== harris ======================================    
%  ChaiseS=[120 109 96 87 82 77 74 74 72 71 68 65 61 55 54 53 50 47 45 43 42];
%  ChaiseA=[1884  1624  1386  1168  1005  849  726 615  533  476 402 343 317 294 266  233  211  195 178  164  150]

%  TournevisS=[85 78 76 73 71 69 69 67 64 62 62 61 60 58  56 55 55  54 54 53 53];
%  TournevisA=[1752 1462  1189  967  795 664 564 472 418 371 322 297 272 236 210 180 162 142 136 125 118];

%  ArrosoireS=[16 15 13 9 9 8 6 5 5 5 5 5 5 5 5 5 5 5 5 5 5];
%  ArrosoireA=[1709 1351 1088 844 673 563 467 391 331 288 254 218 194 161 141 125 112  93 79 67 58];

%  CompasS=[89 88 87 85 84 83 83 81 80 80 75 75 73 70 68 68 67 66 65 65 64];
%  CompasA=[1368 1067 828 634 503 411 335 277 250 217 194 177 162 157 146 139 132 125 120 115 113];

%  VRRoom_LampeS=[40 35 30 29 29 28 26 24 23 23 23 21 17 17 17 17 15 15 15 15 14];
%  VRRoom_LampeA=[1459 1133 889 713 562 449 377 322 269 230 200 179 158 137 125 111 101 90 84 70 64];

%  TasseS=[43 32 23 17 14 13 11 7 6 6 6 5 4 4 3 3 3 2 1 1 1];
%  TasseA=[2475 2046 1693 1389 1108 893 711 580 470 392 324 265 228 197 161 146 122 106 95 82 71];

%  PlancheARepasserS=[90 80 74 64 64 64 61 57 55 54 52 51 51 51 51 49 48 46 45 44 43];
%  PlancheARepasserA=[1529 1277 1099 921 767 658 569 496 431 390 342 316 289 264 242 219 205 183 172 159 146];

%=================== susan =======================================

% ChaiseS=[801 692 556 487 451 389 370 318 298 279 259 235 210 194 176 155 147 127 119 112 101];
%  ChaiseA=[1678 1869 1666 1702 1755 1590 1713 1512 1483 1492 1401 1366 1356 1226 1201 1165 1073 1045 1011 938 872]

%  TournevisS=[416 388 304 282 261 225 213 203 186 183 170 162 155 143 134 132 118 120 123 113 105];
%  TournevisA=[1595 1717 1527 1500 1547 1323 1346 1153 1121 1065 1001 1000 994 880 854 811 726 703 670 613 577];

%  ArrosoireS=[189 171 130 106 98 75 60 44 33 26 25 19 13 14 16 14 13 12 11 8 7];
%  ArrosoireA=[1918 1993 1732 1684 1668 1418 1371 1186 1131 1112 1060 993 958 845 800 736 643 591 583 511 448];

%  CompasS=[525 508 453 438 429 403 397 362 332 316 301 298 298 281 273 256 237 222 217 206 198];
%  CompasA=[1620 1689 1450 1427 1428 1231 1217 1046 1033 979 886 830 809 751 741 698 647 642 622 587 556];

%  VRRoom_LampeS=[265 221 184 159 146 123 108 92 81 81 68 63 61 54 45 46 40 41 40 37 34];
%  VRRoom_LampeA=[1599  1652 1457 1406 1387 1208 1143 965  933 916 851 784 719 632 614 570 516 490 463 409 378];

%  TasseS=[937 787 569 461 407 308 261 190 164 145 120 100 87 71 49 36 26 22 23 24 23];
%  TasseA=[2219 2344 2143 2157 2134 1861 1722 1489 1482 1437 1337 1216 1135 1009 971 911 810 759  701 600 548];

%  PlancheARepasserS=[692 635 557 524 504 456 452 391 361 334 320 295 283 260 234 211 185 175 165 146 138];
%  PlancheARepasserA=[1581 1681 1549 1545 1562 1435 1456 1265 1302 1296 1211 1171 1179 1094 1095 1060 999 969 961 895 861];

