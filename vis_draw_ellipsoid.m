function vis_draw_ellipsoid(A, b, varargin)
Parser = inputParser;
Parser.FunctionName = 'MyFnc';
Parser.addOptional('EdgeAlpha', 0);
Parser.addOptional('FaceAlpha', 0.8);
Parser.addOptional('FaceColor', [1 0.8 0.2]);
Parser.addOptional('SpecularStrength', 0.2);
Parser.parse(varargin{:});

[x,y,z] = sphere(20);
sh = size(x);
x = x(:);
y = y(:);
z = z(:);

PP = [x, y, z];
PP = (A*PP' + b)';

x = reshape(PP(:, 1), sh);
y = reshape(PP(:, 2), sh);
z = reshape(PP(:, 3), sh);

surf(x, y, z, ...
    'EdgeAlpha', Parser.Results.EdgeAlpha, ...
    'FaceAlpha', Parser.Results.FaceAlpha, ...
    'FaceColor', Parser.Results.FaceColor, ...
    'SpecularStrength', Parser.Results.SpecularStrength)
end