clc;
clear

load VPNNH_slope_rank;
load VPNNH_Citylist;
load VPNCitylist_All;
load SOSCityparCorTaav.mat;
load EOSCityparCorTaav.mat;


[M,N] = find(VPNAllcity(:,8)>=1);%1=US,2=Europe,3=Asia
TempAllCity = VPNAllcity(M,:);
[m0,n0,N0] = intersect(TempAllCity(:,1),VPNNH_slope_rank);
Rank_VPN_NHCity(:,:) = TempAllCity(n0,:);
Len = length(Rank_VPN_NHCity(:,1));
nh_city(:,1) = VPNNH_slope_rank;


% indxNum = zeros(length(VPNNH_slope_rank),2);
% for i = 1:length(VPNNH_slope_rank)
%     kk(:,:) = parCorr(:,i,:);
%     for j = 1:2
%         if kk(j,1)*kk(j,2) < 0
%             [m1,n1] = max(abs(kk(j,:)));
%             indxNum(i,j) = n1;
%         else
%             [m1,n1] = max(kk(j,:));
%             indxNum(i,j) = n1;
%         end
%     end
% end

SOSCityParXYA = zeros(Len,5);
EOSCityParXYA = zeros(Len,5);
SOSCityParXYA(:,1:2) = SOSCityparCor(N0,:,2);
SOSCityParXYA(:,3:4) = TempAllCity(n0,6:7);
EOSCityParXYA(:,1:2) = EOSCityparCor(N0,:,2);
EOSCityParXYA(:,3:4) = TempAllCity(n0,6:7);
ResCout = zeros(4,4);

for i = 1:Len
     if SOSCityParXYA(i,1) < 0 && SOSCityParXYA(i,2) < 0.05
        SOSCityParXYA(i,5) = 1;
    end
    if SOSCityParXYA(i,1) < 0 && SOSCityParXYA(i,2) > 0.05
        SOSCityParXYA(i,5) = 2;
    end
    if SOSCityParXYA(i,1) > 0 && SOSCityParXYA(i,2) > 0.05
        SOSCityParXYA(i,5) = 3;
    end
    if SOSCityParXYA(i,1) > 0 && SOSCityParXYA(i,2) < 0.05
        SOSCityParXYA(i,5) = 4 ;
    end
end

for i = 1:Len
     if EOSCityParXYA(i,1) < 0 && EOSCityParXYA(i,2) < 0.05
        EOSCityParXYA(i,5) = 1;
    end
    if EOSCityParXYA(i,1) < 0 && EOSCityParXYA(i,2) > 0.05
        EOSCityParXYA(i,5) = 2;
    end
    if EOSCityParXYA(i,1) > 0 && EOSCityParXYA(i,2) > 0.05
        EOSCityParXYA(i,5) = 3;
    end
    if EOSCityParXYA(i,1) > 0 && EOSCityParXYA(i,2) < 0.05
        EOSCityParXYA(i,5) = 4 ;
    end
end

SOSCityParXYT = zeros(Len,5);
EOSCityParXYT = zeros(Len,5);
SOSCityParXYT(:,1:2) = SOSCityparCor(N0,:,1);
SOSCityParXYT(:,3:4) = TempAllCity(n0,6:7);
EOSCityParXYT(:,1:2) = EOSCityparCor(N0,:,1);
EOSCityParXYT(:,3:4) = TempAllCity(n0,6:7);


for i = 1:Len
     if SOSCityParXYT(i,1) < 0 && SOSCityParXYT(i,2) < 0.05
        SOSCityParXYT(i,5) = 1;
    end
    if SOSCityParXYT(i,1) < 0 && SOSCityParXYT(i,2) > 0.05
        SOSCityParXYT(i,5) = 2;
    end
    if SOSCityParXYT(i,1) > 0 && SOSCityParXYT(i,2) > 0.05
        SOSCityParXYT(i,5) = 3;
    end
    if SOSCityParXYT(i,1) > 0 && SOSCityParXYT(i,2) < 0.05
        SOSCityParXYT(i,5) = 4 ;
    end
end

for i = 1:Len
     if EOSCityParXYT(i,1) < 0 && EOSCityParXYT(i,2) < 0.05
        EOSCityParXYT(i,5) = 1;
    end
    if EOSCityParXYT(i,1) < 0 && EOSCityParXYT(i,2) > 0.05
        EOSCityParXYT(i,5) = 2;
    end
    if EOSCityParXYT(i,1) > 0 && EOSCityParXYT(i,2) > 0.05
        EOSCityParXYT(i,5) = 3;
    end
    if EOSCityParXYT(i,1) > 0 && EOSCityParXYT(i,2) < 0.05
        EOSCityParXYT(i,5) = 4 ;
    end
end

figure(1)
latlim = [30 90];
lonlim = [-180 180];

% ax = worldmap(latlim,lonlim);
ax = worldmap("Asia");
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land,'FaceColor',[0.95,0.95,0.95]);
mlabel off
plabel off

color = [[0.35 0.20 0.58]
    [0.47 0.43 0.70]
    [0.96,0.70,0.58]
    [0.71 0.13 0.18]];
G = zeros(4,1);
for i = 1:4
    cc(:) = color(i,:);
    [m0,n0] = find(SOSCityParXYA(:,5)==i);
    ResCout(1,i) = length(m0);
    lon = SOSCityParXYA(m0,3);
    lat = SOSCityParXYA(m0,4);
    G1 = scatterm(lat,lon,60,cc,'filled','MarkerEdgeColor','k');
    G(i,1) = G1;
    hold on
end

%     title('SOS rALAN ','FontName','Times New Roman','FontSize',24,'LineWidth',1.5,'FontWeight','bold');
%     title('SOS R_A_L_A_N ','FontName','Times New Roman','FontSize',24,'LineWidth',1.5,'FontWeight','bold');

% legend(G,{'Neg^*','Neg','Pos','Pos^*'},'FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');

figure(2)
% ax = worldmap(latlim,lonlim);
ax = worldmap("Asia");
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land, 'FaceColor',[0.95,0.95,0.95]);
mlabel off
plabel off

G = zeros(4,1);
for i = 1:4
    cc(:) = color(i,:);
    [m0,n0] = find(EOSCityParXYA(:,5)==i);
    ResCout(2,i) = length(m0);
    lon = EOSCityParXYA(m0,3);
    lat = EOSCityParXYA(m0,4);
    G1 = scatterm(lat,lon,60,cc,'filled','MarkerEdgeColor','k');
    G(i,1) = G1;
    hold on
end
% title('EOS rALAN ','FontName','Times New Roman','FontSize',24,'LineWidth',1.5,'FontWeight','bold');
% title('EOS R_A_L_A_N ','FontName','Times New Roman','FontSize',24,'LineWidth',1.5,'FontWeight','bold');

figure(3)
% ax = worldmap(latlim,lonlim);
ax = worldmap("Asia");
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land, 'FaceColor',[0.95,0.95,0.95]);
mlabel off
plabel off

for i = 1:4
    cc(:) = color(i,:);
    [m0,n0] = find(SOSCityParXYT(:,5)==i);
    ResCout(3,i) = length(m0);
    lon = SOSCityParXYT(m0,3);
    lat = SOSCityParXYT(m0,4);
    G1 = scatterm(lat,lon,60,cc,'filled','MarkerEdgeColor','k');
    G(i,1) = G1;
    hold on
end
%     title('SOS rTa ','FontName','Times New Roman','FontSize',24,'LineWidth',1.5,'FontWeight','bold');
%     title('SOS R_T_a ','FontName','Times New Roman','FontSize',24,'LineWidth',1.5,'FontWeight','bold');

% legend(G,{'Neg^*','Neg','Pos','Pos^*'},'FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');

figure(4)
% ax = worldmap(latlim,lonlim);
ax = worldmap("Asia");
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land, 'FaceColor',[0.95,0.95,0.95]);
mlabel off
plabel off

G = zeros(4,1);
for i = 1:4
    cc(:) = color(i,:);
    [m0,n0] = find(EOSCityParXYT(:,5)==i);
    ResCout(4,i) = length(m0);
    lon = EOSCityParXYT(m0,3);
    lat = EOSCityParXYT(m0,4);
    G1 = scatterm(lat,lon,60,cc,'filled','MarkerEdgeColor','k');
    G(i,1) = G1;
    hold on
end
%     title('EOS rTa ','FontName','Times New Roman','FontSize',24,'LineWidth',1.5,'FontWeight','bold');
%     title('EOS R_T_a ','FontName','Times New Roman','FontSize',24,'LineWidth',1.5,'FontWeight','bold');

legend(G,{'Neg^*','Neg','Pos','Pos^*'},'FontName','Arial','FontSize',24,'LineWidth',1.5,'FontWeight','bold','Box','off');
