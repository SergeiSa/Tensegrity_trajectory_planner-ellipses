function h = vis_node_numbers(~, r, varargin)
Parser = inputParser;
Parser.FunctionName = 'vis_node_numbers';
Parser.addOptional('text_delta_x', 0.1);
Parser.addOptional('text_delta_z', 0.1);
Parser.addOptional('FontName', 'Times New Roman');
Parser.addOptional('FontSize', 12);
Parser.addOptional('Color', 'k');
Parser.addOptional('FontWeight', 'bold');
Parser.parse(varargin{:});

text_delta_x = Parser.Results.text_delta_x;
text_delta_z = Parser.Results.text_delta_z;

for i = 1:size(r, 2)
    h(i) = text(r(1, i) + text_delta_x, r(2, i), r(3, i) + text_delta_z, ...
        num2str(i), ...
        'FontName',   Parser.Results.FontName, ...
        'FontSize',   Parser.Results.FontSize, ...
        'Color',      Parser.Results.Color, ...
        'FontWeight', Parser.Results.FontWeight);
end

end