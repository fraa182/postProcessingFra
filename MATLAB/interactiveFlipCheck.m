function [x,y,z,flipFlag] = interactiveFlipCheck(x,y,z)
    % Rotate the geometry initially based on the currentAxis

    pointsFinal = [x y z];
    
    % Create the UI figure
    fig = uifigure('Name', 'Flip Check', 'Position', [640 140 800 800]);
    
    % Plot area for the rotated geometry
    ax = uiaxes(fig, 'Position', [50, 200, 700, 500]);
    plotGeometry(ax, [x y z]);

    % Create a label for displaying messages
    messageLabel = uilabel(fig, ...
                       'Position', [300, 70, 500, 30], ...
                       'Text', "Select an option and press 'Run'",...
                       'HorizontalAlignment','left');
    
    % Create a button group for flip choice
    buttonGroup = uibuttongroup(fig, ...
                                'Position', [300, 100, 200, 80], ...
                                'Title', 'Flip Choice');
                            
    % Create radio buttons within the button group
    uiradiobutton(buttonGroup, ...
                             'Text', 'NOT flip', ...
                             'Position', [10, 30, 100, 20], ...
                             'Value', true);  % Default selection

    flipButton = uiradiobutton(buttonGroup, ...
                               'Text', 'Flip', ...
                               'Position', [10, 10, 100, 20]);

    % Create the "Run" button to apply the choice
    uibutton(fig, 'Text', 'Run', ...
                         'Position', [350, 40, 100, 30], ...
                         'ButtonPushedFcn', @(~, ~) executeFlipChoice());

    uiwait(fig);

    % Nested function to execute the flip choice
    function executeFlipChoice()
        if flipButton.Value
            % Rotate the original geometry with the flipped axis
            pointsFinal = rotateGeometry([x y z]);
            messageLabel.Text = 'Geometry flipped.';
            flipFlag = 1;
        else
            % If "Do not flip" is selected, keep pointsRotated as is
            pointsFinal = [x y z];
            messageLabel.Text = 'Geometry NOT flipped.'; 
            flipFlag = 0;
        end

        plotGeometry(ax, pointsFinal);
        x = pointsFinal(:,1); y = pointsFinal(:,2); z = pointsFinal(:,3);

        pause(2);
        close(fig);
    end

end

% Function to rotate the geometry based on the specified axis
function pointsRotated = rotateGeometry(points)
    theta = -pi;
    Ry = [cos(theta) 0 sin(theta);0 1 0;-sin(theta) 0 cos(theta)];
    pointsRotated = (Ry*points')';
end

% Function to plot the geometry with the current axis
function plotGeometry(ax, points)
    % Plot the point cloud
    plot3(ax, points(:,1), points(:,2), points(:,3), '.k');
    set(ax,'FontSize',24,'TickLabelInterpreter','latex')
    
    % Set plot properties
    xlabel(ax, 'x [m]','Interpreter','latex');
    ylabel(ax, 'y [m]','Interpreter','latex');
    zlabel(ax, 'z [m]','Interpreter','latex');
    title(ax, '\textbf{Check blades sweep to choose whether to flip or not}','Interpreter','latex')
    axis(ax, 'equal'); 
    axis(ax, [min(points(:,1)) max(points(:,1)) min(points(:,2)) max(points(:,2)) min(points(:,3)) max(points(:,3))])
    axis(ax, 'equal'); 

    grid(ax, 'on'); view(ax, -90, 0)
end
