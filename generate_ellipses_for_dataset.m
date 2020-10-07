
DatasetPath = 'C:\MLData\Tensegrity\data_ML_SixBar_floating_2';
RobotPath = 'data_robot_SixBar_floating';

dataset = load(DatasetPath);
robot_data = load(RobotPath);
robot = robot_data.robot;

Count = size(dataset.nodes_position, 1);
% Count = 5000;

ellipsoids_T = zeros(Count, 9);
ellipsoids_V = zeros(Count, 9);
ellipsoids_D = zeros(Count, 9);
diff_norm = dataset.diff_norm(1:Count);
m = robot.number_of_nodes;

for index = 1:Count
    
    disp(['calculating ', num2str(index), ' out of ', num2str(Count)]);
    
    P = dataset.nodes_position(index, :);
    P = reshape(P, 3, []);
    
    cvx_begin
       variable T(3, 3) symmetric
       variable d(3, 1)
       maximize( det_rootn( T ) )
       subject to
       for i = 1:m
           norm( (T*P(:,i) + d), 2 ) <= 1;
       end
    cvx_end
    
    M = pinv(T);
    
    [eig_V,eig_D] = eig(M);
    
    ellipsoids_T(index, :) = M(:);
    ellipsoids_V(index, :) = eig_V(:);
    ellipsoids_D(index, :) = eig_D(:);
end

save([DatasetPath, '_ellipses'], 'ellipsoids_T', 'ellipsoids_V', 'ellipsoids_D', 'diff_norm');

