function [prev_state, bits_decoded] = prev_stage_soft(curr_state, survivor)
switch curr_state
    case 1
        if(survivor(1) == 1)
            prev_state = 1;bits_decoded = [0 0];
        elseif(survivor(1) == 2)
            prev_state = 3;bits_decoded = [1 0];
        elseif(survivor(1) == 3)
            prev_state = 5;bits_decoded = [0 1];
        else
            prev_state = 7;bits_decoded = [1 1];
        end
    case 2
        if(survivor(2) == 1)
            prev_state = 1;bits_decoded = [1 0];
        elseif(survivor(2) == 2)
            prev_state = 3;bits_decoded = [0 0];
        elseif(survivor(2) == 3)
            prev_state = 5;bits_decoded = [1 1];
        else
            prev_state = 7;bits_decoded = [0 1];
        end
    case 3
        if(survivor(3) == 1)
            prev_state = 1;bits_decoded = [0 1];
        elseif(survivor(3) == 2)
            prev_state = 3;bits_decoded = [1 1];
        elseif(survivor(3) == 3)
            prev_state = 5;bits_decoded = [0 0];
        else
            prev_state = 7;bits_decoded = [1 0];
        end
    case 4
        if(survivor(4) == 1)
            prev_state = 1;bits_decoded = [1 1];
        elseif(survivor(4) == 2)
            prev_state = 3;bits_decoded = [0 1];
        elseif(survivor(4) == 3)
            prev_state = 5;bits_decoded = [1 0];
        else
            prev_state = 7;bits_decoded = [0 0];
        end
    case 5
        if(survivor(5) == 1)
            prev_state = 2;bits_decoded = [0 0];
        elseif(survivor(5) == 2)
            prev_state = 4;bits_decoded = [1 0];
        elseif(survivor(5) == 3)
            prev_state = 6;bits_decoded = [0 1];
        else
            prev_state = 8;bits_decoded = [1 1];
        end
    case 6
        if(survivor(6) == 1)
            prev_state = 2;bits_decoded = [1 0];
        elseif(survivor(6) == 2)
            prev_state = 4;bits_decoded = [0 0];
        elseif(survivor(6) == 3)
            prev_state = 6;bits_decoded = [1 1];
        else
            prev_state = 8;bits_decoded = [0 1];
        end
    case 7
        if(survivor(7) == 1)
            prev_state = 2;bits_decoded = [0 1];
        elseif(survivor(7) == 2)
            prev_state = 4;bits_decoded = [1 1];
        elseif(survivor(7) == 3)
            prev_state = 6;bits_decoded = [0 0];
        else
            prev_state = 8;bits_decoded = [1 0];
        end
    otherwise
        if(survivor(8) == 1)
            prev_state = 2;bits_decoded = [1 1];
        elseif(survivor(8) == 2)
            prev_state = 4;bits_decoded = [0 1];
        elseif(survivor(8) == 3)
            prev_state = 6;bits_decoded = [1 0];
        else
            prev_state = 8;bits_decoded = [0 0];
        end
end
end
