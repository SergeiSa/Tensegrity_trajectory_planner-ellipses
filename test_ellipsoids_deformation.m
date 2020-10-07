close all;
A = diag(rand(3, 1));
b = zeros(3, 1);

figure
vis_draw_ellipsoid(A, b, 'EdgeAlpha', 0.1);
    axis equal;

figure('Color', 'w');
for i = 1:4
    subplot(2, 2, i);
    vis_draw_ellipsoid(randn(3, 3)*A, b, 'EdgeAlpha', 0.1)
    axis equal;
end