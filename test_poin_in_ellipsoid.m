clear; close all;

[PX,PY,PZ] = sphere(20);
sh = size(PX);
PX = PX(:); PY = PY(:); PZ = PZ(:);
PP = [PX, PY, PZ]';

S = randn(3, 1);

T = rand(3, 3) + eye(3);
T = T + T';

PPt = T * PP + S;

surf(reshape(PPt(1, :), sh), reshape(PPt(2, :), sh), reshape(PPt(3, :), sh), ...
    'FaceAlpha', 0.3, 'EdgeAlpha', 0.05, 'FaceColor', 'b'); hold on;

for i = 1:200
    point = (2*rand(3, 1) - ones(3, 1)) * 3;
    
    v = pinv(T)*(point - S);
    if norm(v) < 1
        Color = 'r';
    else
        Color = 'g';
    end
        
    plot3(point(1), point(2), point(3), 'o', 'MarkerFaceColor', Color);
end

axis equal;