clc;
clear

load VPNCitylist_All; %level_4th
% MissCity = importdata('H:\文件\论文2\Data\Result\MissTemp.xlsx');
% Misscity2 = MissCity.Sheet2;
city = VPNAllcity(:,1);

Len = length(city);
VPNALAN_All = zeros(Len,84,10);
VPNLST_All = zeros(Len,2920,10);
VPNSOS_All = zeros(Len,8,10);

year = {'2013-2014','2015-2016','2017-2018','2019-2020'};
for cityname = 1:Len
        cy = num2str(city(cityname,1)); 
        for j = 1:4
            yearstr = char(year{1,j});
            LSTfile = ['H:\文件\论文2\Data\SMbuffer_VPN_Tair\Tair_' yearstr '_100m__' cy '.csv'];
            lst = importdata(LSTfile);
            for i = 2:11
                a_LST = lst{i,1};
                b_LST = split(a_LST,',');
                if j == 1 && length(b_LST) == 732
                    Ta2013(:,1) = readmat(b_LST,729);
                    VPNLST_All(cityname,1:543) = Ta2013(1:543);
                    VPNLST_All(cityname,544) = NaN;
                    VPNLST_All(cityname,545:730) = Ta2013(544:729);
                else
                    VPNLST_All(cityname,(j-1)*730+1:j*730,i-1) = readmat(b_LST,730);
                end
            end
        end
%     if cityname <= 398
%  2553 179
%         LSTfile = ['E:\文件\论文2\Data\SMbuffer_Tair2\AirT_' cy '.csv'];
%         lst = importdata(LSTfile);
%         for i = 2:11
%             a_LST = lst{i,1};
%             b_LST = split(a_LST,',');
%             LST_All(cityname,:,i-1) = readmat(b_LST,2555);
%         end
%     else
% 
%         for j = 1:3
%             if j==1
%                 LSTfile = ['E:\文件\论文2\Data\SMbuffer_Test\Tair_2013-2014_100m_' cy '.csv'];
%                 lst = importdata(LSTfile);
%                 for i = 2:11
%                     a_LST = lst{i,1};
%                     b_LST = split(a_LST,',');
%                     LST_All(cityname,1:730,i-1) = readmat(b_LST,730);
%                 end
%             end
%             if j==2
%                 LSTfile = ['E:\文件\论文2\Data\SMbuffer_Test\Tair_2015-2017_100m_' cy '.csv'];
%                 lst = importdata(LSTfile);
%                 for i = 2:11
%                     a_LST = lst{i,1};
%                     b_LST = split(a_LST,',');
%                     LST_All(cityname,731:1825,i-1) = readmat(b_LST,1095);
%                 end
%             end
%             if j==3
%                 LSTfile = ['E:\文件\论文2\Data\SMbuffer_Test\Tair_2013-2014_100m_' cy '.csv'];
%                 lst = importdata(LSTfile);
%                 for i = 2:11
%                     a_LST = lst{i,1};
%                     b_LST = split(a_LST,',');
%                     LST_All(cityname,1826:2555,i-1) = readmat(b_LST,730);
%                 end
%             end
%         end
%     end
    phenofile = ['H:\文件\论文2\Data\SMbuffer_VPN_SOS\Pheno_2013-2020_100m_SOS_' cy  '.csv'];
    ALANfile = ['H:\文件\论文2\Data\SMbuffer_VPN_ALAN\ALAN_2013-2020_100m__' cy '.csv'];
    pheno = importdata(phenofile);
    alan = importdata(ALANfile);
    for i = 2:11
        a_pheno = pheno{i,1};
        b_pheno = split(a_pheno,',');
        VPNSOS_All(cityname,:,i-1) = readmat(b_pheno,8);
        a_alan = alan{i,1};
        b_alan = split(a_alan,',');
        VPNALAN_All(cityname,:,i-1) = readmat(b_alan,84);
    end
end
VPNSOS_All7 = VPNSOS_All(:,2:8,:);
 save VPNSOS_All VPNSOS_All;
 save VPNSOS_All7 VPNSOS_All7;




selectALAN = zeros(Len,7,12,10);
for citynum = 1:Len
    for year = 1:7
        selectALAN(citynum,year,:,:) = VPNALAN_All(citynum,(year-1)*12+1:(year-1)*12+12,:);
    end
%3 months
end
avVPN_ALAN(:,:,:) = nanmean(selectALAN,3);

selectLST_SOS = zeros(Len,7,40,10);
for city = 1:Len
    for year = 1:7
        start = 365+(year-1)*365+51;
        enddate = 365+(year-1)*365+90;
    selectLST_SOS(city,year,:,:)  = VPNLST_All(city,start:enddate,:);
    end

end
avVPN_LST_SOS(:,:,:) = nanmean(selectLST_SOS,3);



 save avVPN_LST_SOS avVPN_LST_SOS;
 save avVPN_ALAN avVPN_ALAN;
save VPNALAN_All VPNALAN_All;
save VPNLST_All VPNLST_All;
%%
clc;
clear

load VPNCitylist_All; %level_4th
load VPNLST_All;
city = VPNAllcity(:,1);
Len = length(city);
VPNEOS2_All = zeros(Len,8,10);


for cityname = 1:Len
    cy = num2str(city(cityname,1));
%     phenofile = ['G:\文件\论文2\Data\SMbuffer_VPN_EOS\Pheno_2013-2020_100m_EOS_' cy  '.csv'];
    phenofile = ['H:\文件\论文2\Data\SMbuffer_VPN_EOS2\EOS2_2013-2020_100m__' cy  '.csv'];

    pheno = importdata(phenofile);

    for i = 2:11
        a_pheno = pheno{i,1};
        b_pheno = split(a_pheno,',');
        VPNEOS2_All(cityname,:,i-1) = readmat(b_pheno,8);
    end
end
VPNEOS2_All(find(VPNEOS2_All>365)) = NaN;
VPNEOS2_All7 = VPNEOS2_All(:,2:8,:);

selectLST_EOS = zeros(Len,7,40,10);
for city = 1:Len
    ss(:,:) = VPNEOS2_All(city,:,:);
    day = round(nanmean(ss(:)),0);
    for year = 1:7
        start = 365+(year-1)*365+191;
        enddate = 365+(year-1)*365+230;
    selectLST_EOS(city,year,:,:)  = VPNLST_All(city,start:enddate,:);
    end    
end
avVPN_LST_EOS(:,:,:) = nanmean(selectLST_EOS,3);
save VPNEOS2_All VPNEOS2_All;
save VPNEOS2_All7 VPNEOS2_All7;
% save avVPN_LST_EOS avVPN_LST_EOS;

function Rm = readmat(series,num)
x = zeros(num,1);
if length(series) < num+3
    x(:,1) = NaN;
else
    for i = 1:num
        if isempty(series{i+1,1})
            x(i,1) = NaN;
        else
            str = char(series{i+1,1});
            x(i,1) = str2num(str);
        end
    end
end
Rm = x;
end
    
    