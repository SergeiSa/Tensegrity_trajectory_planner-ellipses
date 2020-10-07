clear; clc; close all;

T1 = [1 0 0.5
      0 1 0.5;
      0 0 3];

V1 = T1*get_cube([0;0;1], 3);
V1 = scaler(V1,[0;0;0]);

T2 = [1 0.5 0
      0 4 0;
      0.5 0 1];

V2 = T2*get_cube([0;0;0], 3);
V2 = rotx(-30)*scaler(V2, [0;1;0]);
V2 = V2 + [0;-7; 15];

T3 = [1 0 0.5
      0 1 0.5;
      0.5 0 3];

V3 = T3*get_cube([0;0;0], 3);
V3 = roty(70)*scaler(V3, [1;0;0]);
V3 = V3 + [3; -17; 20];

save('data_maze', 'V1', 'V2', 'V3')

figure('Color', 'w')
vis_Body(V1, 'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', [1 0.8 0.2]); hold on;
vis_Body(V2, 'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', [0.8 1 0.2]); 
vis_Body(V3, 'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', [0.4 1 0.6]); 

xlabel_handle = xlabel('$$x$$, m', 'Interpreter', 'latex');
ylabel_handle = ylabel('$$y$$, m', 'Interpreter', 'latex');
zlabel_handle = zlabel('$$z$$, m', 'Interpreter', 'latex');
axis equal;


function scaled_V = scaler(V, center)

scaled_V = V;
for i = 1:size(V, 2)
    scaled_V(:, i) = scaled_V(:, i) * (norm(scaled_V(:, i) - center)) * 0.1;
end
end