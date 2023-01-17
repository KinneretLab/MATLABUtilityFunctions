function forceSave(obj, file_path)
    dir_path = fileparts(file_path);
    if ~exist(dir_path, 'dir')
        mkdir(dir_path);
    end
    done = false;
    while ~done
        try
            saveas(obj, file_path);
            done = true;
        catch e
            warning(e.message);
            pause(0.1);
        end
    end
end