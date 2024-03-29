clc;
clear
load VPNNH_Citylist;
load VPNclassCity;

[X,map] = imread('H:\文件\论文2\Data\Beck_KG_V1\Beck_KG_V1_present_0p083.tif');
info = geotiffinfo('H:\文件\论文2\Data\Beck_KG_V1\Beck_KG_V1_present_0p083.tif');
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

%%
Input1 = importdata('H:\文件\论文2\Data\Result\NH_citylocation.xls');
CityInfo = Input1.data;
pointInput = importdata('H:\文件\论文2\Data\Result\1026_pheno_ISA.xlsx');
NH = pointInput.data.Sheet3;
[m,n0,N1] = intersect(NH(:,1),VPNNH_Citylist(:,1));
VPNCitymatchKC = zeros(length(CityInfo(:,1)),6);
VPNCitymatchKC(:,1) = NH(:,1);
VPNCitymatchKC(:,2) = VPNNH_Citylist(N1,7);
VPNCitymatchKC(:,3) = VPNNH_Citylist(N1,6);
VPNCitymatchKC(:,5) = NH(:,4);
typeNum = [3 5 7 10 13 16 20 24 28];

%%
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
