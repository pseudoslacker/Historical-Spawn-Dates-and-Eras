-- ===========================================================================
-- Raging Barbarians & Unique Barbarians mode
-- ===========================================================================

local g_CurrentBarbarianCamp = {}

local iNavalBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_NAVAL"].Index
local iCavalryBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_CAVALRY"].Index
local iMeleeBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_MELEE"].Index
local iKongoBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_KONGO"].Index
local iZuluBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_ZULU"].Index
local iNubianBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_NUBIAN"].Index
local iCelticBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_CELTIC"].Index
local iGreekBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_GREEK"].Index
local iVikingBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_VIKING"].Index
local iBarbaryCoastTribe = GameInfo.BarbarianTribes["TRIBE_BARBARY"].Index
local iCreeBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_CREE"].Index
local iScythianBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_SCYTHIAN"].Index
local iAztecBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_AZTEC"].Index
local iMaoriBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_MAORI"].Index
local iVaruBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_VARU"].Index
local iIberianBarbarianTribe = GameInfo.BarbarianTribes["TRIBE_IBERIAN"].Index

local ContinentDimensions = {}

function GetContinentDimensions()
	print("Gathering continent dimensions...")
	local g_iW, g_iH = Map.GetGridSize()
	print("Map width is "..tostring(g_iW).." and Map height is "..tostring(g_iH))
	local tContinents = Map.GetContinentsInUse()
	for i,iContinent in ipairs(tContinents) do
		if (GameInfo.Continents[iContinent].ContinentType) then
			print("Continent type is "..tostring(GameInfo.Continents[iContinent].ContinentType))
			local baseY = 300;
			local maxY = 0;
			local spanY = 0;
			local lowerHalf = 0;
			local baseX = 300;
			local maxX = 0;
			local spanX = 0;
			local rightHalf = 0;
			local wrapContinent = false
			local continentTypeName = GameInfo.Continents[iContinent].ContinentType
			local continentPlotIndexes = Map.GetContinentPlots(iContinent)
			for j, pPlot in ipairs(continentPlotIndexes) do
				local continentPlot = Map.GetPlotByIndex(pPlot); --get plot by index, continentPlotIndexes is an index table, not plot objects
				if continentPlot:GetX() > maxX then maxX = continentPlot:GetX() end
				if continentPlot:GetX() < baseX then baseX = continentPlot:GetX() end
				if continentPlot:GetY() > maxY then maxY = continentPlot:GetY() end
				if continentPlot:GetY() < baseY then baseY = continentPlot:GetY() end
			end
			-- print("Finding the height and width of the continent, and the central axes")
			spanX = maxX - baseX
			rightHalf = (maxX - (spanX/2))
			spanY = maxY - baseY
			lowerHalf = (maxY - (spanY/2))
			if (baseX == 0) and (maxX == (g_iW - 1)) then
				print("Detected continent that crosses the edge of the map")
				wrapContinent = true
				local xSpanTable = {}
				local ContinentPlots = {}
				local Nullspace = {}
				local iCount = 0
				local largestNullSpace = 0
				local boundaryIndex = 0
				for j, pPlot in ipairs(continentPlotIndexes) do
					local continentPlot = Map.GetPlotByIndex(pPlot); --get plot by index, continentPlotIndexes is an index table, not plot objects
					if not ContinentPlots[continentPlot:GetX()] then
						ContinentPlots[continentPlot:GetX()] = continentPlot:GetX()
					end
				end
				for i = 0, (g_iW - 1), 1 do
					if ContinentPlots[i] then
						table.insert(xSpanTable, ContinentPlots[i])
					else
						table.insert(xSpanTable, -1)
						table.insert(Nullspace, i)
					end
				end
				-- print("Iterate null space")
				-- for j, pPlot in ipairs(Nullspace) do
					-- print(Nullspace[j])
				-- end
				for j, nullPlot in ipairs(Nullspace) do
					if (Nullspace[j + 1] ==  (nullPlot + 1)) then
						iCount = iCount + 1
					else
						if largestNullSpace < iCount then
							largestNullSpace = iCount
							boundaryIndex = Nullspace[j - largestNullSpace]
							print("Largest null space is "..tostring(largestNullSpace))
							print("Boundary index is "..tostring(boundaryIndex))
						end
						iCount = 0
					end
				end
				-- print("Iterate span table")
				-- for j, pPlot in ipairs(xSpanTable) do
					-- print(xSpanTable[j])
				-- end
				baseX = boundaryIndex + largestNullSpace
				maxX = maxX + boundaryIndex
				spanX = maxX - baseX
				rightHalf = (maxX - (spanX/2))
				if rightHalf > (g_iW - 1) then
					print("Right half of continent begins beyond the edge of the map")
					rightHalf = rightHalf - g_iW
				end
			end	
			print("Base X is : "..tostring(baseX))
			print("Max X is : "..tostring(maxX))
			print("Span of X is : "..tostring(spanX))
			print("Right half of X begins at : "..tostring(rightHalf))
			print("Base Y is : "..tostring(baseY))
			print("Max Y is : "..tostring(maxY))
			print("Span of Y is : "..tostring(spanY))
			print("Lower half of Y begins at : "..tostring(lowerHalf))
			ContinentDimensions[continentTypeName] = {maxX = maxX, spanX = spanX, rightHalf = rightHalf, maxY = maxY, spanY = spanY, lowerHalf = lowerHalf, baseX = baseX}
			-- print("Table results: maxX is "..tostring(ContinentDimensions[continentTypeName].maxX))
		end
	end	
end

function CreateTribeAt( eType, iPlotIndex )
	local pBarbManager = Game.GetBarbarianManager()
	local pPlot = Map.GetPlotByIndex(iPlotIndex)
	-- print("Clearing existing camp")
	ImprovementBuilder.SetImprovementType(pPlot, -1, NO_PLAYER)
	-- print("New camp created")
	local iTribeNumber = pBarbManager:CreateTribeOfType(eType, iPlotIndex)
	-- print("Spawning camp defender of type "..tostring(GameInfo.BarbarianTribes[eType].DefenderTag))
	-- pBarbManager:CreateTribeUnits(eType, GameInfo.BarbarianTribes[eType].DefenderTag, 1, iPlotIndex, 1)
	return iTribeNumber
end

function SpawnBarbsByPlayer(campPlot)
	local bBarbarian = false
	local isBarbarian = false
	local isFreeCities = false
	local iShortestDistance = 10000
	local closestPlayerName = false
	for iPlayer = 0, 63 do
		local pPlayer = Players[iPlayer]
		if pPlayer and pPlayer:IsMajor() then
			-- unfinished
		end
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
		bBarbarian = SpawnUniqueBarbarianTribe(campPlot, closestPlayerName)
	end
	return bBarbarian
end

function SpawnBarbsByContinent(campPlot)
	local bBarbarian = false
	local continentType = campPlot:GetContinentType()
	if continentType and GameInfo.Continents[continentType] then
		bBarbarian = SpawnUniqueBarbarianTribe(campPlot, GameInfo.Continents[continentType].ContinentType)
	end
	return bBarbarian
end

function SpawnRagingBarbs(iBarbarianTribe, campPlot)
	local iRange = 3
	if iBarbarianTribe == iZuluBarbarianTribe then
		pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_ZULU", 1, campPlot:GetIndex(), iRange);
	end
end

function SpawnUniqueBarbarianTribe(campPlot, sCivTypeName)
	print("Spawning a unique barbarian camp for "..tostring(sCivTypeName))
	local bBarbarian = false
	local bIsCoastalCamp = false
	local pBarbManager = Game.GetBarbarianManager() 
	local iRange = 3;
	local maxY = ContinentDimensions[sCivTypeName].maxY
	local spanY = ContinentDimensions[sCivTypeName].spanY
	local lowerHalf = ContinentDimensions[sCivTypeName].lowerHalf
	local maxX = ContinentDimensions[sCivTypeName].maxX
	local spanX = ContinentDimensions[sCivTypeName].spanX
	local rightHalf = ContinentDimensions[sCivTypeName].rightHalf
	local baseX = ContinentDimensions[sCivTypeName].baseX
	-- print("Checking barbarian camp surroundings")
	if campPlot:IsCoastalLand() then
		print("Coastal land camp detected. Checking adjacent plots...")
		local iWaterAdjacent = 0
		for direction = 0, DirectionTypes.NUM_DIRECTION_TYPES - 1, 1 do
			local adjacentPlot = Map.GetAdjacentPlot(campPlot:GetX(), campPlot:GetY(), direction)
			if adjacentPlot and adjacentPlot:IsWater() and not adjacentPlot:IsLake() then
				iWaterAdjacent = iWaterAdjacent + 1
			end
		end		
		print("iWaterAdjacent is "..tostring(iWaterAdjacent))
		if iWaterAdjacent >= 3 then		
			print("iWaterAdjacent is high enough to spawn a naval tribe")
			bIsCoastalCamp = true
		end
	end	
	print("Spawning barbarian camp based on continent")
	if sCivTypeName == "CONTINENT_AFRICA" then
		if bIsCoastalCamp then
			if (campPlot:GetY() < lowerHalf) then
				--Southern Africa
				if ((campPlot:GetX() < rightHalf) and (campPlot:GetX() >= baseX)) or ((baseX > rightHalf) and ((campPlot:GetX() < rightHalf) or (campPlot:GetX() >= baseX))) then
					--Atlantic coast
					print("Spawning Kalahari tribes")
					local eBarbarianTribeType = iZuluBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_ZULU", 1, campPlot:GetIndex(), 0);
				else
					--Indian coast
					print("Spawning Swahili tribes")
					local eBarbarianTribeType = iBarbaryCoastTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_ZULU", 1, campPlot:GetIndex(), 0);
				end
			else
				--North African coast
				if ((campPlot:GetX() < rightHalf) and (campPlot:GetX() >= baseX)) or ((baseX > rightHalf) and ((campPlot:GetX() < rightHalf) or (campPlot:GetX() >= baseX))) then
					--Maghreb
					print("Spawning Barbary tribes")
					local eBarbarianTribeType = iBarbaryCoastTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_ANTICAV", 1, campPlot:GetIndex(), 0);
				else
					--Libya
					print("Spawning Libyan tribes")
					local eBarbarianTribeType = iGreekBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_HOPLITE", 1, campPlot:GetIndex(), 0);
				end
			end
		elseif(not bIsCoastalCamp) then
			if campPlot:GetFeatureType() == GameInfo.Features["FEATURE_JUNGLE"].Index then
				print("Spawning Kongo tribes")
				local eBarbarianTribeType = iKongoBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_KONGO", 2, campPlot:GetIndex(), iRange);
			elseif(campPlot:GetY() < lowerHalf) then
				--Subsaharan Africa
				print("Spawning Zulu tribes")
				local eBarbarianTribeType = iZuluBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_ZULU", 2, campPlot:GetIndex(), iRange);
			else
				--Nubian
				print("Spawning Nubian tribes")
				local eBarbarianTribeType = iNubianBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_NUBIAN", 2, campPlot:GetIndex(), iRange);
			end
		end
	elseif(sCivTypeName == "CONTINENT_ASIA") then
		if bIsCoastalCamp then
			if (campPlot:GetY() < lowerHalf) then
				--Southern Asia
				if ((campPlot:GetX() < rightHalf) and (campPlot:GetX() >= baseX)) or ((baseX > rightHalf) and ((campPlot:GetX() < rightHalf) or (campPlot:GetX() >= baseX))) then
					--Middle East
					print("Spawning Middle Eastern naval tribes")
					local eBarbarianTribeType = iNavalBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_ANTICAV", 1, campPlot:GetIndex(), 0)
				else
					--Indochina
					print("Spawning Indochina naval tribes")
					local eBarbarianTribeType = iMaoriBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_ANTICAV", 1, campPlot:GetIndex(), 0)
				end
			else
				--Northern Asia
				if ((campPlot:GetX() < rightHalf) and (campPlot:GetX() >= baseX)) or ((baseX > rightHalf) and ((campPlot:GetX() < rightHalf) or (campPlot:GetX() >= baseX))) then
					--Central Asia
					print("Spawning Central Asian naval tribes")
					local eBarbarianTribeType = iScythianBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_ANTICAV", 1, campPlot:GetIndex(), 0)
				else
					--East Asia
					print("Spawning East Asian naval tribes")
					local eBarbarianTribeType = iMaoriBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_ANTICAV", 1, campPlot:GetIndex(), 0)
				end
			end
		elseif(not bIsCoastalCamp) then
			if (campPlot:GetY() < lowerHalf) then
				--Southern Asia
				if ((campPlot:GetX() < rightHalf) and (campPlot:GetX() >= baseX)) or ((baseX > rightHalf) and ((campPlot:GetX() < rightHalf) or (campPlot:GetX() >= baseX))) then
					--Middle East
					print("Spawning Middle Eastern tribes")
					local eBarbarianTribeType = iBarbaryCoastTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				else
					--Indochina
					if campPlot:GetFeatureType() == GameInfo.Features["FEATURE_JUNGLE"].Index then
						print("Spawning Varu tribes")
						local eBarbarianTribeType = iVaruBarbarianTribe
						local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					else
						print("Spawning Libyan tribes")
						local eBarbarianTribeType = iGreekBarbarianTribe
						local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					end
				end
			else
				--Northern Asia
				print("Spawning Scythian tribes")
				local eBarbarianTribeType = iScythianBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 2, campPlot:GetIndex(), iRange);
			end
		end
	elseif(sCivTypeName == "CONTINENT_EUROPE") then
		if bIsCoastalCamp then
			if (campPlot:GetY() < lowerHalf) then
				--Southern Europe
				if ((campPlot:GetX() < rightHalf) and (campPlot:GetX() >= baseX)) or ((baseX > rightHalf) and ((campPlot:GetX() < rightHalf) or (campPlot:GetX() >= baseX))) then
					--Western Med
					print("Spawning Iberian naval tribes")
					local eBarbarianTribeType = iGreekBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 1, campPlot:GetIndex(), iRange);
				else
					--Eastern Med
					print("Spawning Greek tribes")
					local eBarbarianTribeType = iGreekBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_HOPLITE", 1, campPlot:GetIndex(), iRange);
				end
			else
				--Northern Europe
				print("Spawning Viking tribes")
				local eBarbarianTribeType = iVikingBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_MELEE_BERSERKER", 1, campPlot:GetIndex(), iRange);
			end
		elseif(not bIsCoastalCamp) then
			if (campPlot:GetY() < lowerHalf) then
				--Southern Europe
				print("Spawning Iberian tribes")
				if ((campPlot:GetX() < rightHalf) and (campPlot:GetX() >= baseX)) or ((baseX > rightHalf) and ((campPlot:GetX() < rightHalf) or (campPlot:GetX() >= baseX))) then
					print("Spawning Iberian tribes")
					local eBarbarianTribeType = iIberianBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 2, campPlot:GetIndex(), iRange);
				else
				
				end
			else
				--Northern Europe
				print("Spawning Celtic tribes")
				local eBarbarianTribeType = iCelticBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 2, campPlot:GetIndex(), iRange);
			end
		end
	elseif(sCivTypeName == "CONTINENT_NORTH_AMERICA") then
		if bIsCoastalCamp then
			if (campPlot:GetY() < lowerHalf) then
				--Southern NA
				if ((campPlot:GetX() < rightHalf) and (campPlot:GetX() >= baseX)) or ((baseX > rightHalf) and ((campPlot:GetX() < rightHalf) or (campPlot:GetX() >= baseX))) then
					--Pacific Coast
					print("Spawning West Coast tribes")
					local eBarbarianTribeType = iCreeBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 1, campPlot:GetIndex(), iRange);
				else
					--Atlantic Coast
					print("Spawning East Coast tribes")
					local eBarbarianTribeType = iCreeBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_HOPLITE", 1, campPlot:GetIndex(), iRange);
				end
			else
				--Northern NA
				if ((campPlot:GetX() < rightHalf) and (campPlot:GetX() >= baseX)) or ((baseX > rightHalf) and ((campPlot:GetX() < rightHalf) or (campPlot:GetX() >= baseX))) then
					--Alaska / PNW
					print("Spawning Haida tribes")
					local eBarbarianTribeType = iVikingBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 1, campPlot:GetIndex(), iRange);
				else
					--Quebec
					print("Spawning Quebec tribes")
					local eBarbarianTribeType = iCreeBarbarianTribe
					local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
					-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_HOPLITE", 1, campPlot:GetIndex(), iRange);
				end
			end
		elseif(not bIsCoastalCamp) then
			if (campPlot:GetY() < lowerHalf) then
				--Southern NA
				print("Spawning Aztec tribes")
				local eBarbarianTribeType = iAztecBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 2, campPlot:GetIndex(), iRange);
			else
				--Northern NA
				print("Spawning Native American tribes")
				local eBarbarianTribeType = iCreeBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 2, campPlot:GetIndex(), iRange);
			end
		end
	elseif(sCivTypeName) then
		--Generic Continent
		if bIsCoastalCamp then
			print("Spawning generic naval tribes for continent "..tostring(sCivTypeName))
			local eBarbarianTribeType = iNavalBarbarianTribe
			local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
			-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_ANTI_CAVALRY", 2, campPlot:GetIndex(), iRange);
		elseif(not bIsCoastalCamp) then
			if campPlot:GetFeatureType() == GameInfo.Features["FEATURE_FOREST"].Index then
				print("Spawning generic tribes for continent "..tostring(sCivTypeName))
				local eBarbarianTribeType = iMeleeBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 2, campPlot:GetIndex(), iRange);
			elseif(campPlot:GetY() < (maxY - (spanY/2))) then
				--Southern Continent
				print("Spawning generic tribes for continent "..tostring(sCivTypeName))
				local eBarbarianTribeType = iMeleeBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 2, campPlot:GetIndex(), iRange);
			else
				--Northern Continent
				print("Spawning generic tribes for continent "..tostring(sCivTypeName))
				local eBarbarianTribeType = iMeleeBarbarianTribe
				local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
				-- pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_BARB_CELTIC", 2, campPlot:GetIndex(), iRange);
			end
		end
	end
	--Civilizations
	if sCivTypeName == "CIVILIZATION_KONGO" then
		local eBarbarianTribeType = 3 --Kongo
		local iBarbarianTribe = CreateTribeAt(eBarbarianTribeType, campPlot:GetIndex())
		pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_MELEE", 2, campPlot:GetIndex(), iRange);
		pBarbManager:CreateTribeUnits(iBarbarianTribe, "CLASS_RANGED", 1, campPlot:GetIndex(), iRange);
	end
	return bBarbarian
end

function SpawnBarbarians(iX, iY, eImprovement, playerID, resource, isPillaged, isWorked)
	local isBarbarian = false
	local isBarbCamp = false
	local pPlayer = Players[playerID]
	local campPlot : table = Map.GetPlot(iX, iY)
	-- print("Returning parameters")
	-- print("iX is "..tostring(iX)..", iY is "..tostring(iY)..", eImprovement is "..tostring(eImprovement)..", playerID is "..tostring(playerID)..", resource is "..tostring(resource)..", isPillaged is "..tostring(isPillaged)..", isWorked is "..tostring(isWorked))
	local prevCamp = Game:GetProperty("BarbarianCamp_"..campPlot:GetIndex())
	if (not prevCamp) and (Players[playerID] == Players[63]) then 
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
			
			--Obselete code below. We set the default barbarian camps to empty, instead of trying to delete the default units that spawn
			
			-- table.insert(g_CurrentBarbarianCamp, campPlot)
			-- print("#barbUnits is "..tostring(#barbUnits))
			-- ImprovementBuilder.SetImprovementType(campPlot, -1)
			-- print("Original barbarian camp destroyed")
			
			-- if plotUnits ~= nil then
				-- for i, pUnit in ipairs(plotUnits) do
					-- table.insert(toKill, pUnit)
				-- end
				-- for i, pUnit in ipairs(toKill) do
					-- UnitManager.Kill(pUnit)
					-- print("Killing original barbarian unit in camp")
				-- end	
				-- toKill = {}
			-- end	
			
			-- for i, pUnit in ipairs(barbUnits) do
				-- if pUnit then
					-- print("Barbarian unit detected at "..tostring(pUnit:GetX())..", "..tostring(pUnit:GetY()))
					-- local pUnitPlot = Map.GetPlot(pUnit:GetX(), pUnit:GetY())
					-- local distance = Map.GetPlotDistance(campPlot:GetIndex(), pUnitPlot:GetIndex());
					-- print("Plot distance is "..tostring(distance))
					-- if distance <= 3 then
						-- print("Barbarian scout detected")
						-- table.insert(toKill, pUnit)				
					-- end				
				-- end
			-- end
			
			-- local range = 3
			-- for dx = -range, range do
				-- for dy = -range, range do
					-- print("Searching for barbarian scouts nearby")
					-- local otherPlot = Map.GetPlotXY(campPlot:GetX(), campPlot:GetY(), dx, dy, range)
					-- if otherPlot and otherPlot:IsUnit() then
						-- local otherPlotUnits = Units.GetUnitsInPlot(otherPlot)
						-- for i, pUnit in ipairs(otherPlotUnits) do
							-- if pUnit and ((pUnit:GetTypeHash() == GameInfo.Units["UNIT_SCOUT"].Hash) or (pUnit:GetTypeHash() == GameInfo.Units["UNIT_SKIRMISHER"].Hash)) then
								-- local pUnitOwnerID = pUnit:GetOwner()
								-- if pUnitOwnerID == 63 then
									-- print("Barbarian recon unit detected")
									-- table.insert(toKill, pUnit)
								-- end
							-- end
						-- end
					-- end
				-- end
			-- end
			-- if #toKill > 0 then
				-- for i, pUnit in ipairs(toKill) do
					-- if pUnit then
						-- UnitManager.Kill(pUnit)
						-- print("Killing original barbarian scout")
					-- end
				-- end					
			-- end
			
			Game:SetProperty("BarbarianCamp_"..campPlot:GetIndex(), 1)
			print("Original barbarians removed from map")
			local newBarbCamp = SpawnBarbsByContinent(campPlot)
		end
	end
	return isBarbarian
end

--Obselete code, but still functional
function RemoveBarbScouts( playerID:number, unitID:number )
	local player 			= Players[playerID]
	if not player:IsBarbarian() then
		return
	end
	local unit 				= UnitManager.GetUnit(playerID, unitID)
	local turnsFromStart 	= Game.GetCurrentGameTurn() - GameConfiguration.GetStartTurn()
	local tempTable = {}
	if unit and player and (unit:GetType() == GameInfo.Units["UNIT_SCOUT"].Index) and player:IsBarbarian() then
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