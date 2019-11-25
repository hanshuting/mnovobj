function [] = visualizeNor(segmat,obj_time,obj_num,obj_region,ifsave)

dims = size(segmat);

if ifsave
    c = clock;
    writerobj = VideoWriter(['C:\Users\shuting\Desktop\temp\outputs\' ...
        num2str(c(1)) num2str(c(2)) num2str(c(3)) num2str(c(4)) num2str(c(5))...
        num2str(round(c(6))) '.avi']);
    open(writerobj);
end

hf = figure;set(gcf,'color','w');
for i = 1:dims(3)
    obj_mask = sum(obj_region,3);
    if obj_time(i)~=0
        obj_mask = obj_mask+obj_region(:,:,obj_num(i));
    end
    imagesc(double(segmat(:,:,i))*3+double(obj_mask));
    colormap(hot);caxis([0 3])
    axis equal off tight
    keypressed = get(hf,'currentkey');
    title(num2str(i));
    
    if ifsave
        F = getframe(hf);
        writeVideo(writerobj,F);
    end
    
    pause(0.01);
    if keypressed=='e'
        close(hf);
        return;
    end
end

if ifsave
    close(writerobj);
    close(hf);
end

end