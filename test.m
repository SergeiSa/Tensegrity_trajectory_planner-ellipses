close all;
maze = load('data_maze');

[A1,b1] = vert2con(maze.V1');
[A2,b2] = vert2con(maze.V2');
[A3,b3] = vert2con(maze.V3');

point_start = [0; 0; 0];
point_finish = [10; -15; 20];

scale = 6;

T0 = scale*rotx(0)*diag([2 2 1]);
[PX,PY,PZ] = sphere(6);
PX = PX(:); PY = PY(:); PZ = PZ(:);
PP = T0*[PX, PY, PZ]';

[vPX,vPY,vPZ] = sphere(10);
vis.sh = size(vPX);
vis.vPX = vPX(:); vis.vPY = vPY(:); vis.vPZ = vPZ(:);
vis.PP = T0*[vis.vPX, vis.vPY, vis.vPZ]';


n = 7;
k = size(PP, 2);

cvx_begin
    variable shift(3,n)
    variable T(3,3, n)
    
    shift_cost_weight = 1;
    start_cost_weight = 100;
    finish_cost_weight = 100;
    deformation_cost_weight = 10;
    relative_deformation_cost_weight = 10;
    
    shift_cost = 0;
    for i = 1:(n-1)
        shift_cost = shift_cost + norm(shift(:, i) - shift(:, i+1));
    end
    shift_cost = shift_cost + norm(shift(:, 1));
    
    deformation_cost = 0;
    for i = 1:n
        deformation_cost = deformation_cost + norm(T(:,:, i) - eye(3));
    end
    
    relative_deformation_cost = 0;
    for i = 1:(n-1)
        relative_deformation_cost = relative_deformation_cost + norm(T(:,:, i) - T(:,:, i+1));
    end
    
    start_cost = norm( (sum(PP, 2) / k) + shift(:, 1) - point_start );
    finish_cost = norm( (sum(PP, 2) / k) + shift(:, n) - point_finish );
    
    minimize( shift_cost_weight * shift_cost + ...
              start_cost_weight * start_cost + ...
              finish_cost_weight * finish_cost + ...
              deformation_cost_weight * deformation_cost + ...
              relative_deformation_cost_weight * relative_deformation_cost)
    subject to
       for i = 1:k 
           A1*(T(:,:, 1)*PP(:, i) + shift(:, 1)) <= b1;
       end
       for i = 1:k 
           A1*(T(:,:, 2)*PP(:, i) + shift(:, 2)) <= b1;
       end
       for i = 1:k 
           [A1;A2]*(T(:,:, 3)*PP(:, i) + shift(:, 3)) <= [b1; b2];
       end
       
       for i = 1:k 
           A2*(T(:,:, 4)*PP(:, i) + shift(:, 4)) <= b2;
       end
       for i = 1:k 
           [A2; A3]*(T(:,:, 5)*PP(:, i) + shift(:, 5)) <= [b2; b3];
       end
       
       for i = 1:k 
           A3*(T(:,:, 6)*PP(:, i) + shift(:, 6)) <= b3;
       end
       for i = 1:k 
           A3*(T(:,:, 7)*PP(:, i) + shift(:, 7)) <= b3;
       end
       
cvx_end

for i = 1:n
PP_cell{i} = T(:,:, i) * vis.PP + shift(:, i);
end


figure('Color', 'w')
vis_Body(maze.V1, 'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', [1 0.8 0.2]); hold on;
vis_Body(maze.V2, 'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', [0.8 1 0.2]); 
vis_Body(maze.V3, 'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', [0.4 1 0.6]); 

plot3(point_start(1), point_start(2), point_start(3), 'o', 'MarkerFaceColor', 'g')
plot3(point_finish(1), point_finish(2), point_finish(3), 'o', 'MarkerFaceColor', 'r')

% surf(reshape(vis.PP(1, :), vis.sh), reshape(vis.PP(2, :), vis.sh), reshape(vis.PP(3, :), vis.sh), ...
%     'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', [1 0 0])

for i = 1:n
    PPt = PP_cell{i};
    surf(reshape(PPt(1, :), vis.sh), reshape(PPt(2, :), vis.sh), reshape(PPt(3, :), vis.sh), ...
        'FaceAlpha', 0.4, 'EdgeAlpha', 0.05, 'FaceColor', [(1-i/n) (i/n) 0])
end


xlabel_handle = xlabel('$$x$$, m', 'Interpreter', 'latex');
ylabel_handle = ylabel('$$y$$, m', 'Interpreter', 'latex');
zlabel_handle = zlabel('$$z$$, m', 'Interpreter', 'latex');
axis equal;