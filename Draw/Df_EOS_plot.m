clc;
clear

% [~, ~, raw] = xlsread('G:\文件\论文2\Data\Result\CityTable.xlsx','Sheet1','B1:B17');
% raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
% cellVectors = raw(:,1);
% 
% % 将导入的数组分配给列变量名称
% name = cellVectors(:,1);

% 清除临时变量
clearvars raw cellVectors;

City = {'55','2421','7067','11855',...
    '16529','18646','20262','27125',...
    '30070','31378','36242','43470',...
    '50575','51768','56252','61504'};
Len = length(City);
ALAN = zeros(Len,72,9);
LST = zeros(Len,2555,9);
PHENO = zeros(Len,6,9);%(city,year,layer)
for cityname = 1:Len
    cy = char(City{1,cityname});
    phenofile = ['H:\文件\论文2\Data\SMbuffer_Pheno-EOS2\EOS_' cy '.csv'];
    LSTfile = ['H:\文件\论文2\Data\SMbuffer_Tair\AirT_' cy '.csv'];
    ALANfile = ['H:\文件\论文2\Data\SMbuffer_ALAN\ALAN_' cy '.csv'];
    pheno = importdata(phenofile);
    lst = importdata(LSTfile);
    alan = importdata(ALANfile);
    for i = 2:7
        a_pheno = pheno{i,1};
        b_pheno = split(a_pheno,',');
        PHENO(cityname,:,i-1) = b_pheno(2:7);
        a_LST = lst{i,1};
        b_LST = split(a_LST,',');
        LST(cityname,:,i-1) = b_LST(2:2556);
        a_alan = alan{i,1};
        b_alan = split(a_alan,',');
        ALAN(cityname,:,i-1) = b_alan(2:73);
    end
end

%select T before multiply average Greenup date with a period of 40 days
selectT = zeros(Len,6,60,9);
selectALAN = zeros(Len,6,12,9);
for city = 1:Len
    ss(:,:) = PHENO(city,:,:);
    day = round(nanmean(ss(:)),0);
    for year = 1:6
        start = (year-1)*365+day-40+1;
        enddate = (year-1)*365+day;
    selectT(city,year,:,:)  = LST(city,start:enddate,:);
    selectALAN(city,year,:,:) = ALAN(city,(year-1)*12+1:(year-1)*12+12,:);
    end
    av_T(:,:,:) = nanmean(selectT,3);
    av_ALAN(:,:,:) = nanmean(selectALAN,3);
end

df_T = zeros(Len,6,9);%(city,year,layer);
df_ALAN = zeros(Len,6,9);%(city,year,layer);
df_pheno = zeros(Len,6,9);%(city,year,layer);
for city = 1:Len
    ss_pheno(:,:) = PHENO(city,:,:);
    av_eachlayer(:) = nanmean(ss_pheno,1);
    df_pheno(city,:,:) = ss_pheno-av_eachlayer;
    ss_T(:,:) = av_T(city,:,:);
    av_eachlayer(:) = nanmean(ss_T,1);
    df_T(city,:,:) = ss_T-av_eachlayer;
    ss_ALAN(:,:) = av_ALAN(city,:,:);
    av_eachlayer(:) = nanmean(ss_ALAN,1);
    df_ALAN(city,:,:) = ss_ALAN-av_eachlayer;
end
color = [[0.00,0.10,1.0]
    [0.30,0.30,0.80]
    [0.40,0.80,0.60]
    [0.60,0.90,0.40]
    [0.80,0.40,0.20]
    [1,0.10,0.00]];

figure(2)
for city = 1:Len
    h1 = subplot(4,4,city);
    cy = char(name{city,1});
    
    for layer = 1:6
        cc(:) = color(layer,:);
    x_pheno(:) = df_pheno(city,:,layer);
    y_T(:) = df_T(city,:,layer);

    %     y_ALAN(:) = df_ALAN(city,:,layer);
    %     yyaxis left
    scatter(x_pheno,y_T,[],cc,'d','LineWidth',2);

    ylabel('Difference T (℃)','FontName','Times New Roman','FontSize',12,'LineWidth',1.5,'FontWeight','bold','color','k');xlabel('Difference SOS (day)','FontName','Times New Roman','FontSize',12,'LineWidth',1.5,'FontWeight','bold','color','b');
%     yyaxis right
%     scatter(x_pheno,y_ALAN,[],cc,'o','LineWidth',1.5);
%     ylabel('Difference ALAN ','FontName','Times New Roman','FontSize',10,'LineWidth',1.5,'FontWeight','bold','color','r');
    hold on
    end
    title(cy,'FontName', 'Times New Roman','FontSize',12,'FontWeight','bold');
    xlabel('Difference EOS (day)','FontName','Times New Roman','FontSize',12,'LineWidth',1.5,'FontWeight','bold','color','k');
end
str = {'buffer layer1','buffer layer2','buffer layer3','buffer layer4','buffer layer5','buffer layer6'};
legend(str,'FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
figure(3)
for city = 1:Len
    h1 = subplot(4,4,city);
    cy = char(name{city,1});
    
    for layer = 1:6
        cc(:) = color(layer,:);
    x_pheno(:) = df_pheno(city,:,layer);

    y_ALAN(:) = df_ALAN(city,:,layer);
    
%     yyaxis left
    
    scatter(x_pheno,y_ALAN,[],cc,'o','LineWidth',2);
    ylabel('Difference ALAN ','FontName','Times New Roman','FontSize',12,'LineWidth',1.5,'FontWeight','bold','color','r');
    hold on
    end
    title(cy,'FontName', 'Times New Roman','FontSize',12,'FontWeight','bold');
    xlabel('Difference EOS (day)','FontName','Times New Roman','FontSize',12,'LineWidth',1.5,'FontWeight','bold','color','k');
end
str = {'buffer layer1','buffer layer2','buffer layer3','buffer layer4','buffer layer5','buffer layer6'};
legend(str,'FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
%%
figure(4)
subplot(1,2,1)
    for layer = 1:6
        cc(:) = color(layer,:);
        ssph_layer(:,:) = df_pheno(:,:,layer);
    xly_pheno(:) = reshape(ssph_layer,1,Len*6);
ssALAN_layer(:,:) = df_T(:,:,layer);
    yly_ALAN(:) = reshape(ssALAN_layer,1,Len*6);
%     yyaxis left

    p1 =round(polyfit(xly_pheno,yly_ALAN,1),4);
    yfit1 = polyval(p1,xly_pheno);
    mdl1 = fitlm(xly_pheno,yly_ALAN);
    pp1 = round(mdl1.Coefficients.pValue,3);
    s1 = num2str(pp1(2,1));
    a1 = num2str(p1(1));
    b1 = num2str(p1(2));
    if pp1(2,1)>0.05
        Formu1 = ['y=',a1,'x+',b1,' p>0.05'];
    else
        Formu1 = ['y=',a1,'x+',b1,' p<0.05'];
    end
    scatter(xly_pheno,yly_ALAN,[],cc,'d','LineWidth',1.5);
    hold on
    plot(xly_pheno,yfit1,'--k','color',cc,'LineWidth',1.5);
    
    ylabel('Difference T (℃)','FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold','color','k');
    hold on
    end
    %     title(cy,'FontName', 'Times New Roman','FontSize',12);
    set(gca,'XTick',(-30:5:20),'FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold');
    set(gca,'YTick',(-6:2:6),'FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold');
    xlabel('Difference EOS (day)','FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold','color','k');

% str = {'buffer layer1','buffer layer2','buffer layer3','buffer layer4','buffer layer5','buffer layer6'};
% legend(str,'FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');

subplot(1,2,2)
    for layer = 1:6
        cc(:) = color(layer,:);
        ssph_layer(:,:) = df_pheno(:,:,layer);
    xly_pheno(:) = reshape(ssph_layer,1,Len*6);
ssALAN_layer(:,:) = df_ALAN(:,:,layer);
    yly_ALAN(:) = reshape(ssALAN_layer,1,Len*6);
%     yyaxis left
    
    scatter(xly_pheno,yly_ALAN,[],cc,'o','LineWidth',1.5);
    ylabel('Difference ALAN ','FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold','color','r');
    hold on
    end
    %     title(cy,'FontName', 'Times New Roman','FontSize',12);
    set(gca,'XTick',(-30:5:20),'FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold');
    set(gca,'YTick',(-8:2:8),'FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold');
    xlabel('Difference EOS (day)','FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold','color','k');

str = {'buffer layer1','buffer layer2','buffer layer3','buffer layer4','buffer layer5','buffer layer6'};
legend(str,'FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
