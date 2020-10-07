
DatasetPath = 'C:\MLData\Tensegrity\data_ML_SixBar_floating_2_ellipses';
dataset = load(DatasetPath);

Count = size(dataset.ellipsoids_T,  1);

T0 = reshape(dataset.ellipsoids_T(1, :), 3, 3);

for i = 1:floor(Count / 4)
    index = (i - 1) * 4;
    T1 = reshape(dataset.ellipsoids_T(index+1, :), 3, 3); 
    T2 = reshape(dataset.ellipsoids_T(index+2, :), 3, 3); 
    T3 = reshape(dataset.ellipsoids_T(index+3, :), 3, 3); 
    T4 = reshape(dataset.ellipsoids_T(index+4, :), 3, 3); 
    
    figure();
    subplot(2, 2, 1);
    vis_draw_ellipsoid(T0, zeros(3, 1), 'FaceAlpha', 0.1, 'FaceColor', 'r', 'EdgeAlpha', 0.2); hold on;
    vis_draw_ellipsoid(T1, zeros(3, 1), 'FaceAlpha', 0.3, 'FaceColor', 'b', 'EdgeAlpha', 0.2); hold on;
    axis equal
    subplot(2, 2, 2);
    vis_draw_ellipsoid(T0, zeros(3, 1), 'FaceAlpha', 0.1, 'FaceColor', 'r', 'EdgeAlpha', 0.2); hold on;
    vis_draw_ellipsoid(T2, zeros(3, 1), 'FaceAlpha', 0.3, 'FaceColor', 'b', 'EdgeAlpha', 0.2); hold on;
    axis equal
    subplot(2, 2, 3);
    vis_draw_ellipsoid(T0, zeros(3, 1), 'FaceAlpha', 0.1, 'FaceColor', 'r', 'EdgeAlpha', 0.2); hold on;
    vis_draw_ellipsoid(T3, zeros(3, 1), 'FaceAlpha', 0.3, 'FaceColor', 'b', 'EdgeAlpha', 0.2); hold on;
    axis equal
    subplot(2, 2, 4);
    vis_draw_ellipsoid(T0, zeros(3, 1), 'FaceAlpha', 0.1, 'FaceColor', 'r', 'EdgeAlpha', 0.2); hold on;
    vis_draw_ellipsoid(T4, zeros(3, 1), 'FaceAlpha', 0.3, 'FaceColor', 'b', 'EdgeAlpha', 0.2); hold on;
    axis equal
end