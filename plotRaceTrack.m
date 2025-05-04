function [track_x, track_y, inner_x, inner_y, outer_x, outer_y] = plotRaceTrack(track)
%PLOTRACETRACK Plots a race track with centerline, inner, and outer boundaries.
%   [track_x, track_y] = plotRaceTrack(track) computes the X and Y coordinates
%   of a race track that consists of:
%       Section 1: Bottom straight
%       Section 2: Right semicircular arc
%       Section 3: Top straight
%       Section 4: Left semicircular arc
%   Input:
%       track - structure with fields:
%           .radius     : Radius of the curved sections (e.g., 200)
%           .straight   : Length of each straight section (e.g., 900)
%           .width      : Track width (e.g., 15)
%   Output:
%       track_x, track_y   - Arrays for the centerline coordinates.
%       inner_x, inner_y   - Arrays for the inner boundary coordinates.
%       outer_x, outer_y   - Arrays for the outer boundary coordinates.

% Ensure required fields exist
requiredFields = {'radius', 'straight', 'width'};
for i = 1:length(requiredFields)
    if ~isfield(track, requiredFields{i})
        error('track structure is missing the field "%s".', requiredFields{i});
    end
end

% Define number of points per segment for smooth plotting
nStraight = 1000;
nArc = 1000;

% Centerline track calculations
x1 = linspace(0, track.straight, nStraight);
y1 = zeros(1, nStraight);

theta2 = linspace(-pi/2, pi/2, nArc);
x2 = track.straight + track.radius * cos(theta2);
y2 = track.radius * (1 + sin(theta2));

x3 = linspace(track.straight, 0, nStraight);
y3 = 2 * track.radius * ones(1, nStraight);

theta4 = linspace(pi/2, 3*pi/2, nArc);
x4 = track.radius * cos(theta4);
y4 = track.radius * (1 + sin(theta4));

track_x = [x1, x2, x3, x4];
track_y = [y1, y2, y3, y4];

% Compute cumulative distance along the centerline
distances = [0, cumsum(sqrt(diff(track_x).^2 + diff(track_y).^2))];

% Smoothly varying unit tangent vectors
tangent_x = gradient(track_x)./gradient(distances);
tangent_y = gradient(track_y)./gradient(distances);

% Compute normal vectors (perpendicular to tangent vectors)
normal_x = -tangent_y;
normal_y = tangent_x;

% Normalize normal vectors to apply track width
norm_length = sqrt(normal_x.^2 + normal_y.^2);
normal_x = normal_x ./ norm_length;
normal_y = normal_y ./ norm_length;

% Calculate inner and outer boundaries
track_offset = track.width / 2;
inner_x = track_x - track_offset * normal_x;
inner_y = track_y - track_offset * normal_y;
outer_x = track_x + track_offset * normal_x;
outer_y = track_y + track_offset * normal_y;

% Plotting the track
figure;
hold on;
plot(track_x, track_y, 'b', 'LineWidth', 1); % Centerline
plot(inner_x, inner_y, 'k--', 'LineWidth', 1.5); % Inner boundary
plot(outer_x, outer_y, 'k--', 'LineWidth', 1.5); % Outer boundary
% Add start/finish line to existing plot
startLine_y = [-track.width/2, track.width/2];
plot([0, 0], startLine_y, 'g-', 'LineWidth', 3, 'DisplayName', 'Start/Finish Line');
hold off;
axis equal;
xlabel('X distance (m)');
ylabel('Y distance (m)');
title('Race Track');
xlim([-250 1150]);
ylim([-50 450]);
% make the figure fill the screen
%set(gcf, 'Units', 'normalized', 'OuterPosition', [0 0 1 1]); 
grid on;
end
