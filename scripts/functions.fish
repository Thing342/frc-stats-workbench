function tba
	for req in $argv
		curl -G "https://www.thebluealliance.com/api/v3/$req?X-TBA-Auth-Key=pI9WtwdRjehXCJlgStDxRFqncrcY6by1m7s87X8KY9kmRuenndtM4PL4UdVw4kYh"
	end
end

function tbajoin
	sed 's/--_curl_--.*/ /'
end
