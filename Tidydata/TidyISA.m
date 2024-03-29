clc;
clear

load VPNCitylist_All; %level_4th

city = VPNAllcity(:,1);
Len = length(city);
VPNallISA = zeros(Len,10);

for cityname = 1:Len
    cy = num2str(city(cityname,1));
        ISAfile = ['H:\文件\论文2\Data\City_ISA\2018ISA_' cy '.csv'];
        ISA = importdata(ISAfile);
        for i = 2:11
            a_LST = ISA{i,1};
            b_LST = split(a_LST,',');
                VPNallISA(cityname,i-1) = str2double(b_LST{3,1});             
        end
end

save VPNallISA VPNallISA;


