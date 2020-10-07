clear; %close all;

[PX,PY,PZ] = sphere(500);
sh = size(PX);
PX = PX(:); PY = PY(:); PZ = PZ(:);
PP = [PX, PY, PZ]';

n = 100;

MakeElliptical = false;
if MakeElliptical
R = rotx(100*randn)*roty(100*randn)*rotz(100*randn);
D = R*diag(rand(3, 1))*R';
PP = D*PP;
end

T = rand(n, 3) / sqrt(n);

EE = zeros(size(PP));

for i = 1:size(PP, 2)
    EE(:, i) = norm(T*PP(:, i)) * PP(:, i) / norm(PP(:, i));
end

figure('Color', 'w');
surf(reshape(PP(1, :), sh), reshape(PP(2, :), sh), reshape(PP(3, :), sh), ...
    'FaceAlpha', 0.1, 'EdgeAlpha', 0.01, 'FaceColor', 'b'); hold on;

surf(reshape(EE(1, :), sh), reshape(EE(2, :), sh), reshape(EE(3, :), sh), ...
    'FaceAlpha', 0.4, 'EdgeAlpha', 0.15, 'FaceColor', 'g'); hold on;

axis equal;