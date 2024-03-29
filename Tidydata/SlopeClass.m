clc;
clear
load VPNNH_Citylist;
load VPNCitylist_All;
load VPNSOS_All7;
load VPNEOS_All7;
load VPNALAN_All;
load avVPN_LST_SOS;
load avVPN_LST_EOS;


VPNEOS_All7(find(VPNEOS_All7<= 180)) = NaN;
VPNEOS_All7(find(VPNEOS_All7>365)) = NaN;
VPNSOS_All7(find(VPNSOS_All7<= 0)) = NaN;

len = length(VPNNH_Citylist(:,1));
VPNclassCity = zeros(len,4);
nh_city(:,1) = VPNNH_Citylist(:,1);
gl_city(:,1) = VPNAllcity(:,1);
[m0,n0,N0] = intersect(nh_city,gl_city);

VPNclassCity(:,1) = gl_city(N0,1);


city = length(VPNALAN_All(:,1,1));
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

NH_SOS(:,:,:) = VPNSOS_All7(N0,:,:);
NH_EOS(:,:,:) = VPNEOS_All7(N0,:,:);
NH_LST_SOS(:,:,:) = avVPN_LST_SOS(N0,:,:);
NH_LST_EOS(:,:,:) = avVPN_LST_EOS(N0,:,:);
NH_ALAN_SOS(:,:,:) = avVPN_ALAN_SOS(N0,:,:);
NH_ALAN_EOS(:,:,:) = avVPN_ALAN_EOS(N0,:,:);

Len = length(m0);
for citynum = 1:Len
    ss1(:,:) = NH_SOS(citynum,:,:);
    ss2(:,:) = NH_EOS(citynum,:,:);
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
    NH_SOS(citynum,:,:) = ss1;
    NH_EOS(citynum,:,:) = ss2;
end

NH_sos_slope = avSpaceSlope(NH_SOS,NH_SOS);
NH_eos_slope = avSpaceSlope(NH_EOS,NH_EOS);

VPNclassCity(:,2) = NH_sos_slope(:,3);
VPNclassCity(:,3) =  NH_eos_slope(:,3);

for i = 1:len
    if VPNclassCity(i,2) < 0 && VPNclassCity(i,3) < 0
        VPNclassCity(i,4) = 1;
    end
    if VPNclassCity(i,2) < 0 && VPNclassCity(i,3) > 0
        VPNclassCity(i,4) = 2;
    end
    if VPNclassCity(i,2) > 0 && VPNclassCity(i,3) < 0
        VPNclassCity(i,4) = 3;
    end
    if VPNclassCity(i,2) > 0 && VPNclassCity(i,3) > 0
        VPNclassCity(i,4) = 4 ;
    end
    if isnan(VPNclassCity(i,2)) || isnan(VPNclassCity(i,3))
        VPNclassCity(i,4) = NaN;
    end
end

VPNclassCity = sortrows(VPNclassCity,4);
VPNclassCity(isnan(VPNclassCity(:,4)),:) = [];
tar1 = numel(find(VPNclassCity(:,4)==1));
tar2 = numel(find(VPNclassCity(:,4)==2));
tar3 = numel(find(VPNclassCity(:,4)==3));
tar4 = numel(find(VPNclassCity(:,4)==4));
% save VPNclassCity VPNclassCity;

function Slopeav = avSpaceSlope(pheno,X)
L = length(pheno(:,1,1));
slope = zeros(L,3);
for citynum = 1:L
    ss(:,:) = pheno(citynum,:,:);
    alanss(:,:) = X(citynum,:,:);
    
    ssph(1,:) = nanmean(ss,1);
    ssyear_ALAN(1,:) = nanmean(alanss,1);
    slope(citynum,1) = ssyear_ALAN(1,1);
    if sum(isnan(ssph)) > 5 || sum(isnan(ssyear_ALAN)) == 10
        slope(citynum,:) = NaN;
    else
        x1 = (1:1:10);
        alanX = [ones(size(ssyear_ALAN));x1];
        alanb = regress(ssyear_ALAN',alanX');
        slope(citynum,2) = alanb(2,1);
            slope(citynum,3) = nanmean(ssyear_ALAN(1,1:5)) - nanmean(ssyear_ALAN(1,6:10));
    end
end
Slopeav = slope;
end

