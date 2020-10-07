%generates a body from a collection of vertices
function h = vis_Body(Vertices, varargin)
Parser = inputParser;
Parser.FunctionName = 'MyFnc';
Parser.addOptional('EdgeAlpha', 0);
Parser.addOptional('FaceAlpha', 0.8);
Parser.addOptional('FaceColor', [1 0.8 0.2]);
Parser.addOptional('SpecularStrength', 0.2);
Parser.addOptional('PaddingRadius', 0.01);
Parser.parse(varargin{:});

V = Vertices;

for i = 1:size(Vertices, 2)
    V = [V, get_cube(V(:, i), Parser.Results.PaddingRadius)];
end
V = V';

[K, ~] = convhull(V(:, 1), V(:, 2), V(:, 3));
h = trisurf(K, V(:, 1), V(:, 2), V(:, 3), ...
    'EdgeAlpha', Parser.Results.EdgeAlpha, ...
    'FaceAlpha', Parser.Results.FaceAlpha, ...
    'FaceColor', Parser.Results.FaceColor, ...
    'SpecularStrength', Parser.Results.SpecularStrength);

end


