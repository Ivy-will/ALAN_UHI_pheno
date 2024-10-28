clc;
clear

% load VPNCitylist_All; %level_4th
% city = VPNAllcity(:,1);% for all the city
city =  60310;% 60310 represent the New York
Len = length(city);
ALAN_All = zeros(Len,84,10);
Tmax_All = zeros(Len,2920,10);
Tmin_All = zeros(Len,2920,10);
SOS_All8 = zeros(Len,8,10);
EOS_All8 = zeros(Len,8,10);
AllISA = zeros(Len,10);

year = {'2013-2014','2015-2016','2017-2018','2019-2020'};
for cityname = 1:Len
        cy = num2str(city(cityname,1)); 
        for j = 1:4
            yearstr = char(year{1,j});
            LSTfile = ['Tmax_' yearstr '_' cy '.csv'];
            lst = importdata(LSTfile);
            for i = 2:11
                a_ISA = lst{i,1};
                b_LST = split(a_ISA,',');
                if j == 1 && length(b_LST) == 732
                    Ta2013(:,1) = readmat(b_LST,729);
                    Tmax_All(cityname,1:543) = Ta2013(1:543);
                    Tmax_All(cityname,544) = NaN;
                    Tmax_All(cityname,545:730) = Ta2013(544:729);
                else
                    Tmax_All(cityname,(j-1)*730+1:j*730,i-1) = readmat(b_LST,730);
                end
            end
        end

        for j = 1:4
            yearstr = char(year{1,j});
            LSTfile = ['Tmin_' yearstr '_' cy '.csv'];
            lst = importdata(LSTfile);
            for i = 2:11
                a_ISA = lst{i,1};
                b_LST = split(a_ISA,',');
                if j == 1 && length(b_LST) == 732
                    Ta2013(:,1) = readmat(b_LST,729);
                    Tmin_All(cityname,1:543) = Ta2013(1:543);
                    Tmin_All(cityname,544) = NaN;
                    Tmin_All(cityname,545:730) = Ta2013(544:729);
                else
                    Tmin_All(cityname,(j-1)*730+1:j*730,i-1) = readmat(b_LST,730);
                end
            end
        end

    SOSfile = ['Pheno_2013-2020_SOS_' cy  '.csv'];
     EOSfile = ['Pheno_2013-2020_EOS_' cy  '.csv'];
     ALANfile = ['ALAN_2013-2020_' cy '.csv'];
    sos = importdata(SOSfile);
    alan = importdata(ALANfile);
    eos = importdata(EOSfile);
    ISAfile = ['2018ISA_' cy '.csv'];
    ISA = importdata(ISAfile);

    for i = 2:11
        a_SOS = sos{i,1};
        b_SOS = split(a_SOS,',');
        SOS_All8(cityname,:,i-1) = readmat(b_SOS,8);
        a_alan = alan{i,1};
        b_alan = split(a_alan,',');
        ALAN_All(cityname,:,i-1) = readmat(b_alan,84);
        a_EOS = eos{i,1};
        b_EOS = split(a_EOS,',');
        EOS_All8(cityname,:,i-1) = readmat(b_EOS,8);
        a_ISA = ISA{i,1};
        b_ISA = split(a_ISA,',');
        AllISA(cityname,i-1) = str2double(b_ISA{3,1});
    end

end
SOS_All = SOS_All8(:,2:8,:); % SOS during 2014-2020
EOS_All = EOS_All8(:,2:8,:);
 save SOS_All SOS_All;
 save EOS_All EOS_All;
save AllISA AllISA;


%%
selectTav_SOS = zeros(Len,7,40,10);
selectTav_EOS = zeros(Len,7,40,10);
avTav_SOS = zeros(Len,7,10);
avTav_EOS = zeros(Len,7,10);
for city = 1:Len
    for year = 1:7
        start = 365+(year-1)*365+51;
        enddate = 365+(year-1)*365+90;
        selectTmax(:,:)  = Tmax_All(city,start:enddate,:);
        selectTmin(:,:)  = Tmin_All(city,start:enddate,:);
        selectTav_SOS(city,year,:,:) = (selectTmin+selectTmax)./2;
        start2 = 365+(year-1)*365+191;
        enddate2 = 365+(year-1)*365+230;
        selectTmax(:,:)  = Tmax_All(city,start2:enddate2,:);
        selectTmin(:,:)  = Tmin_All(city,start2:enddate2,:);
        selectTav_EOS(city,year,:,:) = (selectTmin+selectTmax)./2;
    end

end
avTav_SOS(:,:,:) = nanmean(selectTav_SOS,3);
avTav_EOS(:,:,:) = nanmean(selectTav_EOS,3);


save avTav_SOS avTav_SOS;
save avTav_EOS avTav_EOS;
save ALAN_All ALAN_All;


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
    
    