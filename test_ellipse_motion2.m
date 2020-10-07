close all; clear;
maze = load('data_maze2');

scale = 0.3;
maze.V1 = scale*maze.V1;
maze.V2 = scale*maze.V2;
maze.V3 = scale*maze.V3;


[A1,b1] = vert2con(maze.V1');
[A2,b2] = vert2con(maze.V2');
[A3,b3] = vert2con(maze.V3');

A12 = [A1; A2];
A23 = [A2; A3];
b12 = [b1; b2];
b23 = [b2; b3];

point_start  = scale*[0;   0;   0.25]*8;
point_finish = scale*[0.9; 0.8; 0.45]*8;

[PX,PY,PZ] = sphere(6);
PX = PX(:); PY = PY(:); PZ = PZ(:);
PP = [PX, PY, PZ]';

[vPX,vPY,vPZ] = sphere(10);
vis.sh = size(vPX);
vis.vPX = vPX(:); vis.vPY = vPY(:); vis.vPZ = vPZ(:);
vis.PP = [vis.vPX, vis.vPY, vis.vPZ]';

vis.maze = maze;
vis.point_start = point_start;
vis.point_finish = point_finish;

n = 7;
k = size(PP, 2);

cvx_begin
    variable shift(3,n)
    variable T1(3,3) symmetric
    variable T2(3,3) symmetric
    variable T3(3,3) symmetric
    variable T4(3,3) symmetric
    variable T5(3,3) symmetric
    variable T6(3,3) symmetric
    variable T7(3,3) symmetric
    
    shift_cost_weight = 1;
    start_cost_weight = 100;
    finish_cost_weight = 100;
    elipsoid_cost_weight = 10;
    
    shift_cost = 0;
    for i = 1:(n-1)
        shift_cost = shift_cost + norm(shift(:, i) - shift(:, i+1));
    end
    shift_cost = shift_cost + norm(shift(:, 1));
    
    elipsoid_cost = det_rootn( T1 ) + det_rootn( T2 ) + det_rootn( T3 ) ...
        + det_rootn( T4 ) + det_rootn( T5 ) + det_rootn( T6 ) + det_rootn( T7 );
    
    start_cost = norm( (sum(PP, 2) / k) + shift(:, 1) - point_start );
    finish_cost = norm( (sum(PP, 2) / k) + shift(:, n) - point_finish );
    
    maximize( -shift_cost_weight * shift_cost ...
              - start_cost_weight * start_cost ...
              - finish_cost_weight * finish_cost ...
              + elipsoid_cost_weight * elipsoid_cost)
    subject to
       %norm( B*domain_A(i,:)', 2 ) + domain_A(i,:)*d <= domain_b(i);
       for i = 1:size(A1, 1) 
           norm( T1*A1(i,:)', 2 ) + A1(i,:)*shift(:, 1) <= b1(i);
       end
       for i = 1:size(A1, 1)  
           norm( T2*A1(i,:)', 2 ) + A1(i,:)*shift(:, 2) <= b1(i);
       end
       for i = 1:size(A12, 1)  
           norm( T3*A12(i,:)', 2 ) + A12(i,:)*shift(:, 3) <= b12(i);
       end
       
       for i = 1:size(A2, 1) 
           norm( T4*A2(i,:)', 2 ) + A2(i,:)*shift(:, 4) <= b2(i);
       end
       for i = 1:size(A23, 1) 
           norm( T5*A23(i,:)', 2 ) + A23(i,:)*shift(:, 5) <= b23(i);
       end
       
       for i = 1:size(A3, 1) 
           norm( T6*A3(i,:)', 2 ) + A3(i,:)*shift(:, 6) <= b3(i);
       end
       for i = 1:size(A3, 1) 
           norm( T7*A3(i,:)', 2 ) + A3(i,:)*shift(:, 7) <= b3(i);
       end
       
cvx_end

T_cell = {T1, T2, T3, T4, T5, T6, T7};

for i = 1:n
    PP_cell{i} = T_cell{i} * vis.PP + shift(:, i);
end

vis.shift = shift;

draw(PP_cell, vis)

DatasetPath = 'C:\MLData\Tensegrity\data_ML_SixBar_floating_2_ellipses';
dataset = load(DatasetPath);

Count = size(dataset.ellipsoids_T,  1);
config_indeces = zeros(n, 1);

for j = 1:n
    generetaed_T = T_cell{j};
    pinv_generetaed_T = pinv(generetaed_T);
    
    candidates = Inf(Count, 1);
    
    for i = 1:Count
        dataset_T = reshape(dataset.ellipsoids_T(i, :), 3, 3);
        dataset_V = reshape(dataset.ellipsoids_V(i, :), 3, 3);
        dataset_D = reshape(dataset.ellipsoids_D(i, :), 3, 3);
        dataset_M = dataset_V * dataset_D;
        
        W = pinv_generetaed_T * dataset_M;
        
        if (norm(W(:, 1)) < 1) && (norm(W(:, 2)) < 1) && (norm(W(:, 3)) < 1)
            candidates(i) = dataset.diff_norm(i) + 0.001*1/det(dataset_T);
        end
    end
    
    [value, ind] = min(candidates);
    best_dataset_T = reshape(dataset.ellipsoids_T(ind, :), 3, 3);
    
    if isfinite(value)
        fixed_PP_cell{j} = best_dataset_T * vis.PP + shift(:, j);
        config_indeces(j) = ind;
    else
        fixed_PP_cell{j} = NaN(size(vis.PP));
        config_indeces(j) = NaN;
    end
    
    %vis_draw_ellipsoid(best_dataset_T, shift(:, j), 'FaceAlpha', 0.2, 'FaceColor', rand(1, 3)); hold on;
end

draw(fixed_PP_cell, vis)


%%%%%%%%%%%%%%%%%%%%

ConfigDatasetPath = 'C:\MLData\Tensegrity\data_ML_SixBar_floating_2';
RobotPath = 'data_robot_SixBar_floating';
config_dataset = load(ConfigDatasetPath);
robot_data = load(RobotPath);
robot = robot_data.robot;


figure('Color', 'w')
vis_Body(vis.maze.V1, 'FaceAlpha', 0.2, 'EdgeAlpha', 0.02, 'FaceColor', [1 0.8 0.2]); hold on;
vis_Body(vis.maze.V2, 'FaceAlpha', 0.2, 'EdgeAlpha', 0.02, 'FaceColor', [0.8 1 0.2]); 
vis_Body(vis.maze.V3, 'FaceAlpha', 0.2, 'EdgeAlpha', 0.02, 'FaceColor', [0.4 1 0.6]);

for j = 1:n
    if isfinite(config_indeces(j))
        nodes_position = config_dataset.nodes_position(config_indeces(j), :);
        nodes_position = reshape(nodes_position, 3, []);
        nodes_position = nodes_position + shift(:, j);
        
        vis_Draw(robot, nodes_position, 'FaceAlpha', 0.30, ...
            'NodeRadius', 0.03, 'RodsRadius', 0.01, 'CablesRadius', 0.002, ...
            'ToAddNodeNumbers', false);
    end
    
end

axis equal;



function draw(my_PP_cell, vis)

figure('Color', 'w')

draw_maze(vis);

n = length(my_PP_cell);

for i = 1:n
    PPt = my_PP_cell{i};
    surf(reshape(PPt(1, :), vis.sh), reshape(PPt(2, :), vis.sh), reshape(PPt(3, :), vis.sh), ...
        'FaceAlpha', 0.3, 'EdgeAlpha', 0.05, 'FaceColor', rand(1, 3))
    
    plot3(vis.shift(1, i), vis.shift(2, i), vis.shift(3, i), ...
        'o', 'MarkerFaceColor', ([0 1 0]*i/n + [1 0 0]*(n-i)/n) )
end


xlabel_handle = xlabel('$$x$$, m', 'Interpreter', 'latex');
ylabel_handle = ylabel('$$y$$, m', 'Interpreter', 'latex');
zlabel_handle = zlabel('$$z$$, m', 'Interpreter', 'latex');
axis equal;
end

function draw_maze(vis)
vis_Body(vis.maze.V1, 'FaceAlpha', 0.2, 'EdgeAlpha', 0.01, 'FaceColor', [1 0.8 0.2]); hold on;
vis_Body(vis.maze.V2, 'FaceAlpha', 0.2, 'EdgeAlpha', 0.01, 'FaceColor', [0.8 1 0.2]); 
vis_Body(vis.maze.V3, 'FaceAlpha', 0.2, 'EdgeAlpha', 0.01, 'FaceColor', [0.4 1 0.6]); 
end

