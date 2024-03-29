clc;
clear

load VPNNH_slope_rank;
load VPNNH_Citylist;
load SOSCityparCor.mat;
load EOSCityparCor.mat;

parCorr = zeros(2,length(VPNNH_slope_rank),2);
parCorr(1,:,:) = SOSCityparCor(:,1,:);
parCorr(2,:,:) = EOSCityparCor(:,1,:);

indxNum = zeros(length(VPNNH_slope_rank),2);
for i = 1:length(VPNNH_slope_rank)
    kk(:,:) = parCorr(:,i,:);
    for j = 1:2
        if kk(j,1)*kk(j,2) < 0
            [m1,n1] = max(abs(kk(j,:)));
            indxNum(i,j) = n1;
        else
            [m1,n1] = max(kk(j,:));
            indxNum(i,j) = n1;
        end
    end
end

Corsd = zeros(2,2);
for i = 1:2
    for j = 1:2
        k(:,1) = parCorr(i,:,j);
        k(all(isnan(k),2),:) = [];
        Corsd(i,j) = std(k);
        clear k;
    end
end


edges = [-1:0.02:1];
str1 = {'SOS','EOS'};
str2 = string(str1);
avResP = zeros(2,2);
figure(1)
for pheno = 1:2
    subplot(1,2,pheno);   
    parT1(:,:) = parCorr(pheno,:,1);
    parT1(isnan(parT1)) = [];
    avResP(pheno,1) = round(nanmean(parT1),2);
%             [f2,x2] = ksdensity(parT1);
%          [k42,s42] = aver(x2,f2);       
%         plot(x2,f2,'Color',[0.49 0.18 0.56],'LineWidth',2);
%         hold on
%         plot([k42 k42],[0,s42],'--','Color',[0.49 0.18 0.56],'LineWidth',1);
% 
    h1 = histogram(parT1,edges,'Normalization','probability');
    h1.FaceColor = [0.86 0.43 0.34];
    h1.LineWidth = 0.8;
    h1.FaceAlpha = 0.7;
    h1.EdgeColor = [0.86 0.43 0.34];
   y1 = h1.Parent.YLim;
%            set(gca,'YTick',(0:0.02:y1(1,2)+0.005));

%         set(gca,'YTickLabels',(0:0.02:y1(1,2)+0.005),'FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
%     set(gca,'XTick',(-1:0.5:1),'FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
% 
%     xlabel('Correlation','FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
%     ylabel('Frequency','FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');

    hold on
    parAlan(:,:) = parCorr(pheno,:,2);
    parAlan(isnan(parAlan)) = [];
    avResP(pheno,2) = round(nanmean(parAlan),2);
    
%             [f4,x4] = ksdensity(parAlan);
%         [k44,s44] = aver(x4,f4);
%         plot(x4,f4,'Color',[0 0.50 0.40],'LineWidth',2);
%         hold on
%         plot([k44 k44],[0,s44],'--','Color',[0 0.50 0.40],'LineWidth',1);

    h2 = histogram(parAlan,edges,'Normalization','probability');
    h2.FaceColor = [0.47 0.44 0.70];
    h2.FaceAlpha = 0.7;
    h2.LineWidth = 0.8;
    h2.EdgeColor = [0.47 0.44 0.70];
%     hold on
   y1 = h2.Parent.YLim;

line([avResP(pheno,2),avResP(pheno,2)],[0 0.05],'color',[0.47 0.44 0.70],'linestyle','--','LineWidth',3);
acst2 = [num2str(round(avResP(pheno,2),2))+" ± " + num2str(round(Corsd(pheno,2),2))];
text(avResP(pheno,2)+avResP(pheno,2)*0.1,y1(1,2)-0.015,acst2,'FontName','Arial','FontSize',30,'Color',[0.47 0.44 0.70],'FontWeight','bold');
    line([avResP(pheno,1),avResP(pheno,1)],[0 0.05],'color',[0.86 0.43 0.34],'linestyle','--','LineWidth',3);
    acst1 = [num2str(round(avResP(pheno,1),2))+" ± " + num2str(round(Corsd(pheno,1),2))];
text(avResP(pheno,1)-avResP(pheno,1)*0.1,y1(1,2)-0.005,acst1,'FontName','Arial','FontSize',30,'Color',[0.86 0.43 0.34],'FontWeight','bold');

    set(gca,'XTick',(-1:0.5:1),'FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
    xlabel('R','FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
    ylabel('Frequency','FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
    title(str2(pheno),'FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');
               set(gca,'YTick',(0:0.02:0.05));

        set(gca,'YTickLabels',(0:0.02:0.05),'FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold');

    clear parT1 parAlan;
end
%  legend({'Ta','Ta_a_v', 'ALAN','ALAN_a_v'},'FontName','Times New Roman','FontSize',18,'LineWidth',1.5,'FontWeight','bold');
 legend({'R_T_a', 'R_A_L_A_N'},'FontName','Arial','FontSize',30,'LineWidth',1.5,'FontWeight','bold',"Box","off");

 function [z1,z2] = aver(x,y)
 l = length(x);
 wb = x(2)-x(1);
 L = [1:1:l];
 c = 0;
 for i = 1:l
     if abs(c-0.5)<0.02
         break;
     else
         c = y(i)*wb + c;
     end
 end
 z1 = x(i);
 z2 = y(i);
 end