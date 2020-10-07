clear; clc; close all;

T1 = [3 0 0
      0 2.5 0;
      0 0 4];
V1 = T1*get_cube([0;0;1], 1);

T2 = [8 0 0
      0 1.5 0;
      0 0 0.5];

V2 = T2*get_cube([0;0;0], 1);
V2 = V2 + [3;0; 5.5];

T3 = [2.5 0 0
      0 6 0;
      0 0 3];

V3 = T3*get_cube([0;0;0], 1);
V3 = V3 + [7; 3; 5];

save('data_maze2', 'V1', 'V2', 'V3')

figure('Color', 'w')
vis_Body(V1, 'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', 'r'); hold on;
vis_Body(V2, 'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', 'g'); 
vis_Body(V3, 'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', 'b'); 

xlabel_handle = xlabel('$$x$$, m', 'Interpreter', 'latex');
ylabel_handle = ylabel('$$y$$, m', 'Interpreter', 'latex');
zlabel_handle = zlabel('$$z$$, m', 'Interpreter', 'latex');
axis equal;
