module DeepSpace
using DataFrames, DataFramesMeta
export bay_points, calculated_columns!

bay_points(bay::String) = 
        if bay == "None" 0
        elseif bay == "Panel" 2
        elseif bay == "PanelAndCargo" 5
        else 0
        end
            
null_hatch_penalty(preMatchBay::String) =
        if preMatchBay == "Panel" 2
        else 0
        end
            
function calculated_columns!(scores::DataFrame)
    scores[:rocketLowPoints] = bay_points.(scores.lowLeftRocketFar) .+ bay_points.(scores.lowLeftRocketNear) .+ bay_points.(scores.lowRightRocketFar) .+ bay_points.(scores.lowRightRocketNear)
    scores[:rocketMidPoints] = bay_points.(scores.midLeftRocketFar) .+ bay_points.(scores.midLeftRocketNear) .+ bay_points.(scores.midRightRocketFar) .+ bay_points.(scores.midRightRocketNear)
    scores[:rocketTopPoints] = bay_points.(scores.topLeftRocketFar) .+ bay_points.(scores.topLeftRocketNear) .+ bay_points.(scores.topRightRocketFar) .+ bay_points.(scores.topRightRocketNear)
    scores[:rocketPoints] = scores.rocketLowPoints .+ scores.rocketMidPoints .+ scores.rocketTopPoints
                    
    scores[:shipFarPoints] = bay_points.(scores.bay1) .- null_hatch_penalty.(scores.preMatchBay1) .+ 
                             bay_points.(scores.bay2) .- null_hatch_penalty.(scores.preMatchBay2) .+
                             bay_points.(scores.bay3) .- null_hatch_penalty.(scores.preMatchBay3)
    scores[:shipNearPoints] = bay_points.(scores.bay6) .- null_hatch_penalty.(scores.preMatchBay6) .+ 
                              bay_points.(scores.bay7) .- null_hatch_penalty.(scores.preMatchBay7) .+
                              bay_points.(scores.bay8) .- null_hatch_penalty.(scores.preMatchBay8)
    scores[:shipCenterPoints] = bay_points.(scores.bay4) .+ DeepSpace.bay_points.(scores.bay5)
    scores[:shipPoints] = scores.shipFarPoints .+ scores.shipCenterPoints .+ scores.shipNearPoints
    
    scores[:ownPoints] = scores.totalPoints .- scores.foulPoints .- (3 .* scores.foulCount) .- (9 * scores.techFoulCount)
end
            
end