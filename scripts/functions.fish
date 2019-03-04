function tba
	for req in $argv
		curl -G "https://www.thebluealliance.com/api/v3/$req?X-TBA-Auth-Key=pI9WtwdRjehXCJlgStDxRFqncrcY6by1m7s87X8KY9kmRuenndtM4PL4UdVw4kYh"
	end
end

function tbajoin
	sed 's/--_curl_--.*/ /'
end

function tbamatches
    set name $argv[1]
    set matches $argv[2..-1]
    tba event/$matches/matches | jq > data/matches_{$name}.json
    jq -rf recipes/teams.jq  < data/matches_{$name}.json > data/teams_{$name}_stacked.csv
    jq -rf recipes/breakdown.jq < data/matches_{$name}.json > data/matches_{$name}_stacked.csv
end