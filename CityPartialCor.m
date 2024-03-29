clc;
clear

load VPNCitylist_All;
load VPNNH_Citylist;
% load av_ALAN;
load VPNEOS_All7;
load avVPN_LST_SOS;
load avVPN_LST_EOS;
load VPNSOS_All7;
load VPNALAN_All;
load VPNNH_slope_rank;
load avVPN_Tmin_SOS;
load avVPN_Tmin_EOS;

avVPN_Taav_SOS = (avVPN_LST_SOS+avVPN_Tmin_SOS)./2;
avVPN_Taav_EOS = (avVPN_LST_EOS+avVPN_Tmin_EOS)./2;

VPNEOS_All7(find(VPNEOS_All7<= 180)) = NaN;
VPNEOS_All7(find(VPNEOS_All7>365)) = NaN;
VPNSOS_All7(find(VPNSOS_All7<= 0)) = NaN;

city = length(VPNSOS_All7(:,1));
selectALAN_SOS = zeros(city ,7,3,10);
selectALAN_EOS = zeros(city ,7,3,10);
for citynum = 1:city 
    for year = 1:7
        selectALAN_SOS(citynum,year,:,:) = VPNALAN_All(citynum,(year-1)*12+1:(year-1)*12+3,:);
        selectALAN_EOS(citynum,year,:,:) = VPNALAN_All(citynum,(year-1)*12+7:(year-1)*12+9,:);
    end
%3 months
end
avVPN_ALAN_SOS(:,:,:) = nanmean(selectALAN_SOS,3);
avVPN_ALAN_EOS(:,:,:) = nanmean(selectALAN_EOS,3);

for citynum = 1:city
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

[m0,n0,N0] = intersect(VPNNH_slope_rank(:,1),VPNAllcity(:,1));
NH_SOS = VPNSOS_All7(N0,:,:);
NH_EOS = VPNEOS_All7(N0,:,:);
NH_LST_SOS = avVPN_Taav_SOS(N0,:,:);
NH_LST_EOS = avVPN_Taav_EOS(N0,:,:);
NH_ALAN_SOS = avVPN_ALAN_SOS(N0,:,:);
NH_ALAN_EOS = avVPN_ALAN_EOS(N0,:,:);


Len = length(m0);
SOSCityparCor = zeros(Len,2,2);
for city = 1:Len
    ph0 = NH_SOS(city,:,:);alan0 = NH_ALAN_SOS(city,:,:);ta0 = NH_LST_SOS(city,:,:);
    ph1 = reshape(ph0,10*7,1);alan1 = reshape(alan0,10*7,1);ta1 = reshape(ta0,10*7,1);
%     ph1 = zscore(ph1);alan1 = zscore(alan1);ta1 = zscore(ta1);
        yx = cat(2,ph1,ta1,alan1);
        YX = yx(all(~isnan(yx),2),:);    
    if isempty(YX)
        SOSCityparCor(city,:,:) = NaN;
    else
        YX = zscore(YX);
        [a,b] = partialcorr(YX);
        SOSCityparCor(city,1,:) = a(2:3,1);
        SOSCityparCor(city,2,:) = b(2:3,1);
        
    end

end

EOSCityparCor = zeros(Len,2,2);
for city = 1:Len
    ph0 = NH_EOS(city,:,:);alan0 = NH_ALAN_EOS(city,:,:);ta0 = NH_LST_EOS(city,:,:);
    ph1 = reshape(ph0,10*7,1);alan1 = reshape(alan0,10*7,1);ta1 = reshape(ta0,10*7,1);
%     ph1 = zscore(ph1);alan1 = zscore(alan1);ta1 = zscore(ta1);
    yx = cat(2,ph1,ta1,alan1);
        YX = yx(all(~isnan(yx),2),:);    
    if isempty(YX)
        EOSCityparCor(city,:,:) = NaN;
    else
        YX = zscore(YX);
        [a,b] = partialcorr(YX);
        EOSCityparCor(city,1,:) = a(2:3,1);
        EOSCityparCor(city,2,:) = b(2:3,1);
        
    end
end

save SOSCityparCorTaav SOSCityparCor;
save EOSCityparCorTaav EOSCityparCor;

%----------------- slope calculation function ---------------------
function Slope = SpaceSlope(pheno,X)
L = length(pheno(:,1,1));
slope = zeros(L,7,3);
for citynum = 1:L
    ss(:,:) = pheno(citynum,:,:);
    alanss(:,:) = X(citynum,:,:);
    for year = 1:7
        ssph(:) = ss(year,:);
        ssyear_ALAN(:) = alanss(year,:);
        slope(citynum,year,1) = nanmean(ssyear_ALAN);
        if sum(isnan(ssph)) > 5 || sum(isnan(ssyear_ALAN)) == 10
            slope(citynum,year,:) = NaN;
        else
            x1 = (1:1:10);
            alanX = [ones(size(ssyear_ALAN));x1];
            alanb = regress(ssyear_ALAN',alanX');
            slope(citynum,year,2) = alanb(2,1);
            slope(citynum,year,3) = median(ssyear_ALAN(1,1:5)) - median(ssyear_ALAN(1,6:10));
        end
    end
end
Slope = slope;
end