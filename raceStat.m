function [numLoops, completionTime, wentOutside] = raceStat(carX, carY, carTime, trackInnerX, trackInnerY, trackOuterX, trackOuterY)
    % Going to determine the number of loops completed, completion time, and
    % whether the vehicle is outside of the track or not 
    
    % calculate the distance between the car's position and the inner and
    % outer boundary. use this distance and make a polygon between the
    % track boundaries and check if the car is within that polygon.
    
    % we can measure the time values when the all the checkpoints are met to
    % determine how long it takes the car to make it around the track
    
    % for each point we are going to take in the x value and compare it's
    % corresponding y value with the track inside/outside limits to determine
    % if it is on or off the track

    % initialize important variables
    numLoops = 0;
    wentOutside = false;
    completionTime = 0;
    trackWidth = 15;
    
    % make sure arrays are not column vectors
    carX = carX(:);
    carY = carY(:);
    
    % switch the inner and outer track diameter to fix the polygon
    % generation issue
    actualInnerX = trackOuterX(:);
    actualInnerY = trackOuterY(:);
    actualOuterX = trackInnerX(:);
    actualOuterY = trackInnerY(:);
    
    % hold the figure for plotting
    hold on;

    % initialize the race stat log
    debugLog = fopen('race_stat.log', 'w');
    fprintf(debugLog, 'Starting race analysis...\n');
    
    % For each car position
    for i = 1:length(carX)
        % check if the car is within the track boundary
        [isOnTrack, dist_inner, dist_outer] = isPointInTrack(carX(i), carY(i), actualInnerX, actualInnerY, actualOuterX, actualOuterY);
        
        if ~isOnTrack % if the car went off the track
            wentOutside = true;
            % put the restults into the race stat log to save the results
            fprintf(debugLog, 'Car went outside track at point (%f, %f)\n', carX(i), carY(i));
            fprintf(debugLog, 'Distance to inner boundary: %f\n', dist_inner);
            fprintf(debugLog, 'Distance to outer boundary: %f\n', dist_outer);
            
            % Add off-track marker to the existing track plot to show where
            % it went off the track
            plot(carX(i), carY(i), 'mx', 'MarkerSize', 20, 'LineWidth', 4, 'DisplayName', 'Off Track Point');
            break;
        end
        
        % Lap detection - crossing start/finish line at x=0 and y= +-7.5
        if i > 1
            % Check if car crossed x=0 line from negative to positive x
            if carX(i-1) < 0 && carX(i) >= 0
                % Check if it crossed at y values of the start line
                if abs(carY(i)) <= trackWidth/2
                    % increase the number of loops and put this onto the
                    % race stat log file
                    numLoops = numLoops + 1;
                    completionTime = carTime(i);
                    fprintf(debugLog, 'Lap %d completed at time %f\n', numLoops, completionTime);
                    
                    % Add lap completion marker to existing plot
                    plot(carX(i), carY(i), 'go', 'MarkerSize', 15, 'LineWidth', 2, 'DisplayName', sprintf('Lap %d Complete', numLoops));
                end
            end
        end
    end
    
    % add info to the race stat log if a lap was never completed
    if numLoops == 0
        completionTime = NaN; % No complete loops detected
        fprintf(debugLog, 'No complete laps detected\n');
    end
    
    % add all the other results to the race stat log
    fprintf(debugLog, '\nFinal Results:\n');
    fprintf(debugLog, 'Number of loops completed: %d\n', numLoops);
    if isnan(completionTime)
        fprintf(debugLog, 'Completion time: No complete loops detected\n');
    else
        fprintf(debugLog, 'Completion time: %.2f seconds\n', completionTime);
    end
    fprintf(debugLog, 'Car went outside track: %s\n', mat2str(wentOutside));
    
    fclose(debugLog);
    
    % display all the results in the command window
    fprintf('Number of loops completed: %d\n', numLoops);
    if isnan(completionTime)
        fprintf('Completion time: No complete loops detected\n');
    else
        fprintf('Completion time: %.2f seconds\n', completionTime);
    end
    fprintf('Car went outside track: %s\n', mat2str(wentOutside));
end


% this subfunction checks the distance to the inner and outer track
% boundaries and determines if it is between them or not
function [isOnTrack, dist_inner, dist_outer] = isPointInTrack(px, py, innerX, innerY, outerX, outerY)
    % Calculate minimum distances to boundaries
    dist_inner = min(sqrt((px - innerX).^2 + (py - innerY).^2));
    dist_outer = min(sqrt((px - outerX).^2 + (py - outerY).^2));
    
    % Check if point is between boundaries using the inpolygon function
    isInsideOuter = inpolygon(px, py, outerX, outerY);
    isOutsideInner = ~inpolygon(px, py, innerX, innerY);
    
    % set the return variable depending on the results from the inpolygon
    % function
    isOnTrack = isInsideOuter && isOutsideInner;
end
