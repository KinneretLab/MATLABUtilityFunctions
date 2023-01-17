function [time_sec] = getTimeStamps(timeStampDir,movieName,frame)

% This function reads the saved timestamps extracted from the metadata for
% slidebook timelapse data and returns the list of time stamps (in seconds)
% as a vector. If only certain frames are wanted, they can be specified as
% a vector in frames. If all are needed, frames should be empty.
thisDir = timeStampDir;
files = dir(timeStampDir);
findFile = find(contains({files.name},movieName));
thisFileName = files(findFile).name;

time_sec = table2array(readtable([thisDir,'\',thisFileName]));

if isempty(frame)
    frame = 1:length(time_sec)
end

time_sec = time_sec(frame);

end

