module Lib
using DataFrames, DataFramesMeta
using CSV

export opr_ß, numeric_col_names

function opr_ß(scores::DataFrame, teams::DataFrame ; teamnums=nothing, shortevent=false)
    if teamnums == nothing
        if shortevent
            teamnums = (vcat(teams.team1, teams.team2, teams.team3)) |> unique |> sort
        else
            teamnums = teams.team1 |> unique |> sort
        end
    end
    
    teamindex = Dict(t => i for (i, t) in enumerate(teamnums))

    ß = zeros(size(scores,1), size(teamnums,1))
    for p in [:team1, :team2, :team3]
        for i=1:size(teams,1)
            team = teams[i,p]
            j = teamindex[team]
            ß[i,j] = 1.0
        end
    end
    return (ß, teamnums, teamindex)
end
    
function read_stacked(event_key::String, event_year::String)
    headers = CSV.read("../data/$(event_year)_headers.csv") |> (h -> String.(names(h)))
    push!(headers, "key")
    push!(headers, "level")
    push!(headers, "event")

    scores = CSV.read("../data/matches_$(event_key)_stacked.csv", header=headers)
    teams = CSV.read("../data/teams_$(event_key)_stacked.csv", header=["team1","team2","team3","key","level","event"])
    return (headers, scores, teams)
end
    
function read_wide(event_key::String, event_year::String)
    headers = CSV.read("../data/$(event_year)_headers.csv") |> (h -> String.(names(h)))
    red_headers = [h * "_red" for h in headers]
    blue_headers = [h * "_blue" for h in headers]
    headers_wide = [red_headers; blue_headers; "key"; "level"; "event"]

    scores_wide = CSV.read("../data/matches_$(KEY)_wide.csv", header=headers_wide)
    return (headers, scores)
end
    
numeric_col_names(df::DataFrame) = [n for (n, c) in eachcol(df, true) if eltype(c) <: Union{Number, Missing}]
    
counting_fold(itr) = foldr(
    (n, (list, last)) -> ( push!(list, if (n == last) list[end] + 1 else 0 end), n), 
    itr |> reverse; 
    init = ([],"")
)

end