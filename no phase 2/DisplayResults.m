% Display results
function DisplayResults(SimParams, Samples)
    
    % Close all previous windows
    close all;
    
    % Create plotting windows
    figure(1);set(gcf,'Position',[ 20 300 390 290]);
    figure(2);set(gcf,'Position',[440 300 390 290]);
    figure(3);set(gcf,'Position',[860 300 390 290]);
    
    if(SimParams.Steps.ilearn > SimParams.Steps.finalWilearn)
        if(SimParams.Steps.ilearn > SimParams.Steps.tinnitusilearn)
            figure(1);
            subplot(2,2,1),plot(1:SimParams.Steps.finalWilearn,SimParams.Cost.err(1:SimParams.Steps.finalWilearn),'r--',SimParams.Steps.finalWilearn+1:SimParams.Steps.tinnitusilearn,SimParams.Cost.err(SimParams.Steps.finalWilearn+1:SimParams.Steps.tinnitusilearn),'g-.',SimParams.Steps.tinnitusilearn+1:SimParams.Steps.ilearn,SimParams.Cost.err(SimParams.Steps.tinnitusilearn+1:SimParams.Steps.ilearn),'b-');
            xlabel('learning steps');ylabel('cost');title('Cost Function');
            subplot(2,2,2),plot(1:SimParams.Steps.finalWilearn,SimParams.Cost.err(1:SimParams.Steps.finalWilearn),'r--');
            xlabel('learning steps');ylabel('cost');title('W-learn: Cost Function');
            subplot(2,2,4),plot(SimParams.Steps.finalWilearn+1:SimParams.Steps.tinnitusilearn,SimParams.Cost.err(SimParams.Steps.finalWilearn+1:SimParams.Steps.tinnitusilearn),'g-.');
            xlabel('learning steps');ylabel('cost');title('K-learn: Cost Function');
            subplot(2,2,3),plot(SimParams.Steps.tinnitusilearn+1:SimParams.Steps.ilearn,SimParams.Cost.err(SimParams.Steps.tinnitusilearn+1:SimParams.Steps.ilearn),'b-');
            xlabel('learning steps');ylabel('cost');title('Tinnitus: Cost Function');
        else
            figure(1);
            subplot(2,2,[1 2]),plot(1:SimParams.Steps.finalWilearn,SimParams.Cost.err(1:SimParams.Steps.finalWilearn),'r--',SimParams.Steps.finalWilearn+1:SimParams.Steps.ilearn,SimParams.Cost.err(SimParams.Steps.finalWilearn+1:SimParams.Steps.ilearn),'b-');
            xlabel('learning steps');ylabel('cost');title('Cost Function');
            subplot(2,2,3),plot(1:SimParams.Steps.finalWilearn,SimParams.Cost.err(1:SimParams.Steps.finalWilearn),'r--');
            xlabel('learning steps');ylabel('cost');title('W-learn: Cost Function');
            subplot(2,2,4),plot(SimParams.Steps.finalWilearn+1:SimParams.Steps.ilearn,SimParams.Cost.err(SimParams.Steps.finalWilearn+1:SimParams.Steps.ilearn),'b-');
            xlabel('learning steps');ylabel('cost');title('K-learn: Cost Function');
        end
    else
        figure(1);plot(1:SimParams.Steps.ilearn,SimParams.Cost.err(1:SimParams.Steps.ilearn),'b-');
        xlabel('learning steps');ylabel('cost');title('Cost Function');
    end
    
    figure(2);
    subplot(2,2,1),imagesc(SimParams.net.W);colormap('gray');colorbar;title('W');
    subplot(2,2,2),plot(1:SimParams.net.Inputs,SimParams.net.W(SimParams.net.Outputs/2,1:SimParams.net.Inputs),'b-');xlabel('column');ylabel('value');title('W row');set(gca,'XTick',0:SimParams.net.Inputs/2:SimParams.net.Inputs);
    subplot(2,2,3),imagesc(SimParams.net.K);colormap('gray');colorbar;title('K');
    tmp = SimParams.net.K(SimParams.net.Outputs / 2,:);
    tmp(SimParams.net.Outputs / 2) = NaN;%(tmp(SimParams.net.Outputs / 2 - 1) + tmp(SimParams.net.Outputs / 2 + 1)) / 2;
    subplot(2,2,4),plot(1:SimParams.net.Outputs, tmp,'b-');xlabel('column');ylabel('value');title('K row');set(gca,'XTick',0:SimParams.net.Outputs / 2:SimParams.net.Outputs);
    
    figure(3);
    x = Samples.x(:, randi(size(Samples.x, 2)));
    subplot(2,2,1),plot(x, 'b-');ylabel('value');title('Typical Input');
    subplot(2,2,3),plot(SimParams.net.Evaluate(x), 'b-');ylabel('value');title('Network''s Output');%set(gca,'YLim',[0,1],'YTick',0:0.5:1);
    s = zeros(size(x));
    subplot(2,2,2),plot(s, 'b-');ylabel('value');title('Silence Input');
    subplot(2,2,4),plot(SimParams.net.Evaluate(s), 'b-');ylabel('value');title('Network''s Output');%set(gca,'YLim',[0,1],'YTick',0:0.5:1);
    
    drawnow
    
end