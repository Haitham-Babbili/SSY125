%decide the previous state and returns previous state and decoded 
%information bit corresponding to that state according to the current state
%and the survivor in this state
%state: 1--00;2--10;3--01;4--11.
function [prev_state, c] = prev_stage(curr_state, survivor)
switch curr_state
    case 1
        c = 0;
        if(survivor(1) == true)
            prev_state = 1;
        else
            prev_state = 3;
        end
    case 2
        c = 1;
        if(survivor(2) == true)
            prev_state = 1;
        else
            prev_state = 3;
        end
    case 3
        c = 0;
        if(survivor(3) == true)
            prev_state = 2;
        else
            prev_state = 4;
        end
    otherwise
        c = 1;
        if(survivor(4) == true)
            prev_state = 2;
        else
            prev_state = 4;
        end
end
end