%--------------the city list Northern Hemisphere -------------------
clc;
clear

% 导入数据
pointInput = importdata('CityInfo.xls');

A(:,1) = pointInput.textdata(2:758,3);
Lall =length(A);

VPNAllcity = zeros(Lall,4);
VPNAllcity(:,1:2) = pointInput.data(:,1:2);
Len =length(A);

for i = 1:Len
    ss1 = split(A(i,1),'[');
    ss2 = split(ss1(2,1),']');
    ss3 = split(ss2(1,1),',');
    VPNAllcity(i,3) = str2num(char(ss3(1,1)));
    VPNAllcity(i,4) = str2num(char(ss3(2,1)));
end

[m ,n] = find(VPNAllcity(:,4)>30);
VPNNH_Citylist(:,:) = VPNAllcity(m,:);
save VPNNH_Citylist VPNNH_Citylist;
save VPNCitylist_All VPNAllcity;