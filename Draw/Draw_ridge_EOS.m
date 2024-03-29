clc;
clear

load VPNEOS_All7;
load avVPN_LST_SOS;
load avVPN_LST_EOS;
load VPNSOS_All7;
load VPNALAN_All;
load VPNLST_All;
load VPNNH_slope_rank;
load VPNCitylist_All;
load VPNallISA;

VPNEOS_All7(find(VPNEOS_All7<180)) = NaN;
VPNEOS_All7(find(VPNEOS_All7>365)) = NaN;
VPNSOS_All7(find(VPNSOS_All7<=0)) = NaN;

L1 = length(VPNSOS_All7(:,1,1));

for citynum = 1:L1
    ss1(:,:) = VPNSOS_All7(citynum,:,:);
    ss2(:,:) = VPNEOS_All7(citynum,:,:);
    %     ss(find(ss<0)) = NaN;
    for layer = 1:10
        sslayer1(:) = ss1(:,layer);
        if sum(isnan(sslayer1)) > 3
            ss1(:,layer) = NaN;
        end
        sslayer2(:) = ss2(:,layer);
        if sum(isnan(sslayer2)) > 3
            ss2(:,layer) = NaN;
        end
    end
    av_ss1(:,:) = nanmean(ss1,1);
    if sum(isnan(av_ss1)) > 5
        ss1(:,:) = NaN;
    end
    av_ss2(:,:) = nanmean(ss2,1);
    if sum(isnan(av_ss2)) > 5
        ss2(:,:) = NaN;
    end
    VPNSOS_All7(citynum,:,:) = ss1;
    VPNEOS_All7(citynum,:,:) = ss2;
end

nh_city(:,1) = VPNNH_slope_rank;
[M,N] = find(VPNAllcity(:,8)==3);%1=US,2=Europe,3=Asia
TempAllCity = VPNAllcity(M,:);
ALAN0 = VPNALAN_All(M,:,:);
LST0 = VPNLST_All(M,:,:);
PHENO0 = VPNEOS_All7(M,:,:);%(city,year,layer)
Isa0 = VPNallISA(M,:);
gl_city(:,1) = TempAllCity(:,1);

[m0,n0,N0] = intersect(nh_city,gl_city);
ALAN = ALAN0(N0,:,:);
LST = LST0(N0,:,:);
PHENO = PHENO0(N0,:,:);%(city,year,layer)
Isa = Isa0(N0,:);
Len = length(N0);

selectT = zeros(Len,7,40,10);
selectALAN = zeros(Len,7,3,10);
for city = 1:Len    
    for year = 1:7
        start = 365+(year-1)*365+191;
        enddate = 365+(year-1)*365+230;
    selectT(city,year,:,:)  = LST(city,start:enddate,:);
    selectALAN(city,year,:,:) = ALAN(city,(year-1)*12+7:(year-1)*12+9,:);
    end
end

avT(:,:,:) = nanmean(selectT,3);
avT_Y(:,:) = nanmean(avT,2);


avALAN(:,:,:) = nanmean(selectALAN,3);
avALAN_Y(:,:) = nanmean(avALAN,2);


avPh(:,:) = nanmean(PHENO,2);

color1 = [
    [251 227 213]
    [246 178 147]
    [220 109 87]
    [183 34 48]
    [109 1 31]
    ]./255;
color2 = [
    [197 197 224]
    [156 152 199]
    [121 111 179]
    [91 53 149]
    [64 3 126]
    ]./255;

data1 = zeros(20,10);
data2 = zeros(20,10);
data3 = zeros(100,10);
x1 = linspace(180,270,21);
x2 = linspace(18,36,21);
x3 = linspace(0,100,101);
for i = 1:10
    temp = avPh(:,i);
    data1(:,i) = histcounts(temp,x1, 'Normalization', 'probability');
end
for i = 1:10
    temp = avT_Y(:,i);
    data2(:,i) = histcounts(temp,x2, 'Normalization', 'probability');
end
for i = 1:10
    temp = avALAN_Y(:,i);
    data3(:,i) = histcounts(temp,x3, 'Normalization', 'probability');
end

figure(1)
subplot(1,3,1)
X1 = linspace(180,270,20);
joyPlot(data1,X1,0.1, ...
       'constant', ...
        false,...
       'LineWidth',1.5, ...
       'FaceColor','position', ...
       'FaceAlpha',0.7)
% hTitle = title('Ridgeline Plot');
set(gca,'FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
xlabel('EOS (DOY)','FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
ylabel('Buffer','FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
 colormap(gca,'summer');

subplot(1,3,3)
X2 = linspace(18,36,20);
joyPlot(data2,X2,0.1, ...
       'constant', ...
        false,...
       'LineWidth',1.5, ...
       'FaceColor','position', ...
       'FaceAlpha',0.7)
% hTitle = title('Ridgeline Plot');
set(gca,'FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
xlabel('T_a(°C)','FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
% ylabel('Buffer','FontName','Times New Roman','FontSize',32,'LineWidth',1.5,'FontWeight','bold');
 colormap(gca,color1);

 subplot(1,3,2)
X3 = linspace(0,100,100);
joyPlot(data3,X3,0.1, ...
       'constant', ...
        false,...
       'LineWidth',1.5, ...
       'FaceColor','position', ...
       'FaceAlpha',0.7)
% hTitle = title('Ridgeline Plot');
set(gca,'FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
xlabel('ALAN (nW·cm·^-^2·sr^-^1)','FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
% ylabel('Buffer','FontName','Times New Roman','FontSize',32,'LineWidth',1.5,'FontWeight','bold');
 colormap(gca,color2);