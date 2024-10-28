clc;
clear
load VPNNH_Citylist;
load classCity;

[X,map] = imread('Beck_KG_V1_present_0p083.tif');
info = geotiffinfo('Beck_KG_V1_present_0p083.tif');
[x,y] = pix2latlon(info.RefMatrix, 1, 2); 
R = info.RefMatrix;
row=2160;col=4320;
lat = zeros(row,1);
lon = zeros(col,1);
for i = 1:row
    for j = 1:col
      [lat1,lon1]=pix2latlon(info.RefMatrix,i,j);  
      lat(i,1) = lat1;
      lon(j,1) = lon1;
    end
end

[x1,y1] = meshgrid(lon,lat);


NH(:,1) = classCity(:,1);
[m,n0,N1] = intersect(NH(:,1),VPNNH_Citylist(:,1));
VPNCitymatchKC = zeros(length(NH(:,1)),6);
VPNCitymatchKC(:,1) = NH(:,1);
VPNCitymatchKC(:,2) = VPNNH_Citylist(N1,7);
VPNCitymatchKC(:,3) = VPNNH_Citylist(N1,6);
VPNCitymatchKC(:,5) = classCity(:,4);
typeNum = [3 5 7 10 13 16 20 24 28];


%find the nearest cell and define the Koppen climate
Y(:,:) = VPNCitymatchKC(:,2:3);
x0 = reshape(x1,row*col,1);
y0 = reshape(y1,row*col,1);
ClassX = reshape(X,row*col,1);
Grid = [y0 x0];
[cIdx,cD] = knnsearch(Grid,Y,'Distance','chebychev');
McX = x0(cIdx,1);
McY = y0(cIdx,1);

VPNCitymatchKC(:,4) = ClassX(cIdx,1);
VPNCitymatchKC(find(VPNCitymatchKC(:,1)==7913),4) = 21;


for i = 1:length(typeNum)-1
    a = typeNum(1,i);
    b = typeNum(1,i+1);
    [mk,nk] = find(VPNCitymatchKC(:,4)>a & VPNCitymatchKC(:,4) <= b);
    VPNCitymatchKC(mk,6) = i;
end

save VPNCitymatchKC VPNCitymatchKC;

%%
    figure(1)
   clf
color = [
    [64 3 126]
    [91 53 149]
    [121 111 179]
    [197 197 224]
    [251 227 213]
    [246 178 147]
    [220 109 87]
    [183 34 48]
    [109 1 31]
    ]./255;

str = {'BW','BS','Cs','Cw','Cf','Ds','Dw','Df'};
B = zeros(1,8);
for i = 1:8
    cc(:) = color(i,:);
    [m0,n0] = find(VPNCitymatchKC(:,6)==i);
         B(i,j) = length(m0);
end

  xx2 = (1:1:8);
  B1(:,:) = B(:,1:8);
  B2 = sum(B1,1);
   b = bar(xx2,B1,0.8);
   hold on


   for i = 1:4
       b(i).FaceColor =  color(i*2,:);
   end
set(gca,'XTicklabels',str,'FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');

