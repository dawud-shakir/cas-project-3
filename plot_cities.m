
function plot_cities(x,y)


    plot(x,y,'k-o',...
        'MarkerSize',10,...
        'MarkerFaceColor','g',...
        'LineWidth',1.5);
    n = length(x);
    title([num2str(n) ' cities'])
    xlabel('x');
    ylabel('y');
    
xlim([0,100]);
ylim([0,100]);
    grid on;
    
end