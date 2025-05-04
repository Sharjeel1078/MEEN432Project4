function [gradePct, height] = get_grade_function(x, y)
    % initialize the outputs
    height   = zeros(size(x));
    gradePct = zeros(size(x));

    % determine the segment types
    isBottom   = (x >=   0) & (x <= 900) & (y >=  -7.5) & (y <=   7.5);
    isTop      = (x >=   0) & (x <= 900) & (y >= 392.5) & (y <= 407.5);
    isStraight = isBottom | isTop;

    % determine height according to the equation
    xs = x(isStraight);
    t  = (xs - 450) ./ 50;
    L  = exp(t) ./ (1 + exp(t));
    height(isStraight) = 10 * L;

    % first turn height should be at 10
    isFirstTurn = (x > 900);
    height(isFirstTurn) = 10;

    % calculate the grade percent for the straights because it is zero on
    % the turns
    dhdx = 10 * (1/50) * (L .* (1 - L));
    gradePct(isStraight) = dhdx * 100;
end
