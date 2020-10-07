clear; close all;

[PX,PY,PZ] = sphere(20);
sh = size(PX);
PX = PX(:); PY = PY(:); PZ = PZ(:);
PP = [PX, PY, PZ]';

for i = 1:10
T = rand(3, 3) + eye(3);
T = T + T';

T2 = rand(3, 3) + eye(3);
T2 = rand * (T2 + T2');

PPt = T * PP;
PPt2 = T2 * PP;

[V,D] = eig(T2);
M = V*D;

v1 = pinv(T)*M(:, 1);
v2 = pinv(T)*M(:, 2);
v3 = pinv(T)*M(:, 3);

if (norm(v1) < 1) && ...
   (norm(v2) < 1) && ...
   (norm(v3) < 1)
    Color = 'g';
else
    Color = 'r';
end

figure;
surf(reshape(PPt(1, :), sh), reshape(PPt(2, :), sh), reshape(PPt(3, :), sh), ...
    'FaceAlpha', 0.3, 'EdgeAlpha', 0.05, 'FaceColor', 'b'); hold on;

surf(reshape(PPt2(1, :), sh), reshape(PPt2(2, :), sh), reshape(PPt2(3, :), sh), ...
    'FaceAlpha', 0.3, 'EdgeAlpha', 0.05, 'FaceColor', Color); hold on;

axis equal;

end