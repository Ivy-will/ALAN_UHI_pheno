clc;
clear

load VPNNH_slope_rank;
load VPNNH_Citylist;
load SOSCityparCorTaav;
load EOSCityparCorTaav;

[m0,n0,N0] = intersect(VPNNH_slope_rank,VPNNH_Citylist(:,1));
Rank_VPN_NHCity(:,:) = VPNNH_Citylist(N0,:);

parCorr = zeros(2,length(VPNNH_slope_rank),2);
parCorr(1,:,:) = SOSCityparCor(:,1,:);
parCorr(2,:,:) = EOSCityparCor(:,1,:);

indxNum = zeros(length(VPNNH_slope_rank),2);
for i = 1:length(VPNNH_slope_rank)
    kk(:,:) = parCorr(:,i,:);
    for j = 1:2
        if kk(j,1)*kk(j,2) < 0
            [m1,n1] = max(abs(kk(j,:)));
            indxNum(i,j) = n1;
        else
            [m1,n1] = max(kk(j,:));
            indxNum(i,j) = n1;
        end
        if kk(j,n1) > 0 && n1 == 1
            indxNum(i,j) = 3;
        end
        if kk(j,n1) > 0 && n1 == 2
            indxNum(i,j) = 4;
        end
    end
end

figure(1)
latlim = [30 90];
lonlim = [-180 180];

ax = worldmap(latlim,lonlim);
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land,'FaceColor',[0.95,0.95,0.95]);
mlabel off
plabel off

color = [
    [0.71 0.13 0.18]
    [0.47 0.43 0.70]
     [0.96,0.70,0.58]
    [0.25 0.01 0.50]
%      [0.86	0.43	0.34]
    ];
color1 = [
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

G = zeros(2,1);
ResCout = zeros(2,4);
for i = 1:4
    cc(:) = color(i,:);
    [m0,n0] = find(indxNum(:,1)==i);
    ResCout(1,i) = length(m0);
    lon = Rank_VPN_NHCity(m0,6);
    lat = Rank_VPN_NHCity(m0,7);

    G1 = scatterm(lat,lon,60,cc,'filled','MarkerEdgeColor','k');
    G(i,1) = G1;
    hold on
end
legend(G,{'ALAN-','Ta-','ALAN+','Ta+'},'FontName','Arial','FontSize',24,'LineWidth',1.5,'FontWeight','bold',"Box","off");


figure(2)
latlim = [30 90];
lonlim = [-180 180];

ax = worldmap(latlim,lonlim);
land = shaperead('landareas', 'UseGeoCoords', true);
geoshow(ax, land,'FaceColor',[0.95,0.95,0.95]);
mlabel off
plabel off


color1 = [
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

G = zeros(2,1);
for i = 1:4
    cc(:) = color(i,:);
    [m0,n0] = find(indxNum(:,2)==i);
    ResCout(2,i) = length(m0);
    lon = Rank_VPN_NHCity(m0,6);
    lat = Rank_VPN_NHCity(m0,7);
    G1 = scatterm(lat,lon,60,cc,'filled','MarkerEdgeColor','k');
    G(i,1) = G1;
    hold on
end