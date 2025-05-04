function animateVehicle(carX, carY, carPsi, carVxd, carLength, carWidth)
    %ANIMATEVEHICLE Animates a vehicle along the race track.
    %   animateVehicle(carX, carY, carPsi) uses the track coordinates to animate a
    %   vehicle represented as a patch object moving along the track.
    %   
    
    % Ensure inputs are column vectors
    carX = carX(:);
    carY = carY(:);
    carPsi = carPsi(:);
    
    numPoints = length(carX);
    
    % Initialize animated line for path
    trail = animatedline('Color', 'r', 'LineWidth', 2);
    
    % Define car shape as a rectangle centered at (0,0)
    carShape = [-carLength/2, carWidth/2;
                carLength/2, carWidth/2;
                carLength/2, -carWidth/2;
                -carLength/2, -carWidth/2]';

    % Initialize car representation (patch)
    rotatedCar = rotateAndTranslate(carShape, carX(1), carY(1), carPsi(1));
    car = patch(rotatedCar(1,:), rotatedCar(2,:), 'r', 'FaceColor', 'r');

    % Display velocity text
    %velocityText = text(450, 200, sprintf('Velocity: %.2f m/s', carVxd), 'FontSize', 14, 'FontWeight', 'bold', 'Color', 'k', 'HorizontalAlignment', 'center', 'BackgroundColor', 'w');

    % Animation loop
    for i = 1:numPoints-1
        numSteps = 5; % Fixed step resolution for smooth animation
        stepX = linspace(carX(i), carX(i+1), numSteps);
        stepY = linspace(carY(i), carY(i+1), numSteps);
        stepPsi = linspace(carPsi(i), carPsi(i+1), numSteps);

        for j = 1:numSteps
            % Rotate and move car
            rotatedCar = rotateAndTranslate(carShape, stepX(j), stepY(j), stepPsi(j));
            set(car, 'XData', rotatedCar(1,:), 'YData', rotatedCar(2,:));

            % Update path
            addpoints(trail, stepX(j), stepY(j));

            % Refresh plot
            drawnow limitrate;
            %pause(0.15 / carVxd); % ADJUSTING THE NUMERATOR CHANGES THE SPEED OF THE SIMULATION (LOWER IS FASTER)
        end
    end
end

% Helper function: Rotates and moves car
function newCoords = rotateAndTranslate(shape, x, y, theta)
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    newCoords = R * shape; % Rotate
    newCoords(1,:) = newCoords(1,:) + x; % Translate X
    newCoords(2,:) = newCoords(2,:) + y; % Translate Y
end
