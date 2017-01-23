timespan = 60*1000; %ms
timeinterval = 10; %ms
nrofslots = timespan/timeinterval;

freqspan = 200e3; %hz : 125khz
freqinterval = 100; %hz
nrofchannels = ceil(freqspan / freqinterval);


interval = 10;
nrofpackets = 3;
packetduration = 2000;
maxnrofdevices = 10000;
devicestepsize = maxnrofdevices / interval;
results = zeros(maxnrofdevices/devicestepsize, 2);


nrofdevices = devicestepsize:devicestepsize:maxnrofdevices;

for nr = nrofdevices   
    nr
    ft = zeros(nrofslots, nrofchannels);
     
    ft2 = zeros(nrofslots, nrofchannels);
    colission = zeros(nr, nrofpackets);

    freq = randi([1 nrofchannels], [nr nrofpackets]);
    time = randi([1 nrofslots - (packetduration*nrofpackets)/timeinterval], [nr 1]);
    for i = 1:nr
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
                   %if  ft(j+time_offset, freq(i, p)+k) == 0
                   %    ft(j+time_offset, freq(i, p)+k) = 1;
                   %else
                   %     ft(j+time_offset, freq(i, p)+k) = 2;
                   %     colission(i, p) = 1;
                   %end
                   if  ft(j+time_offset, freq(i, p)+k) == 0
                       ft(j+time_offset, freq(i, p)+k) = 1;
                       ft2(j+time_offset,freq(i, p)+k) = i; 
                   else
                        ft(j+time_offset, freq(i, p)+k) = ft(j+time_offset, freq(i, p)+k) + 1;
                        colission(i, p) = 1;
                        colission(ft2(j+time_offset,freq(i, p)+k), p) = 1;
                   end
                end        
            end
            time_offset = time_offset + packetduration/timeinterval;
        end    
    end
    
    results(floor(nr/devicestepsize), 1) = sum(sum(colission));
    fail = sum(colission, 2) == nrofpackets;
    results(floor(nr/devicestepsize), 2) = sum(fail);
    results(floor(nr/devicestepsize), 3) = 100*sum(sum(fail))/nr;
    
    results(floor(nr/devicestepsize), 1)
    results(floor(nr/devicestepsize), 2)

end


figure1 = figure();
[hAx,hLine1,hLine2] = plotyy(nrofdevices,results(:, 1),nrofdevices,results(:, 3));
hold on;
%plot(hAx(1), nrofdevices,results(:, 1))%;,'-ro',nrofdevices,results(:, 1),'-.b')
plot(hAx(1),nrofdevices,results(:, 2),'-.b')
%ylim(hAx(1),[0 max(results(:, 1))])
hold off; 

if nrofpackets > 1
    titlestring = sprintf('SigFox packet collision simulation within 200 kH with %d devices \n(%d retries) transmitting randomly within 60 seconds', ...
        maxnrofdevices, nrofpackets);
else
    titlestring = sprintf('SigFox packet collision simulation within 200 kH with %d devices \n(%d retry) transmitting randomly within 60 seconds', ...
        maxnrofdevices, nrofpackets);
end



title(titlestring);
xlabel('Number of messages / minute') % x-axis label
%ylabel('Nr of colissions or Fails') % y-axis label
ylabel(hAx(1), 'Nr of collisions or Fails') % y-axis label
ylabel(hAx(2), 'Packet error rate (%)') % y-axis label
%legend('number of collission', 'number of failed transimssions');
legend('number of collisions','number of failed transmissions','packet error rate');


saveas(figure1, sprintf('sigfox_%d_dev_%d_tx.fig',maxnrofdevices, nrofpackets));
saveas(figure1, sprintf('sigfox_%d_dev_%d_tx.png',maxnrofdevices, nrofpackets));