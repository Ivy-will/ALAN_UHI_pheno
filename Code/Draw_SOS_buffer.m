clc;
clear

load VPNCitylist_All;%for all cities
load VPNNH_Citylist;%for 

load SOS_All;
load EOS_All;
load avTav_SOS;
load avTav_EOS;
load ALAN_All;
load AllISA;


EOS_All(find(EOS_All<180)) = NaN;
EOS_All(find(EOS_All>365)) = NaN;
SOS_All(find(SOS_All<=0)) = NaN;

L1 = length(SOS_All(:,1,1));

for citynum = 1:L1
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

%the namelist of countries and cities can retrieve from excel file
City = 60310; % the ID for city
Cityname = ["New York"];
Countryname = ["America"];

% [m0,n0,N0] = intersect(City(:,1),VPNAllcity(:,1));%take care the order of
% citylist in different mat-files, keep them consistent with the NumberID
% of each city
ALAN = ALAN_All;
LST = avTav_SOS;
PHENO = SOS_All;%(city,year,layer)
Isa = AllISA;
Len = length(SOS_All(:,1));

%select T before multiply average Greenup date with a period of 40 days
selectALAN = zeros(Len,7,3,10);
for city = 1:Len    
    for year = 1:7
    selectALAN(city,year,:,:) = ALAN_All(city,(year-1)*12+1:(year-1)*12+3,:);
    end
end

str2 = {'0','0.2','0.4','0.6','0.8','1.0'};


for city = 1:Len
figure(1)
h1 = subplot(2,2,city);
    cy = strcat(char(Cityname{city,1}),'(',char(Countryname{city,1}),')');
    ISA= Isa(city,:)*10;  
    ss_pheno(:,:) = PHENO(city,:,:);
    c_pheno = nanmean(ss_pheno,1);

    ss_ALAN(:,:,:) = selectALAN(city,:,1:3,:);
    yearAv_T =zeros(7,10);
    yearAv_ALAN = zeros(7,10);
    for year = 1:7
        yearAv_T(year,:) = avTav_SOS(city,year,:);
        year_ALAN(:,:) = ss_ALAN(year,:,:);
        yearAv_ALAN(year,:) = nanmean(year_ALAN,1);        
    end
    yyaxis left
    c_T = nanmean(yearAv_T,1);
    c_ALAN = nanmean(yearAv_ALAN,1);
    VarPheno =  nanstd(ss_pheno,1)./sqrt(7);
    VarT =  nanstd(yearAv_T,1)./sqrt(7);
    VarALAN =  nanstd(yearAv_ALAN,1)./sqrt(7);
    [FitPh,R1,st1] = FitCurve((ISA/10)',c_pheno',1);
    plot(ISA,FitPh,'-b','color',[0.20 0.46 0.22],'LineWidth',3);
%     hold on
%     h1=fill([ISA',fliplr(ISA')],[FitPh-VarPheno',fliplr(FitPh+VarPheno')],[0.8706 0.9216 0.9804]);
    hold on
    scatter(ISA,c_pheno,160,[0.20 0.46 0.22],'o','filled','MarkerEdgeColor','k');
%     hold on 
%     scatter(All1(:,4),All1(:,1),20,[0.2 0.70 0.30],'o');
    hold on
     errorbar(ISA,c_pheno,VarPheno,'o','color',[0.20 0.46 0.22],'LineWidth',3,...
    'MarkerEdgeColor',[0.20 0.46 0.22],'MarkerFaceColor',[0.20 0.46 0.22]);
    set(gca,'color','none','ycolor',[0.20 0.46 0.22],'FontName','Arial','FontSize',14,'LineWidth',3,'FontWeight','bold');
    ylabel('SOS (DOY)','FontName','Arial','FontSize',14,'LineWidth',3,'FontWeight','bold','color',[0.20 0.46 0.22]);
    yyaxis right
%     plot(ISA,c_T,'-r','color',[0.8 0.2 0.1],'LineWidth',3);
        [FitTa,R2,st2] = FitCurve((ISA/10)',c_T',1);
    plot(ISA,FitTa,'-r','color',[0.84 0.37 0.00],'LineWidth',3);
%         hold on 
%     scatter(All1(:,4),All1(:,2),20,[0.8 0.2 0.1],'o');
    hold on
    scatter(ISA,c_T,160,[0.84 0.37 0.00],'o','filled','MarkerEdgeColor','k');
    hold on
    errorbar(ISA,c_T,VarT,'o','color',[0.84 0.37 0.00],'LineWidth',3,...
        'MarkerEdgeColor',[0.84 0.37 0.00],'MarkerFaceColor',[0.84 0.37 0.00]);

    set(gca,'color','none', 'color','none','ycolor',[0.84 0.37 0.00],'xlim',[0 10]);
    set(gca,'color','none','ycolor',[0.84 0.37 0.00],'FontName','Times New Roman','FontSize',18,'LineWidth',3,'FontWeight','bold');
    ylabel('T_a(°C)','FontName','Arial','FontSize',18,'LineWidth',3,'FontWeight','bold','color',[0.84 0.37 0.00]);
    xlabel('β','FontName','Arial','FontSize',18,'LineWidth',3,'FontWeight','bold');
    set(gca,'XTicklabels',str2,'FontName','Arial','FontSize',18,'LineWidth',3,'FontWeight','bold','Box','on');

    hold on
    xlim1 = get(h1,'xlim');
    xticklen = get(h1,'ticklength');
    pos1 = get(h1,'position');    
    pos1(1)=pos1(1)-0.02;
    pos1(3) = pos1(3)*.86;
    set(h1,'position',pos1);
    pos3 = pos1;
    pos3(3) = pos3(3)+.06;
    xlim3 = xlim1;
    xlim3(2) = xlim3(1)+(xlim1(2)-xlim1(1))/pos1(3)*pos3(3);
    h3 = axes('position',pos3);
    [FitALAN,R3,st3] = FitCurve((ISA/10)',c_ALAN',4);
    scatter(ISA,c_ALAN,160,[0.18 0.15 0.52],'o','filled','MarkerEdgeColor','k');
%     plot(ISA,c_ALAN,'-k','color',[0.35 0.20 0.58],'LineWidth',3);
    hold on
    plot(ISA,FitALAN,'-k','color',[0.18 0.15 0.52],'LineWidth',3);
%     hold on
%     scatter(All1(:,4),All1(:,3),20,[0.35 0.20 0.58],'o');
    hold on
    errorbar(ISA,c_ALAN,VarALAN,'o','color',[0.18 0.15 0.52],'LineWidth',3,...
        'MarkerEdgeColor',[0.18 0.15 0.52],'MarkerFaceColor',[0.18 0.15 0.52]);
    set(h3, 'yaxislocation', 'right','FontName','Arial','FontSize',18,'LineWidth',3,'FontWeight','bold');
    set(gca,'color','none','xcolor',[0.18 0.15 0.52],'ycolor',[0.18 0.15 0.52],'xlim',[0 xlim3(2)], ...
        'xtick',[],'yaxislocation','right','yminortick','off','Box','on');
    set(h3,'ticklength',xticklen);
    t = ttest2(c_ALAN,FitALAN,'Alpha',0.001);

    if R1 < 0.001
        text(min(ISA)+0.02,max(c_ALAN),strcat(' y = ',st1,' p < 0.001 '),'FontName','Arial','FontSize',14,'LineWidth',1.5,'FontWeight','bold','color',[0.20 0.46 0.22]);
    else
        text(min(ISA)+0.02,max(c_ALAN),strcat(' y = ',st1,' R^2 = ',num2str(round(R1,3))),'FontName','Arial','FontSize',14,'LineWidth',1.5,'FontWeight','bold','color',[0.20 0.46 0.22]);
    end    
    if R2 < 0.001
        text(min(ISA)+3,max(c_T)+0.2,strcat(' y = ',st2,' p < 0.001 '),'FontName','Arial','FontSize',14,'LineWidth',1.5,'FontWeight','bold','color',[0.84 0.37 0.00]);
    else
        text(min(ISA)+3,max(c_T)+0.2,strcat(' y = ',st2,' R^2 = ',num2str(round(R2,3))),'FontName','Arial','FontSize',14,'LineWidth',1.5,'FontWeight','bold','color',[0.84 0.37 0.00]);
    end
    if t == 0
        text(min(ISA)+0.1,min(c_ALAN)+2,strcat(' y = ',st3,' p < 0.001'),'FontName','Arial','FontSize',14,'LineWidth',1.5,'FontWeight','bold','color',[0.18 0.15 0.52]);
    else
        text(min(ISA)+0.1,min(c_ALAN)+2,strcat(' y = ',st3,' R^2 = ',num2str(round(R3,3))),'FontName','Arial','FontSize',14,'LineWidth',1.5,'FontWeight','bold','color',[0.18 0.15 0.52]);
    end
%     set(gca,'XTick',(0:1:10),'XTicklabels',str1,'FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold');
    set(h3,'FontName','Times New Roman','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    ylabel('ALAN (nW·cm^-^2·sr^-^1)','FontName','Arial','FontSize',18,'LineWidth',1.5,'FontWeight','bold');

    box off
 title(cy,'FontName', 'Arial','FontSize',18,'FontWeight','bold');
% legend({"Obs","Fit","ErrorBar"});
end

 function [FitA,R,St] = FitCurve(X,Y,num)
 res = zeros(10,1);
 if num == 1
     X1 = X.*X;
     tb = table(X1,X,Y,'VariableNames',{'X1','X','Y'});
     lm = fitlm(tb,'Y~X1+X');
     res(:,1) = predict(lm,tb);
     b = lm.Coefficients.Estimate;
     R = lm.ModelFitVsNullModel.Pvalue;
     St = strcat(num2str(round(b(2),2)),'*x^2',num2str(round(b(3),2)),'*x+',num2str(round(b(1),2))); %拟合的函数
 end
 if num == 2
     x = X;
     x(isnan(X)) = [];
     Y(isnan(Y)) = [];
     X1 = log(x);
%      Y1 = log(Y);
     tb = table(X1,Y,'VariableNames',{'X1','Y'});
     lm = fitlm(tb,'Y~X1');
     res(:,1) = predict(lm,log(X));
     b = lm.Coefficients.Estimate;
%      res = exp(res);
     R = lm.ModelFitVsNullModel.Pvalue;
     St = strcat(num2str(round(b(2),2)),'*ln(x)+',num2str(round(b(1),2))); %拟合的函数
 end

 if num == 3
     Y1 = log(Y-X(1,1));
     tb = table(X,Y1,'VariableNames',{'X','Y'});
     lm = fitlm(tb,'Y~X');
      res(:,1) = predict(lm,tb);
      b = lm.Coefficients.Estimate;
     res = exp(res)+X(1,1);
     R = lm.ModelFitVsNullModel.Pvalue;
     St = strcat(num2str(round(exp(b(2)),2)),'*e^x+',num2str(round(X(1,1),2))); %拟合的函数
 end
  if num == 4
     x = X;
     y = Y;
     x(isnan(Y))=[];
     y(isnan(Y))=[];
        fx=@(b,x)(b(1)./(1+b(2).*exp(-b(3).*x)));
        b=[1 2 2]; %初始迭代值 最大值 生长速率 （根据具体实验来设定，初始值在本方程拟合影响不大）
        for l=1:30 %拟合过程迭代
            b=lsqcurvefit(fx,b,x,y);
            b=nlinfit(x,y,fx,b);
        end
        n=length(y);
        SSy=var(y)*(n-1);
        y1=fx(b,x);
        RSS=(y-y1)'*(y-y1);
        R=(SSy-RSS)/SSy;
        res(:,1)=fx(b,X);
     St = strcat(num2str(round(b(1),2)),'/(1+',num2str(round(b(2),2)),'*exp(-',num2str(round(b(3),2)),'*x))'); %拟合的函数
 end
 FitA = res;
 end
        