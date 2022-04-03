function fig_valfun_and_policy_fun(L_grid,V_util,V_maximin,pi_util,pi_maximin,t_grid,c_path_util,c_path_maximin,L_path_util,...
    L_path_maximin,beta,theta,delta,tau_util,S_0_util,tau_maximin,S_0_maximin,optfig)
    
    L_steady_state_util = ones(length(t_grid),1);
    L_steady_state_util(:) = round((beta*(1-tau_util)*theta)^(1/(1-theta))/delta)*delta;
    
    L_steady_state_maximin = ones(length(t_grid),1);
    L_steady_state_maximin(:) = round((beta*(1-tau_maximin)*theta)^(1/(1-theta))/delta)*delta;
    
    c_steady_state_util = (1-tau_util).*L_steady_state_util.^theta + S_0_util - L_steady_state_util;
    c_steady_state_maximin = (1-tau_maximin).*L_steady_state_maximin.^theta + S_0_maximin - L_steady_state_maximin;
    
if optfig.plotfig == 1
    [fontname,dimension,lw,folder,color,style,~,~,fontsize_tit,~,fontsize_lab,fontsize_leg] = fn_optfig(optfig);
    
    f1 = figure('Units','inches','Position',dimension*2);
    
    subplot(2,2,1)
    plot(L_grid,V_util,'Color',color{2},'LineWidth',lw,'LineStyle',style{1}); hold on;
    plot(L_grid,V_maximin,'Color',color{4},'LineWidth',lw,'LineStyle',style{1}); hold off;
    xlabel('$L$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    ylabel('$V(L)$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    title('Value Function','interpreter','latex','FontSize',fontsize_tit,'FontName',fontname);
    grid; axis tight; box off;
    legendCell = {'Utilitarian','Maximin'};
    legend(legendCell,'interpreter','latex','FontSize',fontsize_leg,'FontName',fontname,'Location','Best')
    legend boxoff
    
    
    subplot(2,2,2)
    plot(L_grid,pi_util,'Color',color{2},'LineWidth',lw,'LineStyle',style{1}); hold on;
    plot(L_grid,pi_maximin,'Color',color{4},'LineWidth',lw,'LineStyle',style{1}); hold off;
    xlabel('$L$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    ylabel('$\pi(L)$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    title('Policy Function','interpreter','latex','FontSize',fontsize_tit,'FontName',fontname);
    grid; axis tight; box off;
    legendCell = {'Utilitarian','Maximin'};
    legend(legendCell,'interpreter','latex','FontSize',fontsize_leg,'FontName',fontname,'Location','Best')
    legend boxoff
    
    subplot(2,2,3)
    for i = 1:size(L_path_util,2)
        plot(t_grid,L_path_util(:,i),'Color',color{2},'LineWidth',1,'LineStyle',style{1}); hold on;
        plot(t_grid,L_path_maximin(:,i),'Color',color{4},'LineWidth',1,'LineStyle',style{1}); hold on;
    end
    plot(t_grid,L_steady_state_util,'Color','k','LineWidth',1,'LineStyle',style{2}); hold on;
    plot(t_grid,L_steady_state_maximin,'Color','k','LineWidth',1,'LineStyle',style{2}); hold off;
    xlabel('$t$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    ylabel('$L_t^*$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    title('Educational Investment Path','interpreter','latex','FontSize',fontsize_tit,'FontName',fontname);
    grid; axis tight; box off;
    legendCell = {'Utilitarian','Maximin'};
    legend(legendCell,'interpreter','latex','FontSize',fontsize_leg,'FontName',fontname,'Location','Best')
    legend boxoff
    
    subplot(2,2,4)
    for i = 1:size(c_path_util,2)
        plot(t_grid,c_path_util(:,i),'Color',color{2},'LineWidth',1,'LineStyle',style{1}); hold on;
        plot(t_grid,c_path_maximin(:,i),'Color',color{4},'LineWidth',1,'LineStyle',style{1}); hold on;
    end
    plot(t_grid,c_steady_state_util,'Color','k','LineWidth',1,'LineStyle',style{2}); hold on;
    plot(t_grid,c_steady_state_maximin,'Color','k','LineWidth',1,'LineStyle',style{2}); hold off;
    xlabel('$t$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    ylabel('$c_t^*$','interpreter','latex','FontSize',fontsize_lab,'FontName',fontname);
    title('Consumption Path','interpreter','latex','FontSize',fontsize_tit,'FontName',fontname);
    grid; axis tight; box off;
    legendCell = {'Utilitarian','Maximin'};
    legend(legendCell,'interpreter','latex','FontSize',fontsize_leg,'FontName',fontname,'Location','Best')
    legend boxoff
    
    
    name = 'at equilibria';
    print(f1,'-depsc','-painters','-noui','-r600', [folder,'individual_',name,'.eps'])
    
    if optfig.close == 1; close(who('f')); end
    
end
end