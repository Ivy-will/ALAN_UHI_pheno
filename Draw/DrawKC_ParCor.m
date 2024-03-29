clc;
clear

load KCsosPcor;
load KCeosPcor;
load KCsosPerCity;
load KCeosPerCity;

KCsosPerCity(6,:,:) = [];
KCeosPerCity(6,:,:) = [];

str1 =  {'BW','BS','Cs','Cw','Cf','Ds','Dw','Df'};
str2 =  {'BW','BS','Cs','Cw','Cf','Dw','Df'};

for i = 2:2
    figure(i)
    if i == 1
        Csos(:,:) = KCsosPcor(:,1,:);
        PTsos(:,:) = KCsosPcor(:,2,:);
        Ceos(:,:) = KCeosPcor(:,1,:);
        Peos(:,:) = KCeosPcor(:,2,:);
    else
        Csos(:,:) = KCsosPerCity(:,1,:);
        PTsos(:,:) = KCsosPerCity(:,2,:);
        Ceos(:,:) = KCeosPerCity(:,1,:);
        Peos(:,:) = KCeosPerCity(:,2,:);
    end
    Csos = fliplr (Csos);
    PTsos = fliplr (PTsos);
    Ceos = fliplr (Ceos);
    Peos = fliplr (Peos);
    len = length(Csos);
    subplot(2,2,1)
%     PTsos(find(PTsos>0.05)) = NaN;
    GSOS = bar(Csos,1,'EdgeColor','k');
    GSOS(1).FaceColor = [0.35 0.20 0.58];
    GSOS(1).FaceAlpha = 0.6;
    GSOS(2).FaceColor = [0.8 0.2 0.1];
    GSOS(2).FaceAlpha = 0.4;
    hold on
    sosX1 = (0.85: 1:len-1+0.85);
    sosY1 = PTsos(:,1);
    sosX1(isnan(sosY1)) = NaN;
    sosZ1 = abs(Csos(:,1))+0.03;
    hold on
    errorbar(sosX1,Csos(:,1),PTsos(:,1),'-k', 'Linestyle', 'None','LineWidth',2);
        hold on
    errorbar(sosX1+0.3,Csos(:,2),PTsos(:,2),'-k', 'Linestyle', 'None','LineWidth',2);
    if i == 1
        plot(sosX1,sosZ1,'*','LineWidth',1.5,'Color',[0.8 0.2 0.1]);

        % hold on
% errorbar(alanx1,MeanY2,VarY2,'-k', 'Linestyle', 'None','LineWidth',0.5);
    end
    hold on
    sosX2 = (1.15: 1:len-1+1.15);
    sosY2 = PTsos(:,2);
    sosX2(isnan(sosY2)) = NaN;
    sosZ2 = abs(Csos(:,2))+0.03;
    if i == 1
        plot(sosX2,sosZ2,'*','LineWidth',1.5,'Color',[0.35 0.20 0.58]);
    end
    labelText1 = (1: 1:len);
    set(gca,'XTick',labelText1,'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    if i == 1
        set(gca,'XTicklabels',str1,'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    else
        set(gca,'XTicklabels',str2,'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    end
    title('SOS','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    ylabel('R','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    
    subplot(2,2,2)
%     Peos(find(Peos>0.05)) = NaN;
    GSOS = bar(Ceos,1,'EdgeColor','k');
    GSOS(1).FaceColor = [0.35 0.20 0.58];
    GSOS(1).FaceAlpha = 0.6;
    GSOS(2).FaceColor = [0.8 0.2 0.1];
    GSOS(2).FaceAlpha = 0.4;
    hold on
    sosX1 = (0.85: 1:len-1+0.85);
    sosY1 = Peos(:,1);
    sosX1(isnan(sosY1)) = NaN;
    sosZ1 = abs(Ceos(:,1))+0.03;
        hold on
    errorbar(sosX1,Ceos(:,1),Peos(:,1),'-k', 'Linestyle', 'None','LineWidth',2);
        hold on
    errorbar(sosX1+0.3,Ceos(:,2),Peos(:,2),'-k', 'Linestyle', 'None','LineWidth',2);
    if i == 1
        plot(sosX1,sosZ1,'*','LineWidth',1.5,'Color',[0.8 0.2 0.1]);
    end
    hold on
    sosX2 = (1.15: 1:len-1+1.15);
    sosY2 = Peos(:,2);
    sosX2(isnan(sosY2)) = NaN;
    sosZ2 = abs(Ceos(:,2))+0.03;
    if i == 1
        plot(sosX2,sosZ2,'*','LineWidth',1.5,'Color',[0.35 0.20 0.58]);
    end
    labelText1 = (1: 1:7);
    set(gca,'XTick',labelText1,'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    if i == 1
        set(gca,'XTicklabels',str1,'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    else
        set(gca,'XTicklabels',str2,'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    end
    title('EOS','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
%     ylabel('Partial Correlation','FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold');
    legend({'R_A_L_A_N','R_T_a' },'FontName','Arial','FontSize',28,'LineWidth',1.5,'FontWeight','bold','Box','off');
%     clear Csos PTsos Ceos Peos;
end
