function getNearbyElements(root, type, distance)
	local x, y, z = getElementPosition(root)
	local elements = {}
	
	if getElementType(root) == "player" and exports['freecam-tv']:isPlayerFreecamEnabled(root) then return elements end
	
	for index, nearbyElement in ipairs(getElementsByType(type)) do
		if isElement(nearbyElement) and getDistanceBetweenPoints3D(x, y, z, getElementPosition(nearbyElement)) < ( distance or 20 ) then
			if getElementDimension(root) == getElementDimension(nearbyElement) then
				table.insert( elements, nearbyElement )
			end
		end
	end
	return elements
end

local gpn = getPlayerName
function getPlayerName(p)
	local name = getElementData(p, "fakename") or gpn(p) or getElementData(p, "name")
	return string.gsub(name, "_", " ")
end

function sendWrnToStaff(msg, prefix1, r1, g1, b1, toScripters)
	if msg then
		local r, g, b = (r1 or 255), (g1 or 0) , (b1 or 0)
		local prefix = prefix1 and ("["..prefix1.."] ") or ""
		local players = getElementsByType("player")
		for i, player in pairs(players) do
			if exports.global:isStaff(player) or (toScripters and exports.integration:isPlayerScripter(player)) then
				if getElementData(player, "loggedin") == 1 then
					if getElementData(player, "report_panel_mod") == "2" or getElementData(player, "report_panel_mod") == "3" then
						exports["report-system"]:showToAdminPanel(prefix..msg, player, r, g, b)
					else
						if getElementData(player, "wrn:style") == 1 then
							triggerClientEvent(player, "sendWrnMessage", player, prefix..msg)
						else
							outputChatBox(prefix..msg, player, r, g, b)
						end
					end
				end
			end
		end
	end
end

function sendWrnToStaffOnDuty(msg, prefix1, r1, g1, b1)
	if msg then
		local r, g, b = (r1 or 255), (g1 or 0) , (b1 or 0)
		local prefix = prefix1 and ("["..prefix1.."] ") or ""
		local players = getElementsByType("player")
		for i, player in pairs(players) do
			if exports.global:isStaffOnDuty(player) then
				if getElementData(player, "loggedin") == 1 then
					if getElementData(player, "report_panel_mod") == "2" or getElementData(player, "report_panel_mod") == "3" then
						exports["report-system"]:showToAdminPanel(prefix..msg, player, r, g, b)
					else
						if getElementData(player, "wrn:style") == 1 then
							triggerClientEvent(player, "sendWrnMessage", player, prefix..msg)
						else
							outputChatBox(prefix..msg, player, r, g, b)
						end
					end
				end
			end
		end
	end
end

function getPlayerFullIdentity(thePlayer, type, doNotUseFakeName)
	if not thePlayer or not isElement(thePlayer) or not getElementType(thePlayer) == "player" then
		return "Unknown person"
	end
	if not type then --For common chat channels | (id) Rank Username Characrtername
		local hidden = getElementData(thePlayer, "hiddenadmin")
		if hidden == 1 and exports.integration:isPlayerSeniorAdmin(thePlayer) then
			return "A hidden admin"
		else
			local playerid = getElementData(thePlayer, "playerid")
			local rank = "Player"
			local username = getElementData(thePlayer, "account:username")
			local characterName = doNotUseFakeName and string.gsub(gpn(thePlayer), "_", " ") or getPlayerName(thePlayer)
			rank = exports.integration:getFullTitle(getElementData(thePlayer, "admin_level"), getElementData(thePlayer, "supporter_level"), getElementData(thePlayer, "vct_level"), getElementData(thePlayer, "scripter_level"))
			
			local hasHiddenUsername, hiddenUsernameState = exports.donators:hasPlayerPerk(thePlayer, 9)
			if hasHiddenUsername and hiddenUsernameState == 1 then
				return "("..playerid..") "..rank.." "..characterName
			else
				return "("..playerid..") "..rank.." "..username
			end
		end
	elseif type == 1 then --Rank Username (Use for achievement system)
		local rank = false
		local username = getElementData(thePlayer, "account:username")
		if exports.integration:isPlayerTrialAdmin(thePlayer) then
			rank = getAdminTitles()[getPlayerAdminLevel(thePlayer)]
		elseif exports.integration:isPlayerSupporter(thePlayer) then
			rank = "Supporter"
		end
		
		if rank then
			return rank.." "..username
		else
			return username
		end
	elseif type == 2 then --Rank Username
		local rank = "Player"
		local username = getElementData(thePlayer, "account:username")
		local characterName = doNotUseFakeName and string.gsub(gpn(thePlayer), "_", " ") or getPlayerName(thePlayer)
		rank = exports.integration:getFullTitle(getElementData(thePlayer, "admin_level"), getElementData(thePlayer, "supporter_level"), getElementData(thePlayer, "vct_level"), getElementData(thePlayer, "scripter_level"))
			
		
		return rank.." "..username
	elseif type == 3 then --(id) Rank Username (Charactername) | (Use for admin system)
		local playerid = getElementData(thePlayer, "playerid")
		local rank = ""
		local username = getElementData(thePlayer, "account:username")
		local characterName = doNotUseFakeName and string.gsub(gpn(thePlayer), "_", " ") or getPlayerName(thePlayer)
		rank = exports.integration:getFullTitle(getElementData(thePlayer, "admin_level"), getElementData(thePlayer, "supporter_level"), getElementData(thePlayer, "vct_level"), getElementData(thePlayer, "scripter_level"))
			
		
		return "("..playerid..") "..rank.." "..username.." ("..characterName..")"
	end
end


local firstName = { "Michael","Christopher","Matthew","Joshua","Jacob","Andrew","Daniel","Nicholas","Tyler","Joseph","David","Brandon","James","John","Ryan","Zachary","Justin","Anthony","William","Robert", "Dean", "George", "Norman", "Lloyd", "Dennis", "Seymour", "Willie", "Richard", "Bobby", "Jody", "Danny ", "Seth", "Tommy", "Timothy", "Ashley", "Junior"}
local lastName = { "Johnson","Williams","Jones","Brown","Davis","Miller","Wilson","Moore","Taylor","Anderson","Thomas","Jackson","White","Harris","Martin","Thompson","Garcia","Martinez","Robinson","Clark", "Hummer", "Smith", "Touchet", "Trotter", "Nagle", "Dunbar", "Davis", "Grenier", "Duff", "Alston", "Winslow", "Borunda", "Duncan", "Heath", "Keeler", "Skinner", "Daniel", "Layfield", "Decker", "Ames", "Christie" }

function createRandomMaleName()
	local random1 = math.random(1, #firstName)
	local random2 = math.random(1, #lastName)
	local name = firstName[random1].." "..randomLetter()..". "..lastName[random2]
	return name
end

function randomLetter()
	return string.upper(string.char(math.random(97, 122)));
end