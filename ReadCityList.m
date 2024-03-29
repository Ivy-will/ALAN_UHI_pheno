% clc;
% clear
% %%
% %--------------the first level of city list-------------------
% % 导入数据
% [~, ~, raw] = xlsread('G:\文件\论文2\Data\Result\99_pheno_ISA.xlsx','99_pheno_ISA','A2:E869');
% raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
% 
% % 将非数值元胞替换为 NaN
% R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % 查找非数值元胞
% raw(R) = {NaN}; % 替换非数值元胞
% 
% % 创建输出变量
% Allcity = reshape([raw{:}],size(raw));
% 
% clearvars raw R;
% save Citylist_All Allcity;
% 
% %%
% %--------------the first level of city list-------------------
% % 导入数据
% [~, ~, raw] = xlsread('G:\文件\论文2\Data\Result\99_pheno_ISA.xlsx','Sheet1','A2:E147');
% raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
% 
% % 将非数值元胞替换为 NaN
% R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % 查找非数值元胞
% raw(R) = {NaN}; % 替换非数值元胞
% 
% % 创建输出变量
% level_1th = reshape([raw{:}],size(raw));
% 
% clearvars raw R;
% save Citylist_level_1th level_1th;
% % level_1th(find(isnan(level_1th))) = 0;
% % cityISA = sortrows(level_1th,5);
% % addIAS1 = cityISA(:,5);
% % edges = [0:0.05:2];
% % h = histogram(addIAS1,edges);
% 
% %--------------the 2nd level of city list-------------------
% % 导入数据
% [~, ~, raw] = xlsread('G:\文件\论文2\Data\Result\99_pheno_ISA.xlsx','Sheet2','A2:E254');
% raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
% 
% % 将非数值元胞替换为 NaN
% R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % 查找非数值元胞
% raw(R) = {NaN}; % 替换非数值元胞
% 
% % 创建输出变量
% level_2th = reshape([raw{:}],size(raw));
% 
% clearvars raw R;
% save Citylist_level_2th level_2th;
% 
% %--------------the 3rd level of city list-------------------
% % 导入数据
% [~, ~, raw] = xlsread('G:\文件\论文2\Data\Result\99_pheno_ISA.xlsx','Sheet3','A2:E121');
% raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
% 
% % 将非数值元胞替换为 NaN
% R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % 查找非数值元胞
% raw(R) = {NaN}; % 替换非数值元胞
% 
% % 创建输出变量
% level_3th = reshape([raw{:}],size(raw));
% 
% clearvars raw R;
% save Citylist_level_3th level_3th;
% 
% %--------------the 4th level of city list-------------------
% % 导入数据
% [~, ~, raw] = xlsread('G:\文件\论文2\Data\Result\99_pheno_ISA.xlsx','Sheet4','A2:E88');
% raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
% 
% % 将非数值元胞替换为 NaN
% R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % 查找非数值元胞
% raw(R) = {NaN}; % 替换非数值元胞
% 
% % 创建输出变量
% level_4th = reshape([raw{:}],size(raw));
% 
% clearvars raw R;
% save Citylist_level_4th level_4th;
% 
% 
% %--------------the 5th level of city list-------------------
% % 导入数据
% [~, ~, raw] = xlsread('G:\文件\论文2\Data\Result\99_pheno_ISA.xlsx','Sheet5','A2:E263');
% raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
% 
% % 将非数值元胞替换为 NaN
% R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % 查找非数值元胞
% raw(R) = {NaN}; % 替换非数值元胞
% 
% % 创建输出变量
% level_5th = reshape([raw{:}],size(raw));
% 
% clearvars raw R;
% save Citylist_level_5th level_5th;


%%
%--------------the city list Northern Hemisphere -------------------
clc;
clear

% 导入数据
pointInput = importdata('E:\文件\论文2\Data\Result\121501_pheno_ISA.xlsx');
MissCity = importdata('E:\文件\论文2\Data\Result\MissTemp.xlsx');
A(:,1) = pointInput.textdata(2:443,6);
Lall =length(A);

Allcity = zeros(Lall,7);
Allcity(:,1:5) = pointInput.data;
Misscity1 = MissCity.Sheet1;
Misscity2 = MissCity.Sheet2;
Misscity3 = MissCity.Sheet3;
[m0,n0,N0] = intersect(Misscity3(:,1),Allcity(:,1));

Allcity(N0,:) = [];
A(N0,:) = [];

Len =length(A);
NH_Citylist1 = zeros(Len,7);
for i = 1:Len
    ss1 = split(A(i,1),'[');
    ss2 = split(ss1(2,1),']');
    ss3 = split(ss2(1,1),',');
    Allcity(i,6) = str2num(char(ss3(1,1)));
    Allcity(i,7) = str2num(char(ss3(2,1)));
end


[m1,n1,N1] = intersect(Misscity1(:,1),Allcity(:,1));
KK = Allcity;
KK(N1,:) = [];
[m2,n2,N2] = intersect(Misscity2(:,1),Allcity(:,1));
KK1 = Allcity(N2,:);

L1 = Lall - length(Misscity1);
NH_Citylist1(1:L1,:) = KK;
NH_Citylist1(L1+1:Len,:) = KK1;
Allcity = NH_Citylist1;
[m ,n] = find(NH_Citylist1(:,7)>30);
NH_Citylist(:,:) = NH_Citylist1(m,:);
save NH_Citylist NH_Citylist;
save Citylist_All Allcity;


%%
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