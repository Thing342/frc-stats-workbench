module DeepSpace
using DataFrames, DataFramesMeta
export bay_points, calculated_columns!

bay_points(bay::String) = 
        if bay == "None" 0
        elseif bay == "Panel" 2
        elseif bay == "PanelAndCargo" 5
        else 0
        end
            
function calculated_columns!(scores::DataFrame)
    scores[:rocketLowPoints] = bay_points.(scores.lowLeftRocketFar) + bay_points.(scores.lowLeftRocketNear) + bay_points.(scores.lowRightRocketFar) + bay_points.(scores.lowRightRocketNear)
    scores[:rocketMidPoints] = bay_points.(scores.midLeftRocketFar) + bay_points.(scores.midLeftRocketNear) + bay_points.(scores.midRightRocketFar) + bay_points.(scores.midRightRocketNear)
    scores[:rocketTopPoints] = bay_points.(scores.topLeftRocketFar) + bay_points.(scores.topLeftRocketNear) + bay_points.(scores.topRightRocketFar) + bay_points.(scores.topRightRocketNear)
    scores[:rocketPoints] = scores.rocketLowPoints + scores.rocketMidPoints + scores.rocketTopPoints
end
            
end