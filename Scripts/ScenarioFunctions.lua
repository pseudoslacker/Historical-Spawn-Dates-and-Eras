-- ===========================================================================
-- Scenario functions (optional scripted events)
-- ===========================================================================
--
-- ===========================================================================
-- Raging Barbarians & Unique Barbarians mode (incomplete)
-- ===========================================================================
--	Barbarian Tribe Types:
--	0 - Naval Tribe (default)
--	1 - Melee Tribe (default)
--  2 - Cavalry Tribe (default)
--  3 - Kongo Tribe 

g_CurrentBarbarianCamp = {}


function SpawnUniqueBarbians(campPlot)
	local bBarbarian = false
	local isBarbarian = false
	local isFreeCities = false
	local iShortestDistance = 10000
	local closestPlayerName = false
	for iPlayer = 0, PlayerManager.GetWasEverAliveCount() - 1 do
		local pPlayer = Players[iPlayer]
		local sCivTypeName = PlayerConfigurations[iPlayer]:GetCivilizationTypeName()
		if pPlayer and pPlayer:IsBarbarian() then isBarbarian = true end
		if iPlayer == 62 then isFreeCities = true end
		if pPlayer and not isBarbarian and not isFreeCities then
			local startingPlot = pPlayer:GetStartingPlot()
			local iDistance = Map.GetPlotDistance(startingPlot:GetX(), startingPlot:GetY(), campPlot:GetX(), campPlot:GetY())
			if iDistance and (iDistance < iShortestDistance) then
				closestPlayerName = sCivTypeName;
				iShortestDistance = iDistance;
			end
		end		
	end
	if closestPlayerName then
		bBarbarian = SpawnUniqueBarbarianTribe(closestPlayerName)
		-- if closestPlayerName == "CIVILIZATION_KONGO" then
			-- local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, iPlotIndex);
			-- pBarbManager:CreateTribeUnits(iNovgorodTribeNumber, "CLASS_MELEE", 2, iPlotIndex, iRange);
			-- pBarbManager:CreateTribeUnits(iNovgorodTribeNumber, "CLASS_RANGED", 1, iPlotIndex, iRange);
		-- end
	end
	return bBarbarian
end

function SpawnUniqueBarbarianTribe(campPlot, sCivTypeName)
	local bBarbarian = false
	local pBarbManager = Game.GetBarbarianManager() 
	local iPlotIndex = campPlot:GetIndex()
	local iRange = 3;
	if sCivTypeName == "CIVILIZATION_KONGO" then
		local eBarbarianTribeType = 3 --Kongo
		local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, iPlotIndex)
		pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_MELEE", 2, iPlotIndex, iRange);
		pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_RANGED", 1, iPlotIndex, iRange);
	end
	return bBarbarian
end

function SpawnBarbarians(iX, iY, eImprovement, playerID, resource, isPillaged, isWorked)
	local isBarbarian = false
	local isBarbCamp = false
	local pPlayer = Players[playerID]
	local campPlot = Map.GetPlot(iX, iY)
	print("Returning parameters")
	print("iX is "..tostring(iX)..", iY is "..tostring(iY)..", eImprovement is "..tostring(eImprovement)..", playerID is "..tostring(playerID)..", resource is "..tostring(resource)..", isPillaged is "..tostring(isPillaged)..", isWorked is "..tostring(isWorked))
	local prevCamp = Game:GetProperty("BarbarianCamp_"..campPlot:GetIndex())
	if not prevCamp and Players[playerID] == Players[63] then 
		isBarbarian = true 
		print("isBarbarian is "..tostring(isBarbarian))
	else
		print("isBarbarian is "..tostring(isBarbarian)..", prevCamp is "..tostring(prevCamp))
		return isBarbarian
	end
	if GameInfo.Improvements[eImprovement] then
		print("GameInfo ImprovementType is "..tostring(GameInfo.Improvements["IMPROVEMENT_BARBARIAN_CAMP"].ImprovementType))
		print("GameInfo eImprovement is "..tostring(GameInfo.Improvements[eImprovement].ImprovementType))
		if GameInfo.Improvements[eImprovement].ImprovementType == GameInfo.Improvements["IMPROVEMENT_BARBARIAN_CAMP"].ImprovementType then
			print("Barbarian camp detected from GameInfo")
			local plotUnits = Units.GetUnitsInPlot(campPlot)
			local barbUnits = pPlayer:GetUnits()
			local adjPlots = Map.GetAdjacentPlots(iX, iY)
			local adjPlotUnits = {}
			local toKill = {}
			-- table.insert(g_CurrentBarbarianCamp, campPlot)
			print("#barbUnits is "..tostring(#barbUnits))
			ImprovementBuilder.SetImprovementType(campPlot, -1)
			print("Original barbarian camp destroyed")
			if plotUnits ~= nil then
				for i, pUnit in ipairs(plotUnits) do
					table.insert(toKill, pUnit)
				end
				for i, pUnit in ipairs(toKill) do
					UnitManager.Kill(pUnit)
					print("Killing original barbarian unit")
				end	
				toKill = {}
			end	
			for i, pUnit in ipairs(barbUnits) do
				if pUnit then
					print("Barbarian unit detected at "..tostring(pUnit:GetX())..", "..tostring(pUnit:GetY()))
					local pUnitPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
					local distance = Map.GetPlotDistance(campPlot:GetIndex(), pUnitPlot:GetIndex());
					print("Plot distance is "..tostring(distance))
					if distance <= 3 then
						print("Barbarian scout detected")
						table.insert(toKill, pUnit)				
					end				
				end
			end
			if #toKill > 0 then
				for i, pUnit in ipairs(toKill) do
					if pUnit then
						UnitManager.Kill(pUnit)
						print("Killing original barbarian scout")
					end
				end					
			end
			Game:SetProperty("BarbarianCamp_"..campPlot:GetIndex(), 1)
			print("Original barbarians removed from map")
			local newBarbCamp = SpawnUniqueBarbians(campPlot)
		end
	end
	return isBarbarian
end

function RemoveBarbScouts( playerID:number, unitID:number )
	local player 			= Players[playerID]
	if not player:IsBarbarian() then
		return
	end
	local unit 				= UnitManager.GetUnit(playerID, unitID)
	local turnsFromStart 	= Game.GetCurrentGameTurn() - GameConfiguration.GetStartTurn()
	local tempTable = {}
	if unit and player and unit:GetType() == GameInfo.Units["UNIT_SCOUT"].Index and player:IsBarbarian() then
		local range = 3
		for dx = -range, range do
			for dy = -range, range do
				print("Searching for barbarian camps nearby")
				local otherPlot = Map.GetPlotXY(unit:GetX(), unit:GetY(), dx, dy, range)
				if otherPlot then
					local prevCamp = Game:GetProperty("BarbarianScout_"..otherPlot:GetIndex())
					local isBarbCamp  = otherPlot:GetImprovementOwner() == player:GetID()
					print("isBarbCamp is "..tostring(isBarbCamp)..", otherPlot:GetImprovementOwner() is "..tostring(otherPlot:GetImprovementOwner()))
					if not prevCamp and isBarbCamp then
						print("Unit type is "..tostring(unit:GetType()))
						print("Barbarian scout detected")
						UnitManager.Kill(unit)
						Game:SetProperty("BarbarianScout_"..otherPlot:GetIndex(), 1)
					end
				end
			end
		end
	end	
	if #tempTable > 0 then
		for i, curPlot in ipairs(tempTable) do
			if g_CurrentBarbarianCamp[curPlot] then
				print("Removing barbarian camp from list")
				table.remove(g_CurrentBarbarianCamp, curPlot)
				print("#g_CurrentBarbarianCamp is "..tostring(#g_CurrentBarbarianCamp))
			end
		end
	end
end

-- ===========================================================================
-- Colonization Mode
-- ===========================================================================

function InitiateColonization_GetCoastalPlots(coastalPlots)
	local colonyPlots = {}
	for i, iPlotIndex in ipairs(coastalPlots) do
		-- print("Checking coastal plot...")
		local pPlot = Map.GetPlotByIndex(iPlotIndex)
		local coastalLand = false
		local impassable = true
		local isOwned = true
		local isUnit  = true	
		if pPlot:IsCoastalLand() ~= nil then coastalLand = pPlot:IsCoastalLand() end
		if pPlot:IsOwned() ~= nil then isOwned = pPlot:IsOwned() end
		if pPlot:IsUnit() ~= nil then isUnit = pPlot:IsUnit() end
		if pPlot:IsImpassable() ~= nil then impassable = pPlot:IsImpassable() end
		if coastalLand and not isOwned and not impassable then 
			table.insert(colonyPlots, pPlot)
			-- print("New colony plot found")
			-- print("Plot: "..tostring(pPlot:GetX())..", "..tostring(pPlot:GetY()))	
		else
			-- print("isWater is "..tostring(isWater))
			-- print("isOwned is "..tostring(isOwned))
			-- print("isUnit is "..tostring(isUnit))
		end
	end
	if #colonyPlots == 0 then
		print("InitiateColonization_GetCoastalPlots found no coastal plots")
	end
	return colonyPlots
end

function InitiateColonization_GetIslandPlots(coastalPlots)
	local colonyPlots = {}
	for i, iPlotIndex in ipairs(coastalPlots) do
		-- print("Checking coastal plot...")
		local pPlot = Map.GetPlotByIndex(iPlotIndex)
		local coastalLand = false
		local impassable = true
		local isOwned = true
		local isUnit  = true	
		if pPlot:IsCoastalLand() ~= nil then coastalLand = pPlot:IsCoastalLand() end
		if pPlot:IsOwned() ~= nil then isOwned = pPlot:IsOwned() end
		if pPlot:IsUnit() ~= nil then isUnit = pPlot:IsUnit() end
		if pPlot:IsImpassable() ~= nil then impassable = pPlot:IsImpassable() end
		if coastalLand and not isOwned and not impassable then 
			local iWaterAdjacent = 0
			for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
				local adjacentPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), direction)
				if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
					iWaterAdjacent = iWaterAdjacent + 1
				end
			end		
			if iWaterAdjacent >= 4 then
				table.insert(colonyPlots, pPlot)
				-- print("New colony plot found")
				-- print("Plot: "..tostring(pPlot:GetX())..", "..tostring(pPlot:GetY()))							
			end
		else
			-- print("isWater is "..tostring(isWater))
			-- print("isOwned is "..tostring(isOwned))
			-- print("isUnit is "..tostring(isUnit))
		end
	end
	if #colonyPlots == 0 then
		print("InitiateColonization_GetIslandPlots found no island plots")
	end
	return colonyPlots
end

function InitiateColonization_GetPlotsByFeature(coastalPlots, featureIndex)
	--Example featureIndex value:
	--GameInfo.Features["FEATURE_YOSEMITE"].Index
	local colonyPlots = {}
	for i, iPlotIndex in ipairs(coastalPlots) do
		-- print("Checking coastal plot...")				
		local pPlot = Map.GetPlotByIndex(iPlotIndex)
		local plotX = pPlot:GetX()
		local plotY = pPlot:GetY()
		if pPlot:GetFeatureType() == featureIndex then
			local range = 3
			for dx = -range, range do
				for dy = -range, range do
					-- print("Searching for plots nearby Yosemite...")								
					local otherPlot = Map.GetPlotXY(plotX, plotY, dx, dy, range)
					if otherPlot then
						local coastalLand = false
						local impassable = true
						local isOwned = true
						local isUnit  = true
						if otherPlot:IsCoastalLand() ~= nil then coastalLand = otherPlot:IsCoastalLand() end
						if otherPlot:IsOwned() ~= nil then isOwned = otherPlot:IsOwned() end
						if otherPlot:IsUnit() ~= nil then isUnit = otherPlot:IsUnit() end
						if otherPlot:IsImpassable() ~= nil then impassable = otherPlot:IsImpassable() end
						if not isOwned and not impassable then 
							table.insert(colonyPlots, otherPlot)
							-- print("New colony plot found")
							-- print("Plot: "..tostring(pPlot:GetX())..", "..tostring(pPlot:GetY()))		
						else
							-- print("isWater is "..tostring(isWater))
							-- print("isOwned is "..tostring(isOwned))
							-- print("isUnit is "..tostring(isUnit))
						end									
					end
				end
			end							
		end
	end
	if #colonyPlots == 0 then
		print("InitiateColonization_GetPlotsByFeature found no plots by feature")
	end
	return colonyPlots
end

function InitiateColonization_BestColonyPlot(colonyPlots)
	local plotScore = -100
	local selectedPlot = false
	for i, pPlot in ipairs(colonyPlots) do
		if pPlot then
			local iScore = ScoreColonyPlot(pPlot)
			local plotX = pPlot:GetX()
			local plotY = pPlot:GetY()
			local tooCloseToCity = false
			local range = 3
			if iScore >= plotScore then 
				for dx = -range, range do
					for dy = -range, range do
						-- print("Searching for nearby cities...")								
						local otherPlot = Map.GetPlotXY(plotX, plotY, dx, dy, range)
						if otherPlot then
							local isCity = otherPlot:IsCity()
							if isCity then
								tooCloseToCity = true
							end
						end
					end
				end	
				if not tooCloseToCity then
					plotScore = iScore 
					selectedPlot = pPlot
					if selectedPlot:IsUnit() then
						MoveStartingPlotUnits(Units.GetUnitsInPlot(selectedPlot), selectedPlot)
					end
				end
			end						
		end			
	end
	return selectedPlot
end

function InitiateColonization_BestColonyByDistance(colonyPlots, startingPlot)
	local plotScore = -100
	local selectedPlot = false
	for i, pPlot in ipairs(colonyPlots) do
		if pPlot then
			local iScore = ScoreColonyPlotsByDistance(pPlot, startingPlot)
			local plotX = pPlot:GetX()
			local plotY = pPlot:GetY()	
			local tooCloseToCity = false
			local range = 3
			if iScore >= plotScore then 
				for dx = -range, range do
					for dy = -range, range do
						-- print("Searching for nearby cities...")								
						local otherPlot = Map.GetPlotXY(plotX, plotY, dx, dy, range)
						if otherPlot then
							local isCity = otherPlot:IsCity()
							if isCity then
								tooCloseToCity = true
							end
						end
					end
				end	
				if not tooCloseToCity then
					plotScore = iScore 
					selectedPlot = pPlot
					if selectedPlot:IsUnit() then
						MoveStartingPlotUnits(Units.GetUnitsInPlot(selectedPlot), selectedPlot)
					end					
				end
			end						
		end			
	end
	return selectedPlot
end

function InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
	local plotScore = -100
	local selectedPlot = false
	for i, pPlot in ipairs(colonyPlots) do
		if pPlot then
			local iScore = ScoreColonyPlotsMostDistant(pPlot, startingPlot)
			local plotX = pPlot:GetX()
			local plotY = pPlot:GetY()	
			local tooCloseToCity = false
			local range = 3
			if iScore >= plotScore then 
				for dx = -range, range do
					for dy = -range, range do
						-- print("Searching for nearby cities...")								
						local otherPlot = Map.GetPlotXY(plotX, plotY, dx, dy, range)
						if otherPlot then
							local isCity = otherPlot:IsCity()
							if isCity then
								tooCloseToCity = true
							end
						end
					end
				end	
				if not tooCloseToCity then
					plotScore = iScore 
					selectedPlot = pPlot
					if selectedPlot:IsUnit() then
						MoveStartingPlotUnits(Units.GetUnitsInPlot(selectedPlot), selectedPlot)
					end					
				end
			end						
		end			
	end
	return selectedPlot
end

function InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
	local CityManager = WorldBuilder.CityManager or ExposedMembers.CityManager
	local pOwnerID = pCity:GetOwner()
	local harborPlots = {}
	local bHarbor = false
	local harborDistrict = false
	while (harborDistrict == false) do
		if sCivTypeName == "CIVILIZATION_ENGLAND" then
			harborDistrict = GameInfo.Districts["DISTRICT_ROYAL_NAVY_DOCKYARD"].Index
		elseif(sCivTypeName == "CIVILIZATION_PHOENICIA") then
			harborDistrict = GameInfo.Districts["DISTRICT_COTHON"].Index
		else
			if GameInfo.Districts["DISTRICT_HARBOR"] then 
				harborDistrict = GameInfo.Districts["DISTRICT_HARBOR"].Index 
			end
		end
	end
	if pCity then
		local harborPlot = false
		for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
			local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
			local isResource = false
			local isFeature	= false
			if adjacentPlot and adjacentPlot:GetResourceType() ~= -1 then isResource = true end
			if adjacentPlot and adjacentPlot:GetFeatureType() ~= -1 then isFeature = true end
			if adjacentPlot and adjacentPlot:IsWater() and not isFeature and not isResource then
				harborPlot = adjacentPlot
				table.insert(harborPlots, harborPlot)
				print("Harbor plot found")
			end
		end	
		if harborPlot then
			local randPlotID = RandRange(1, #harborPlots, "Selecting adjacent water plot to build Harbor district")
			local pCityBuildQueue = pCity:GetBuildQueue()
			-- local iDistrictType = GameInfo.Districts["DISTRICT_HARBOR"].Index
			local iConstructionLevel = 100				
			pCityBuildQueue:CreateIncompleteDistrict(harborDistrict, harborPlots[randPlotID]:GetIndex(), iConstructionLevel)
			bHarbor = true
			print("Spawning harbor in city")
		else
			print("A harbor plot could not be found")
			-- totalslacker: Attempts to search further for a possible harbor plot, not tested
			-- local adjacentPlots = {}
			-- for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
				-- local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
				-- if adjacentPlot then
					-- table.insert(adjacentPlots, adjacentPlot)
				-- end
			-- end	
			-- for j, pPlot in ipairs(adjacentPlots) do 
				-- for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
					-- local adjacentPlot = Map.GetAdjacentPlot(pPlot:GetX(), pPlot:GetY(), direction)
					-- if adjacentPlot then
						-- local isResource = false
						-- local isFeature	= false
						-- if adjacentPlot and adjacentPlot:GetResourceType() ~= -1 then isResource = true end
						-- if adjacentPlot and adjacentPlot:GetFeatureType() ~= -1 then isFeature = true end
						-- if adjacentPlot:IsWater() and adjacentPlot:IsAdjacentToLand() and not isResource and not isFeature then
							-- harborPlot = adjacentPlot
							-- table.insert(harborPlots, harborPlot)
							-- print("Harbor plot found")							
						-- end
					-- end
				-- end					
			-- end
			-- if harborPlot then
				-- local randPlotID = RandRange(1, #harborPlots, "Selecting adjacent water plot to build Harbor district")
				-- local plot = harborPlots[randPlotID]
				-- if CityManager then
					-- CityManager():SetPlotOwner(plot:GetX(), plot:GetY(), false )
					-- CityManager():SetPlotOwner(plot:GetX(), plot:GetY(), pOwnerID, pCity:GetID())	
					-- local pCityBuildQueue = pCity:GetBuildQueue()
					-- local iDistrictType = GameInfo.Districts["DISTRICT_HARBOR"].Index
					-- local iConstructionLevel = 100				
					-- pCityBuildQueue:CreateIncompleteDistrict(iDistrictType, plot:GetIndex(), iConstructionLevel)
					-- bHarbor = true
					-- print("Spawning harbor in city")	
				-- end					
			-- else
				-- print("A harbor plot could not be found")
			-- end
		end
	end
	return bHarbor
end

function InitiateColonization_FirstWave(PlayerID, sCivTypeName)
	local pPlayer = Players[PlayerID]
	local startingPlot = pPlayer:GetStartingPlot()
	if sCivTypeName == "CIVILIZATION_ENGLAND" then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_NORTH_AMERICA") then
				print("England is founding a new colony in North America...")
				local colonyPlots = {}
				local sortedPlots = {}		
				local selectedPlot = false			
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyByDistance(colonyPlots, startingPlot)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning English colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end			
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_FRANCE") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_NORTH_AMERICA") then
				print("France is founding a new colony in North America...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyByDistance(colonyPlots, startingPlot)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end				
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning French colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end			
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_GERMANY") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AFRICA") then
				print("Germany is founding a new colony in Africa...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end			
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning German colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end			
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_NETHERLANDS") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_NORTH_AMERICA") then
				print("Netherlands is founding a new colony in North America...")
				local colonyPlots = {}
				local sortedPlots = {}
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyByDistance(colonyPlots, startingPlot)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Dutch colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AFRICA") then
				print("Netherlands is founding a new colony in Africa...")
				local colonyPlots = {}
				local sortedPlots = {}
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Dutch colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end	
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_PORTUGAL") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AFRICA") then
				print("Portugal is founding a new colony in Africa...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end				
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Portuguese colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (Portugal gets extra Naus)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PORTUGUESE_NAU", adjacentPlot:GetX(), adjacentPlot:GetY())
						end
					end
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_ASIA") then
				print("Portugal is founding a new colony in Asia")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetIslandPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Portuguese colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (Portugal gets extra Naus)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PORTUGUESE_NAU", adjacentPlot:GetX(), adjacentPlot:GetY())
						end
					end	
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_SOUTH_AMERICA") then
				print("Portugal is founding a new colony in South America...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyByDistance(colonyPlots, startingPlot)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end				
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Portuguese colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PORTUGUESE_NAU", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end
				end
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_SCOTLAND") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_NORTH_AMERICA") then
				print("Scotland is founding a new colony in North America...")
				local colonyPlots = {}
				local sortedPlots = {}
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyByDistance(colonyPlots, startingPlot)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_SCOTTISH_HIGHLANDER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Scottish colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end			
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_SPAIN") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_SOUTH_AMERICA") then
				print("Spain is founding a new colony in South America...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnit(PlayerID, "UNIT_SPANISH_CONQUISTADOR", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Spanish colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_NORTH_AMERICA") then
				print("Spain is founding a new colony in North America...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetIslandPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end	
					UnitManager.InitUnit(PlayerID, "UNIT_SPANISH_CONQUISTADOR", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Spanish colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end							
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_ASIA") then
				print("Spain is founding a new colony in Asia...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				if GameInfo.Features["FEATURE_CHOCOLATEHILLS"] then
					colonyPlots = InitiateColonization_GetPlotsByFeature(coastalPlots, GameInfo.Features["FEATURE_CHOCOLATEHILLS"].Index)
				else
					colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				end
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnit(PlayerID, "UNIT_SPANISH_CONQUISTADOR", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_SPANISH_CONQUISTADOR", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Spanish colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_CARAVEL", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end
				end	
			end
		end
	else
		print("Custom or modded civilization detected in ColonizerCivs table")
		print("Activating generic Colonization Mode for custom civilization: "..tostring(sCivTypeName))
		local iRandomContinent = Game.GetRandNum(2, "Random Continent Roll")
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_NORTH_AMERICA" and iRandomContinent == 0) then
				print("Generic or modded civilization is founding a new colony in North America...")
				local colonyPlots = {}
				local sortedPlots = {}
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Generic Civilization colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_SOUTH_AMERICA" and iRandomContinent == 1) then
				print("Generic or modded civilization is founding a new colony in South America...")
				local colonyPlots = {}
				local sortedPlots = {}
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				--Select possible colony plots
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				--Find the best plot in the selection
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				--Create colony on selected plot
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Generic Civilization colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end					
			end
		end		
	end
	Game:SetProperty("Colonization_Wave01_Player_#"..PlayerID, 1)
	return selectedPlot
end

function InitiateColonization_SecondWave(PlayerID, sCivTypeName)
	local pPlayer = Players[PlayerID]
	local startingPlot = pPlayer:GetStartingPlot()
	if sCivTypeName == "CIVILIZATION_ENGLAND" then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AUSTRALIA") then
				print("England is founding a new colony in Australia...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local coastalPlots = Map.GetContinentPlots(iContinent)			
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				if selectedPlot then					
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning English colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_ENGLISH_SEADOG", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_ZEALANDIA") then
				print("England is founding a new colony in Zealandia...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100				
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyByDistance(colonyPlots, startingPlot)
				if selectedPlot then					
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning English colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_ENGLISH_SEADOG", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end
				end	
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_FRANCE") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AUSTRALIA") then
				print("France is founding a new colony in Australia...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning French colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PRIVATEER", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end					
				end			
			elseif (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_OCEANIA") then
				print("France is founding a new colony in Australia...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_FIELD_CANNON", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning French colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PRIVATEER", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end					
				end			
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_GERMANY") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_OCEANIA") then
				print("Germany is founding a new colony in Oceania...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_FIELD_CANNON", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning German colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PRIVATEER", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end	
				end			
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_NETHERLANDS") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AUSTRALIA") then
				print("Netherlands is founding a new colony in Australia...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyByDistance(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Dutch colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PRIVATEER", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end	
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_ASIA") then
				print("Netherlands is founding a new colony in Asia")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetIslandPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Dutch colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_DE_ZEVEN_PROVINCIEN", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end	
				end			
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_PORTUGAL") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AFRICA") then
				print("Portugal is founding a new colony in Africa...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Portuguese colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (Portugal gets extra Naus)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PORTUGUESE_NAU", adjacentPlot:GetX(), adjacentPlot:GetY())
						end
					end	
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_ASIA") then
				print("Portugal is founding a new colony in Asia")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetIslandPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Portuguese colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (Portugal gets extra Naus)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PORTUGUESE_NAU", adjacentPlot:GetX(), adjacentPlot:GetY())
						end
					end	
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_SOUTH_AMERICA") then
				print("Portugal is founding a new colony in South America")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyByDistance(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Portuguese colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PORTUGUESE_NAU", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end	
				end			
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_SPAIN") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_SOUTH_AMERICA") then
				print("Spain is founding a new colony in South America...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnit(PlayerID, "UNIT_SPANISH_CONQUISTADOR", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_SPANISH_CONQUISTADOR", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Spanish colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end			
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_NORTH_AMERICA") then
				print("Spain is founding a new colony in North America...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				if GameInfo.Features["FEATURE_YOSEMITE"] then
					colonyPlots = InitiateColonization_GetPlotsByFeature(coastalPlots, GameInfo.Features["FEATURE_YOSEMITE"].Index)
				else
					colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				end
				
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnit(PlayerID, "UNIT_SPANISH_CONQUISTADOR", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_SPANISH_CONQUISTADOR", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Spanish colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
				end				
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_ASIA") then
				print("Spain is founding a new colony in Asia")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetIslandPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_SPANISH_CONQUISTADOR", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Spanish colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_FRIGATE", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end	
				end				
			end
		end
	else
		print("Custom or modded civilization detected in ColonizerCivs table")
		print("Activating generic Colonization Mode for custom civilization: "..tostring(sCivTypeName))
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AUSTRALIA") then
				print("Generic or modded civilization is founding a new colony in Australia...")
				local colonyPlots = {}
				local sortedPlots = {}
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_RANGER", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Generic Civilization colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_PRIVATEER", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end
				end			
			end
		end		
	end
	Game:SetProperty("Colonization_Wave02_Player_#"..PlayerID, 1)
	return selectedPlot
end

function InitiateColonization_ThirdWave(PlayerID, sCivTypeName)
	local pPlayer = Players[PlayerID]
	local startingPlot = pPlayer:GetStartingPlot()
	if sCivTypeName == "CIVILIZATION_ENGLAND" then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AFRICA") then
				print("England is founding a new colony in Africa...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local coastalPlots = Map.GetContinentPlots(iContinent)			
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				if selectedPlot then					
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_ENGLISH_REDCOAT", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_ENGLISH_REDCOAT", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning English colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_IRONCLAD", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end
				end	
			elseif(GameInfo.Continents[iContinent].ContinentType == "CONTINENT_ASIA") then
				print("England is founding a new colony in Asia...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100				
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				if selectedPlot then					
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_ENGLISH_REDCOAT", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning English colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_IRONCLAD", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end
				end	
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_FRANCE") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AFRICA") then
				print("France is founding a new colony in Africa...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_FRENCH_GARDE_IMPERIALE", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_FRENCH_GARDE_IMPERIALE", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning French colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_IRONCLAD", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end					
				end						
			end
		end
	elseif(sCivTypeName == "CIVILIZATION_GERMANY") then
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AFRICA") then
				print("Germany is founding a new colony in Africa...")
				local colonyPlots = {}
				local sortedPlots = {}	
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyPlot(colonyPlots)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_FIELD_CANNON", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_FIELD_CANNON", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning German colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_IRONCLAD", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end	
				end			
			end
		end
	else
		print("Custom or modded civilization detected in ColonizerCivs table")
		print("Activating generic Colonization Mode for custom civilization: "..tostring(sCivTypeName))
		local tContinents = Map.GetContinentsInUse()
		for i,iContinent in ipairs(tContinents) do
			if (GameInfo.Continents[iContinent].ContinentType == "CONTINENT_AFRICA") then
				print("Generic or modded civilization is founding a new colony in Africa...")
				local colonyPlots = {}
				local sortedPlots = {}
				local selectedPlot = false	
				local plotScore = -100
				local coastalPlots = Map.GetContinentPlots(iContinent)
				colonyPlots = InitiateColonization_GetCoastalPlots(coastalPlots)
				selectedPlot = InitiateColonization_BestColonyMostDistant(colonyPlots, startingPlot)
				if selectedPlot then
					local pCity = pPlayer:GetCities():Create(selectedPlot:GetX(), selectedPlot:GetY())
					if pCity then
						local bHarbor = InitiateColonization_BuildHarborInColony(selectedPlot, pCity, sCivTypeName)
					else
						print("Failed to spawn city. Spawning settler instead.")
						UnitManager.InitUnit(PlayerID, "UNIT_SETTLER", selectedPlot:GetX(), selectedPlot:GetY())
					end
					UnitManager.InitUnitValidAdjacentHex(PlayerID, "UNIT_BUILDER", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_ENGLISH_REDCOAT", selectedPlot:GetX(), selectedPlot:GetY())
					UnitManager.InitUnit(PlayerID, "UNIT_ENGLISH_REDCOAT", selectedPlot:GetX(), selectedPlot:GetY())
					print("Spawning Generic Civilization colonizer units at plot "..tostring(selectedPlot:GetX())..", "..tostring(selectedPlot:GetY()))
					--Spawn water units last (we're using a break statement)
					for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
						local adjacentPlot = Map.GetAdjacentPlot(selectedPlot:GetX(), selectedPlot:GetY(), direction)
						if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
							UnitManager.InitUnit(PlayerID, "UNIT_IRONCLAD", adjacentPlot:GetX(), adjacentPlot:GetY())
							break
						end
					end
				end			
			end
		end		
	end
	Game:SetProperty("Colonization_Wave03_Player_#"..PlayerID, 1)
	return selectedPlot
end