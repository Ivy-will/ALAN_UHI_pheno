clc;
clear

load VPNEOS_All7;
load avVPN_LST_SOS;
load avVPN_LST_EOS;
load VPNSOS_All7;
load VPNALAN_All;
load VPNLST_All;
load VPNNH_slope_rank;
load VPNCitylist_All;
load VPNallISA;

VPNEOS_All7(find(VPNEOS_All7<180)) = NaN;
VPNEOS_All7(find(VPNEOS_All7>365)) = NaN;
VPNSOS_All7(find(VPNSOS_All7<=0)) = NaN;

L1 = length(VPNSOS_All7(:,1,1));

for citynum = 1:L1
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

nh_city(:,1) = VPNNH_slope_rank;
[M,N] = find(VPNAllcity(:,8)==1);%1=US,2=Europe,3=Asia
TempAllCity = VPNAllcity(M,:);
ALAN0 = VPNALAN_All(M,:,:);
LST0 = VPNLST_All(M,:,:);
PHENO0 = VPNEOS_All7(M,:,:);%(city,year,layer)
Isa0 = VPNallISA(M,:);
gl_city(:,1) = TempAllCity(:,1);

[m0,n0,N0] = intersect(nh_city,gl_city);
ALAN = ALAN0(N0,:,:);
LST = LST0(N0,:,:);
PHENO = PHENO0(N0,:,:);%(city,year,layer)
Isa = Isa0(N0,:);
Len = length(N0);

selectT = zeros(Len,7,40,10);
selectALAN = zeros(Len,7,3,10);
for city = 1:Len    
    for year = 1:7
        start = 365+(year-1)*365+191;
        enddate = 365+(year-1)*365+230;
    selectT(city,year,:,:)  = LST(city,start:enddate,:);
    selectALAN(city,year,:,:) = ALAN(city,(year-1)*12+7:(year-1)*12+9,:);
    end
end

avT(:,:,:) = nanmean(selectT,3);
avT_C(:,:) = nanmean(avT,1);
avT_C_Y(:,:) = nanmean(avT_C,1);
re_avT = reshape(avT,Len*7,10);
VarT =  nanstd(re_avT,1)*0.05;

avALAN(:,:,:) = nanmean(selectALAN,3);
avALAN_C(:,:) = nanmean(avALAN,1);
avALAN_C_Y(:,:) = nanmean(avALAN_C,1);
re_avALAN = reshape(avALAN,Len*7,10);
VarALAN =  nanstd(re_avALAN,1)*0.05;

avPh(:,:) = nanmean(PHENO,1);
avPh_C(:) = nanmean(avPh,1);
re_avPheno = reshape(PHENO,Len*7,10);
VarPheno =  nanstd(re_avPheno,1)*0.1;

ISA = nanmean(Isa,1)*10;

 sd(1:10,1) = VarPheno*10;sd(1:10,2) = VarT/0.05;sd(1:10,3) = VarALAN/0.05;


str1 = {'0','0.1','0.2','0.3','0.4','0.5','0.6','0.7','0.8','0.9','1.0'};

figure(3)
h1 = subplot(1,1,1);
x = (1:1:10);  
    c_pheno = avPh_C;
    [FitPh,R1,st1] = FitCurve((ISA/10)',c_pheno',1);
    yearAv_T = avT_C_Y;
    yearAv_ALAN = avALAN_C_Y;

    yyaxis left
    c_T = nanmean(yearAv_T,1);
    c_ALAN = nanmean(yearAv_ALAN,1);
    plot(ISA,FitPh,'-b','color',[0.2 0.70 0.30],'LineWidth',3);
%     hold on
%     h1=fill([ISA',fliplr(ISA')],[FitPh-VarPheno',fliplr(FitPh+VarPheno')],[0.8706 0.9216 0.9804]);
    hold on
    scatter(ISA,c_pheno,160,[0.2 0.70 0.30],'o','filled','MarkerEdgeColor','k');
%     hold on 
%     scatter(All1(:,4),All1(:,1),20,[0.2 0.70 0.30],'o');
    hold on
     errorbar(ISA,c_pheno,VarPheno,'o','color',[0.2 0.70 0.30],'LineWidth',1.5,...
    'MarkerEdgeColor',[0.2 0.70 0.30],'MarkerFaceColor',[0.2 0.70 0.30]);
     set(gca,'YTick',226:4:242);
     set(gca,'YTickLabel',226:4:242);
    set(gca,'color','none','ycolor',[0.2 0.70 0.30],'FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
    ylabel('EOS (DOY)','FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold','color',[0.2 0.70 0.30]);

    yyaxis right
%     plot(ISA,c_T,'-r','color',[0.8 0.2 0.1],'LineWidth',3);
        [FitTa,R2,st2] = FitCurve((ISA/10)',c_T',2);
    plot(ISA,FitTa,'-r','color',[0.8 0.2 0.1],'LineWidth',3);
%         hold on 
%     scatter(All1(:,4),All1(:,2),20,[0.8 0.2 0.1],'o');
    hold on
    scatter(ISA,c_T,160,[0.8 0.2 0.1],'o','filled','MarkerEdgeColor','k');
    hold on
    errorbar(ISA,c_T,VarT,'o','color',[0.8 0.2 0.1],'LineWidth',1.5,...
        'MarkerEdgeColor',[0.8 0.2 0.1],'MarkerFaceColor',[0.8 0.2 0.1]);

    set(gca,'color','none', 'color','none','ycolor',[0.8 0.2 0.1],'xlim',[0 10]);
    set(gca,'color','none','ycolor',[0.8 0.2 0.1],'FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
    xlabel('β','FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
    set(gca,'XTicklabels',str1,'FontName','Arial','FontSize',34,'LineWidth',1.5,'FontWeight','bold');
    ylabel('T_a(°C)','FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold','color',[0.8 0.2 0.1]);

    hold on
    xlim1 = get(h1,'xlim');
    xticklen = get(h1,'ticklength');
    pos1 = get(h1,'position'); % 建立第二个轴，要与第一个轴重合，并且透明，轴的范围相同   
    pos1(1)=pos1(1)-0.02;
    pos1(3) = pos1(3)*.86;
    set(h1,'position',pos1);
    pos3 = pos1;
    pos3(3) = pos3(3)+.1;
    xlim3 = xlim1;
    xlim3(2) = xlim3(1)+(xlim1(2)-xlim1(1))/pos1(3)*pos3(3);
    h3 = axes('position',pos3);
    [FitALAN,R3,st3] = FitCurve((ISA/10)',c_ALAN',4);
    scatter(ISA,c_ALAN,160,[0.35 0.20 0.58],'o','filled','MarkerEdgeColor','k');
%     plot(ISA,c_ALAN,'-k','color',[0.35 0.20 0.58],'LineWidth',3);
    hold on
    plot(ISA,FitALAN,'-k','color',[0.35 0.20 0.58],'LineWidth',3);
%     hold on
%     scatter(All1(:,4),All1(:,3),20,[0.35 0.20 0.58],'o');
    hold on
    errorbar(ISA,c_ALAN,VarALAN,'o','color',[0.35 0.20 0.58],'LineWidth',1.5,...
        'MarkerEdgeColor',[0.35 0.20 0.58],'MarkerFaceColor',[0.35 0.20 0.58]);
    set(h3, 'yaxislocation', 'right','FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');
    set(gca,'color','none', 'color','none','ycolor',[0.35 0.20 0.58],'xlim',[0 xlim3(2)], ...
        'xtick',[],'yaxislocation','right','yminortick','off');
    set(gca,'YTickLabel',0:10:50);
    set(h3,'ticklength',xticklen);
    t = ttest2(c_ALAN,FitALAN,'Alpha',0.001);
    if R1 < 0.001
        text(min(ISA)+0.02,max(c_ALAN),strcat(' y = ',st1,', p < 0.001 '),'FontName','Arial','FontSize',32,'LineWidth',1.5,'FontWeight','bold','color',[0.2 0.70 0.30]);
    else
        text(min(ISA)+0.02,max(c_ALAN),strcat(' y = ',st1,', R^2 = ',num2str(round(R1,3))),'FontName','Arial','FontSize',32,'LineWidth',1.5,'FontWeight','bold','color',[0.2 0.70 0.30]);
    end    
    if R2 < 0.001
        text(min(ISA)+3,max(c_T)+0.2,strcat(' y = ',st2,', p < 0.001 '),'FontName','Arial','FontSize',32,'LineWidth',1.5,'FontWeight','bold','color',[0.8 0.2 0.1]);
    else
        text(min(ISA)+3,max(c_T)+0.2,strcat(' y = ',st2,', R^2 = ',num2str(round(R2,3))),'FontName','Arial','FontSize',32,'LineWidth',1.5,'FontWeight','bold','color',[0.8 0.2 0.1]);
    end
    if t == 0
        text(min(ISA)+0.1,min(c_ALAN)+2,strcat(' y = ',st3,', p < 0.001'),'FontName','Arial','FontSize',32,'LineWidth',1.5,'FontWeight','bold','color',[0.35 0.20 0.58]);
    else
        text(min(ISA)+0.1,min(c_ALAN)+2,strcat(' y = ',st3,', R^2 = ',num2str(round(R3,3))),'FontName','Arial','FontSize',32,'LineWidth',1.5,'FontWeight','bold','color',[0.35 0.20 0.58]);
    end
%     set(gca,'XTick',(0:1:10),'XTicklabels',str1,'FontName','Times New Roman','FontSize',16,'LineWidth',1.5,'FontWeight','bold');
%     set(h3,'FontName','Times New Roman','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    ylabel('ALAN (nW·cm·^-^2·sr^-^1)','FontName','Arial','FontSize',36,'LineWidth',1.5,'FontWeight','bold');

    box off
%  title('City Average','FontName', 'Times New Roman','FontSize',32,'FontWeight','bold');
% legend({"Obs","Fit","ErrorBar"},'box','off','FontName', 'Arial','FontSize',36,'FontWeight','bold');

 function [FitA,R,St] = FitCurve(X,Y,num)
 res = zeros(10,1);
 if num == 1
     X1 = X.*X;
     tb = table(X1,X,Y,'VariableNames',{'X1','X','Y'});
     lm = fitlm(tb,'Y~X1+X');
     res(:,1) = predict(lm,tb);
     b = lm.Coefficients.Estimate;
     R = lm.ModelFitVsNullModel.Pvalue;
     St = strcat(num2str(round(b(2),2)),'x^2+',num2str(round(b(3),2)),'x+',num2str(round(b(1),2))); %拟合的函数
 end
 if num == 2
     X1 = log(X);
%      Y1 = log(Y);
     tb = table(X1,Y,'VariableNames',{'X1','Y'});
     lm = fitlm(tb,'Y~X1');
     res(:,1) = predict(lm,tb);
     b = lm.Coefficients.Estimate;
%      res = exp(res);
     R = lm.ModelFitVsNullModel.Pvalue;
     St = strcat(num2str(round(b(2),2)),'ln(x)+',num2str(round(b(1),4))); %拟合的函数
 end

 if num == 3
     Y1 = log(Y-X(1,1));
     tb = table(X,Y1,'VariableNames',{'X','Y'});
     lm = fitlm(tb,'Y~X');
      res(:,1) = predict(lm,tb);
      b = lm.Coefficients.Estimate;
     res = exp(res)+X(1,1);
     R = lm.ModelFitVsNullModel.Pvalue;
     St = strcat(num2str(round(exp(b(2)),2)),'e^x+',num2str(round(X(1,1),2))); %拟合的函数
 end
  if num == 4
     x = X;
     y = Y;
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
        res(:,1)=fx(b,x);
     St = strcat(num2str(round(b(1),2)),'/(1+',num2str(round(b(2),2)),'exp(-',num2str(round(b(3),2)),'*x))'); %拟合的函数
 end
 FitA = res;
 end