clc;
clear

% load VPNNH_slope_rank;
load VPNNH_Citylist;
load VPNCitylist_All;
load VPNNH_sos_slope;
load VPNNH_eos_slope;
load VPNNH_sos_LST_slope;
load VPNNH_eos_LST_slope;
load VPNNH_ALAN_slope_SOS;
load VPNNH_ALAN_slope_EOS;

% nh_city(:,1) = VPNNH_slope_rank;
nh_city(:,1) = 60310;
[M,N,n1] = intersect(nh_city,VPNAllcity(:,1));
% [M,N] = find(VPNAllcity(:,8)>=1);%1=US,2=Europe,3=Asia
gl_city(:,1) = VPNAllcity(n1,1);
TempAllCity = VPNAllcity(n1,:);
% 
% [m0,n0,N0] = intersect(nh_city,gl_city);
% ALAN_SOS = VPNNH_ALAN_slope_SOS(n0,:,3);
% LST_SOS = VPNNH_sos_LST_slope(n0,:,3);
% PHENO_SOS = VPNNH_sos_slope(n0,:,3);%(city,year,layer)
% ALAN_EOS = VPNNH_ALAN_slope_EOS(n0,:,3);
% LST_EOS = VPNNH_eos_LST_slope(n0,:,3);
% PHENO_EOS = VPNNH_eos_slope(n0,:,3);%(city,year,layer)

ALAN_SOS = VPNNH_ALAN_slope_SOS;
T_SOS = VPNNH_sos_T_slope;
PHENO_SOS = VPNNH_sos_slope;%(city,year,layer)
ALAN_EOS = VPNNH_ALAN_slope_EOS;
T_EOS = VPNNH_eos_T_slope;
PHENO_EOS = VPNNH_eos_slope;%(city,year,layer)
Len = length(PHENO_SOS(:,1,:));
std(1,1) = nanstd(PHENO_SOS,[],'all')./sqrt(length(PHENO_SOS(:,1,:))*7);
std(1,3) = nanstd(ALAN_SOS,[],'all')./sqrt(Len*7);
std(1,5) = nanstd(T_SOS,[],'all')./sqrt(Len*7);
std(1,2) = nanstd(PHENO_EOS,[],'all')./sqrt(Len*7);
std(1,4) = nanstd(ALAN_EOS,[],'all')./sqrt(Len*7);
std(1,6) = nanstd(T_EOS,[],'all')./sqrt(Len*7);



latlim = [30 90];
lonlim = [-180 180];

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
%%
figure(1)
clf
ax = worldmap(latlim,lonlim);
% ax = worldmap('Asia');
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land,'FaceColor',[0.95,0.95,0.95]);

mlabel off
plabel off

Z1 = nanmean(PHENO_SOS.*(-1),2);
lon = TempAllCity(1,6);
lat = TempAllCity(1,7);

sc1 = scatterm(lat,lon,60,Z1,'filled','MarkerEdgeColor','k');
cm = colormap(gca,color(1:8,:));
j1 = colorbar;
set(j1,'YTick',-20:5:20);
j1.Label.String = 'ΔSOS (days)';
caxis([-20 20]);
set(gca,'FontName','Arial','FontSize',40,'LineWidth',1.5,'FontWeight','bold');

figure(2)
clf
ax = worldmap(latlim,lonlim);
% ax = worldmap('Asia');
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land,'FaceColor',[0.95,0.95,0.95]);

mlabel off
plabel off

Z2 = nanmean(PHENO_EOS.*(-1),2);


sc1 = scatterm(lat,lon,60,Z2,'filled','MarkerEdgeColor','k');
cm = colormap(gca,color(1:8,:));
j1 = colorbar;
set(j1,'YTick',-20:5:20);
j1.Label.String = 'ΔEOS (days)';
caxis([-20 20]);
set(gca,'FontName','Arial','FontSize',40,'LineWidth',1.5,'FontWeight','bold');

figure(3)
clf
ax = worldmap(latlim,lonlim);
% ax = worldmap('Asia');
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land,'FaceColor',[0.95,0.95,0.95]);

mlabel off
plabel off

Z3 = nanmean(T_SOS.*(-1),2);


scatterm(lat,lon,60,Z3,'filled','MarkerEdgeColor','k');
col4 = colormap(gca,color(4:7,:));
j1 = colorbar;
set(j1,'YTick',-0.5:0.5:1.5);

j1.Label.String = 'Spring ΔTa (°C)';
caxis([-0.5 1.5]);
set(gca,'FontName','Arial','FontSize',40,'LineWidth',1.5,'FontWeight','bold');

figure(4)
clf
ax = worldmap(latlim,lonlim);
% ax = worldmap('Asia');
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land,'FaceColor',[0.95,0.95,0.95]);

mlabel off
plabel off

Z4 = nanmean(T_EOS.*(-1),2);


sc1 = scatterm(lat,lon,60,Z4,'filled','MarkerEdgeColor','k');

col5 = colormap(gca,color(4:7,:));
j1 = colorbar;
set(j1,'YTick',-0.5:0.5:1.5);

j1.Label.String = 'Autumn ΔTa (°C)';
caxis([-0.5 1.5]);
set(gca,'FontName','Arial','FontSize',40,'LineWidth',1.5,'FontWeight','bold');

figure(5)
clf
ax = worldmap(latlim,lonlim);
% ax = worldmap('Asia');
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land,'FaceColor',[0.95,0.95,0.95]);

mlabel off
plabel off

Z5 = nanmean(ALAN_SOS.*(-1),2);



scatterm(lat,lon,60,Z5,'filled','MarkerEdgeColor','k');
col6 = colormap(gca,color(4:8,:));
j1 = colorbar;
set(j1,'YTick',-15:15:60);

j1.Label.String = 'Spring ΔALAN (nW·cm^-^2·sr^-^1)';
caxis([-15 60]);
set(gca,'FontName','Arial','FontSize',40,'LineWidth',1.5,'FontWeight','bold');

figure(6)
clf
ax = worldmap(latlim,lonlim);
% ax = worldmap('Asia');
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land,'FaceColor',[0.95,0.95,0.95]);

mlabel off
plabel off

Z6 = nanmean(ALAN_EOS.*(-1),2);


scatterm(lat,lon,60,Z6,'filled','MarkerEdgeColor','k');
col6 = colormap(gca,color(4:8,:));
j1 = colorbar;
set(j1,'YTick',-15:15:60);

j1.Label.String = 'Autumn ΔALAN (nW·cm^-^2·sr^-^1)';
caxis([-15 60]);
set(gca,'FontName','Arial','FontSize',40,'LineWidth',1.5,'FontWeight','bold');

%%

color1 = [
%     [64 3 126]
%     [91 53 149]
    [121 111 179]
%     [197 197 224]
%     [251 227 213]
%     [246 178 147]
    [220 109 87]
%     [183 34 48]
%     [109 1 31]
    ]./255;
dfAll = [Z1 Z2 Z3 Z4 Z5 Z6];
figure(7)
subplot(3,2,1);
edges1 = [-20:0.5:20];
temp1(:) = dfAll(:,1);

h1 = histogram(temp1,edges1);
h1.FaceColor = color1(1,:);
h1.LineWidth = 0.8;
h1.FaceAlpha = 0.4;
h1.EdgeColor = color1(1,:);
x1 = nanmean(temp1);
y1 = h1.Parent.YLim;
hold on
line([x1,x1],y1,'color','k','linestyle','-','LineWidth',2);
text(x1+x1*0.1,y1(1,2)-3,num2str(round(x1,2)),'FontName','Arial','FontSize',28,'FontWeight','bold');

set(gca,'XTick',[-20:10:20],'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
%     xlabel('Correlation','FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
ylabel('Frequency','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
title('','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');

subplot(3,2,2);
edges2 = [-20:0.5:20];
temp2(:) = dfAll(:,2);
h2 = histogram(temp2,edges2);
h2.FaceColor = color1(2,:);
h2.LineWidth = 0.8;
h2.FaceAlpha = 0.4;
h2.EdgeColor = color1(2,:);
x2 = nanmean(temp2);
y2 = h2.Parent.YLim;
hold on
line([x2,x2],y2,'color','k','linestyle','-','LineWidth',2);
text(x2-x2*0.1,y2(1,2)-3,num2str(round(x2,2)),'FontName','Arial','FontSize',28,'FontWeight','bold');
set(gca,'XTick',[-20:10:20],'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
%     xlabel('Correlation','FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
ylabel('Frequency','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
title('','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');

subplot(3,2,3);
edges3 = [-0.5:0.01:1.5];
temp3(:) = dfAll(:,3);
h3 = histogram(temp3,edges3);
h3.FaceColor = color1(2,:);
h3.LineWidth = 0.8;
h3.FaceAlpha = 0.4;
h3.EdgeColor = color1(2,:);
x3 = nanmean(temp3);
y3 = h3.Parent.YLim;
hold on
line([x3,x3],y3,'color','k','linestyle','-','LineWidth',2);
text(x3-x3*0.1,y3(1,2)-3,num2str(round(x3,2)),'FontName','Arial','FontSize',28,'FontWeight','bold');
set(gca,'XTick',(-0.5:0.5:1.5),'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
%     xlabel('Correlation','FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
ylabel('Frequency','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
title('','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');

subplot(3,2,4);
edges4 = [-0.5:0.01:1.5];
temp4(:) = dfAll(:,4);
h4 = histogram(temp4,edges4);
h4.FaceColor = color1(2,:);
h4.LineWidth = 0.8;
h4.FaceAlpha = 0.4;
h4.EdgeColor = color1(2,:);
x4 = nanmean(temp4);
y4 = h4.Parent.YLim;
hold on
line([x4,x4],y4,'color','k','linestyle','-','LineWidth',2);
text(x4-x4*0.1,y4(1,2)-3,num2str(round(x4,2)),'FontName','Arial','FontSize',28,'FontWeight','bold');
set(gca,'XTick',(-0.5:0.5:1.5),'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
%     xlabel('Correlation','FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
ylabel('Frequency','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
title('','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');

subplot(3,2,5);
edges5 = [-15:0.5:60];
temp5(:) = dfAll(:,5);
h5 = histogram(temp5,edges5);
h5.FaceColor = color1(2,:);
h5.LineWidth = 0.8;
h5.FaceAlpha = 0.4;
h5.EdgeColor = color1(2,:);
x5 = nanmean(temp5);
y5 = h5.Parent.YLim;
hold on
line([x5,x5],y5,'color','k','linestyle','-','LineWidth',2);
text(x5-x5*0.1,y5(1,2)-3,num2str(round(x5,2)),'FontName','Arial','FontSize',28,'FontWeight','bold');
set(gca,'XTick',(-15:15:60),'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
%     xlabel('Correlation','FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
ylabel('Frequency','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
title('','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');

subplot(3,2,6);
edges6 = [-15:0.5:60];
temp6(:) = dfAll(:,6);
h6 = histogram(temp6,edges6);
h6.FaceColor =color1(2,:);
h6.LineWidth = 0.8;
h6.FaceAlpha = 0.4;
h6.EdgeColor = color1(2,:);
x6 = nanmean(temp6);
y6 = h6.Parent.YLim;
hold on
line([x6,x6],y6,'color','k','linestyle','-','LineWidth',2);
text(x6-x6*0.1,y6(1,2)-3,num2str(round(x6,2)),'FontName','Arial','FontSize',28,'FontWeight','bold');
set(gca,'XTick',(-15:15:60),'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
%     xlabel('Correlation','FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
ylabel('Frequency','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
title('','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');

