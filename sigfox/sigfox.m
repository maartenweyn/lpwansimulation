timespan = 60*1000; %ms
timeinterval = 10; %ms
nrofslots = timespan/timeinterval;

freqspan = 200e3; %hz : 125khz -> 868.7 - 869.2 MHZ
freqinterval = 100; %hz
nrofchannels = ceil(freqspan / freqinterval);

ft = zeros(nrofslots, nrofchannels);

nrofdevices = 1000;
nrofpackets = 3;
packetduration = 2000;

colission = zeros(nrofdevices, nrofpackets);

freq = randi([1 nrofchannels], [nrofdevices nrofpackets]);
time = randi([1 nrofslots - (packetduration*nrofpackets)/timeinterval], [nrofdevices 1]);
for i = 1:nrofdevices
    time_offset = time(i, 1);
    
    for p = 1:nrofpackets    
        for k = -1:1:1
            if (freq(i, p)+k<1) | (freq(i, p)+k>nrofchannels)
                continue
            end
            for j = 1:packetduration/timeinterval
               %freq(i, 1)
               if j+time_offset > nrofslots
                   continue
               end
               if  ft(j+time_offset, freq(i, p)+k) == 0
                   ft(j+time_offset, freq(i, p)+k) = 1;
               else
                    ft(j+time_offset, freq(i, p)+k) = 2;
                    colission(i, p) = 1;
               end
            end        
        end
        time_offset = time_offset + packetduration/timeinterval;
    end    
end

%colission
fail = sum(colission, 2) == nrofpackets;
sum(fail)

ft(1,1) = 1;
ft(1,2) = 2;
figure1 = figure();
pcolor(ft);

map2 = [0 0 0;  0 1 0 ;0 0.5 0; 0.6 0 0;];
colormap(map2);
shading flat;
if nrofpackets > 1
    titlestring = sprintf('SigFox packet collision simulation within 200 kH with %d devices\n (%d retries) transmitting randomly within 60 seconds', ...
        nrofdevices, nrofpackets);
else
    titlestring = sprintf('SigFox packet collision simulation within 200 kH with %d devices\n (%d retry) transmitting randomly within 60 seconds', ...
        nrofdevices, nrofpackets);
end
    

title(titlestring);
xlabel('Frequency (kHz)') % x-axis label
ylabel('Time (10 ms)') % y-axis label
ax = gca;




pause(50);
saveas(figure1, sprintf('sigfox_spectrum_%d_dev_%d_tx.png',maxnrofdevices, nrofpackets));
saveas(figure1, sprintf('sigfox_spectrum_%d_dev_%d_tx.fig',maxnrofdevices, nrofpackets));