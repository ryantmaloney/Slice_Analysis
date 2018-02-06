function lpArvoData(events_struct, file_name)

if exist(file_name, 'var')
    file_name='lpTestExport.csv';
end

disp(file_name);
fileID = fopen(file_name,'w');

% fprintf(fileID, 'Frame, Channel, Event Number, Location, cellNum, mouse_dob, litter, toe, stim_duration \n');

fnms=fieldnames(events_struct);
preamblenames=['Frame, Channel, Event Number,'];
for f=2:length(fnms)
    preamblenames=sprintf('%s%s, ', char(preamblenames), char(fnms(f)));
end

fnms_frame=fieldnames(events_struct.frames);

for f=2:length(fnms_frame)
    preamblenames=sprintf('%s%s, ', char(preamblenames), char(fnms_frame(f)));
end

fnms_chan=fieldnames(events_struct.frames(1).channels);

for f=2:length(fnms_chan)
    preamblenames=sprintf('%s%s, ', char(preamblenames), char(fnms_chan(f)));
end

fnms_evnt=fieldnames(events_struct.frames(1).channels(1).events);

for f=1:length(fnms_evnt)
    preamblenames=sprintf('%s%s, ', char(preamblenames), char(fnms_evnt(f)));
end

disp(preamblenames);

fprintf(fileID, [preamblenames, '\n']);

%File
location=events_struct.location;
cellNum=events_struct.cellNum;
mouse_dob=events_struct.mouse_dob;
litter=events_struct.litter;
toe=events_struct.toe;
mouse=events_struct.mouse;

% location='dLGN';
% cellNum=1;
% mouse_dob='1-2-2001';
% litter='';
% toe=1;
% whos
%5 file traits
% fileTraits=[location,',']
fileTraits=[location,',', num2str(cellNum),',', mouse_dob,',', litter,',', num2str(toe), ',', num2str(mouse), ','];
% disp(fileTraits);
numframes=length(events_struct.frames);

for i=1:numframes
%    disp(events_struct.frames(i).channels)
   numChannels=length(events_struct.frames(i).channels); 
%    disp(events_struct.frames(i).channels);
%    disp(numChannels);
   frameTraits=[events_struct.frames(i).IVmode, ',', num2str(events_struct.frames(i).Holding), ',',...
       events_struct.frames(i).stim_shape, ',',...
       num2str(events_struct.frames(i).stim_duration),...
       ',', num2str(events_struct.frames(i).stim_freq_max), ',',...
       num2str(events_struct.frames(i).stim_freq_min), ',', num2str(events_struct.frames(i).stim_amp_max), ',',...
       num2str(events_struct.frames(i).stim_amp_max), ','];
   
%   disp(frameTraits);
%   disp(numChannels);

	for j=1:numChannels
        if ~isempty(events_struct.frames(i).channels(j).events)
%             disp(j)
            units_stripped=events_struct.frames(i).channels(j).units;
            if units_stripped(1)=='%'
                units_stripped=units_stripped(2:end);
            end
            
            numEvents=length(events_struct.frames(i).channels(j).events);
            channelTraits=[num2str(events_struct.frames(i).channels(j).baseIV), ',',...
                units_stripped, ','];
            
%             disp(events_struct.frames(i).channels(j).units);

            for k=1:numEvents
                preamble=[num2str(i),',', num2str(j),',',num2str(k),','];
                eventTraits=[num2str(events_struct.frames(i).channels(j).events(k).start), ',' ,...
                    num2str(events_struct.frames(i).channels(j).events(k).polarity), ',' ,...
                    num2str(events_struct.frames(i).channels(j).events(k).stop), ',' ,...
                    num2str(events_struct.frames(i).channels(j).events(k).amplitude)];
%               	disp([preamble, fileTraits, frameTraits, channelTraits, eventTraits, '\n']);
                
                fprintf(fileID, [preamble, fileTraits, frameTraits, channelTraits, eventTraits, '\n']);
%               fprintf(fileID, '%d, %d, %d, %s, %d, %s, %s, %d \n', i, j, k, location, cellNum, mouse_dob, litter, toe);
            end
        end
    end
end

fclose(fileID);

end