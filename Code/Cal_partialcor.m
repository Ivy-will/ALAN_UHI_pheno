clc;
clear
load VPNNH_Citylist;
load VPNCitylist_All;
load SOS_All;
load EOS_All;
load ALAN_All;
load avTav_SOS;
load avTav_EOS;


EOS_All(find(EOS_All<= 180)) = NaN;
EOS_All(find(EOS_All>365)) = NaN;
SOS_All(find(SOS_All<= 0)) = NaN;

city = length(SOS_All(:,1));
selectALAN_SOS = zeros(city ,7,3,10);
selectALAN_EOS = zeros(city ,7,3,10);
for citynum = 1:city 
    for year = 1:7
        selectALAN_SOS(citynum,year,:,:) = ALAN_All(citynum,(year-1)*12+1:(year-1)*12+3,:);
        selectALAN_EOS(citynum,year,:,:) = ALAN_All(citynum,(year-1)*12+7:(year-1)*12+9,:);
    end
%3 months
end
avVPN_ALAN_SOS(1,:,:) = nanmean(selectALAN_SOS,3);
avVPN_ALAN_EOS(1,:,:) = nanmean(selectALAN_EOS,3);

for citynum = 1:city
    ss1(:,:) = SOS_All(citynum,:,:);
    ss2(:,:) = EOS_All(citynum,:,:);
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
    SOS_All(citynum,:,:) = ss1;
    EOS_All(citynum,:,:) = ss2;
end

% [m0,n0,N0] = intersect(VPNNH_slope_rank(:,1),VPNAllcity(:,1));
% NH_SOS = SOS_All(N0,:,:);
% NH_EOS = EOS_All(N0,:,:);
% NH_LST_SOS = avVPN_Taav_SOS(N0,:,:);
% NH_LST_EOS = avVPN_Taav_EOS(N0,:,:);
% NH_ALAN_SOS = avVPN_ALAN_SOS(N0,:,:);
% NH_ALAN_EOS = avVPN_ALAN_EOS(N0,:,:);


NH_SOS = SOS_All;
NH_EOS = EOS_All;
NH_LST_SOS = avTav_SOS;
NH_LST_EOS = avTav_EOS;
NH_ALAN_SOS = avVPN_ALAN_SOS;
NH_ALAN_EOS = avVPN_ALAN_EOS;
%%
Len = length(SOS_All(:,1));

resDf = zeros(Len,2);% significant difference between Ta and ALAN with FisherZ
SOSCityparCor = zeros(Len,2,2);


for city = 1:Len
    ph0 = NH_SOS(city,:,:);alan0 = NH_ALAN_SOS(city,:,:);ta0 = NH_LST_SOS(city,:,:);
    ph1 = reshape(ph0,7*10,1);alan1 = reshape(alan0,7*10,1);ta1 = reshape(ta0,7*10,1);
%        intaT_ALAN = alan1.*ta1;
 ph1 = zscore(ph1);alan1 = zscore(alan1);ta1 = zscore(ta1);
        yx = cat(2,ph1,ta1,alan1);
        YX = yx(all(~isnan(yx),2),:);    
    if isempty(YX)
        SOSCityparCor(city,:,:) = NaN;
    else
        YX = zscore(YX);
        Y = YX(:,1);
        X = [ones(size(Y)) YX(:,2:3)];
%           [b,bint,r,rint,stats] = regress(Y,X);
      [a,b] = partialcorr(YX);
        SOSCityparCor(city,1,:) = a(2:3,1);
        SOSCityparCor(city,2,:) = b(1,2:3);
        cor1 = a(2,1);cor2 = a(3,1);
        z_cor1 = 0.5*log((1+cor1)/(1-cor1));
        z_cor2 = 0.5*log((1+cor2)/(1-cor2));
        n = length(YX); se = sqrt(1/(n-3));
        z_dff = (z_cor1-z_cor2)/se; p_value = 2*(1-normcdf(abs(z_dff)));
        resDf(city,1) = p_value;
    end

end

EOSCityparCor = zeros(Len,2,2);
for city = 1:Len
    ph0 = NH_EOS(city,:,:);alan0 = NH_ALAN_EOS(city,:,:);ta0 = NH_LST_EOS(city,:,:);
    ph1 = reshape(ph0,10*7,1);alan1 = reshape(alan0,10*7,1);ta1 = reshape(ta0,10*7,1);
%      intaT_ALAN = alan1.*ta1;
   ph1 = zscore(ph1);alan1 = zscore(alan1);ta1 = zscore(ta1);
    yx = cat(2,ph1,ta1,alan1);
        YX = yx(all(~isnan(yx),2),:);    
    if isempty(YX)
        EOSCityparCor(city,:,:) = NaN;
    else
        YX = zscore(YX);
         Y = YX(:,1);
        X = [ones(size(Y)) YX(:,2:3)];
%          [b,bint,r,rint,stats] = regress(Y,X);
       [a,b] = partialcorr(YX);
        EOSCityparCor(city,1,:) = a(2:3,1);
        EOSCityparCor(city,2,:) = b(1,2:3);
        cor1 = a(2,1);cor2 = a(3,1);
        z_cor1 = 0.5*log((1+cor1)/(1-cor1));
        z_cor2 = 0.5*log((1+cor2)/(1-cor2));
        n = length(YX); se = sqrt(1/(n-3));
        z_dff = (z_cor1-z_cor2)/se; p_value = 2*(1-normcdf(abs(z_dff)));
        resDf(city,2) = p_value;
    end
end

save SOSCityparCorTaav_DT SOSCityparCor;
save EOSCityparCorTaav_DT EOSCityparCor;
save FisherZresDf resDf;
