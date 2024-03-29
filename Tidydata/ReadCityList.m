
%--------------the city list Northern Hemisphere -------------------
clc;
clear

% 导入数据
pointInput = importdata('G:\文件\论文2\Data\Result\121501_pheno_ISA.xls');

A(:,1) = pointInput.textdata(2:758,6);
Lall =length(A);

VPNAllcity = zeros(Lall,7);
VPNAllcity(:,1:5) = pointInput.data(:,1:5);
Len =length(A);

for i = 1:Len
    ss1 = split(A(i,1),'[');
    ss2 = split(ss1(2,1),']');
    ss3 = split(ss2(1,1),',');
    VPNAllcity(i,6) = str2num(char(ss3(1,1)));
    VPNAllcity(i,7) = str2num(char(ss3(2,1)));
end

[m ,n] = find(VPNAllcity(:,7)>30);
VPNNH_Citylist(:,:) = VPNAllcity(m,:);
save VPNNH_Citylist VPNNH_Citylist;
save VPNCitylist_All VPNAllcity;
