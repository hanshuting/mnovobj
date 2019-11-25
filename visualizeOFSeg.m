function [] = visualizeOFSeg(data,centroid,theta,ifsave)

scale = 1;
l_ar = 50;
dims = size(data);
mi = min(data(:));
ma = scale*max(data(:));
hf = figure;
set(hf,'color','w');

if ifsave
    c = clock;
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    open(writerobj);
end

while true
    for i = 1:dims(3)
        imagesc(data(:,:,i),[mi ma]);
        hold on;scatter(centroid(i,1),centroid(i,2),'r*');
        quiver(centroid(i,1),centroid(i,2),cos(degtorad(theta(i)))*l_ar,...
           -sin(degtorad(theta(i)))*l_ar,'b');
        hold off;
        title(['t=' num2str(i)]);
%         title(num2str(theta(i)));
        colormap(hot);
        axis equal off tight
        xlim([0 dims(1)]);ylim([0 dims(2)]);
        keypressed = get(hf,'currentkey');
        pause(0.01);
        
%         if i==200
%             i;
%         end
        
        if ifsave
            F = getframe(hf);
            writeVideo(writerobj,F);
        end
        
        if keypressed=='e'
            close(hf);
            return;
        end
            
        if i == dims(3)
            if ifsave
                close(writerobj);
                close(hf);
                return;
            else
                i = 1;
            end
        end
    end
end


end