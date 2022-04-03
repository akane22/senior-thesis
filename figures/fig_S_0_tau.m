function fig_S_0_tau(taus_plot,S_0_plot,Y,t_underbar,t_overbar,optfig)

if optfig.plotfig == 1
    
    gridd = 0:0.001:1;
    [fontname,dimension,lw,folder,color,style,marker,markersize,fontsize_tit,~,fontsize_lab,fontsize_leg] = fn_optfig(optfig);
    
    f1 = figure('Units','inches','Position',[0 0 8 4]);
    
    subplot(1,2,1)
    plot(taus_plot,S_0_plot,    'Color',color{1},'LineWidth',lw,'LineStyle',style{1}); hold on;
    plot(gridd,0*gridd,'Color','k','LineWidth',1,'LineStyle',style{2}); hold on;
    plot(t_underbar,0,'Marker',marker{2},'MarkerSize',8,'MarkerFaceColor', color{5})
    plot(t_overbar,0,'Marker',marker{2},'MarkerSize',8,'MarkerFaceColor', color{3})
    
        xlabel('$\tau$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
         ylabel('$S_0(\tau)$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    title('Subsidies','interpreter','latex','FontSize',fontsize_tit,'FontName',fontname);
    grid; axis([0 1 -0.01 1.1*max(S_0_plot)]); box off;
    
       legendCell = {'','','', ''};
    
    legend(legendCell,'interpreter','latex','FontSize',fontsize_leg,'FontName',fontname,'Location','NorthWest')
    legend boxoff
    
    subplot(1,2,2)
    plot(taus_plot,Y,'Color',color{2},'LineWidth',lw,'LineStyle',style{1}); hold on;
    xlabel('$\tau$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    ylabel('$Y(\tau)$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    title('Aggregate Earnings','interpreter','latex','FontSize',fontsize_tit,'FontName',fontname);
    grid; axis([t_underbar t_overbar -0.1+min(Y) 0.1+max(Y)]); box off;
    legendCell = {''};
    
    legend(legendCell,'interpreter','latex','FontSize',fontsize_leg,'FontName',fontname,'Location','NorthEast')
    legend boxoff
    
   
    
    name = 'fig 3';
    print(f1,'-depsc','-painters','-noui','-r600', [folder,name,'.eps'])
    if optfig.close == 1; close(who('f')); end
    
end  

end
