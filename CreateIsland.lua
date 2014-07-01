function CreateIsland(Player) -- Creates a island for the player. Returns island number, positions x and z
	local posX = 0
	local posZ = 0
	
	-- Increase island number
	ISLAND_NUMBER = ISLAND_NUMBER + 1
	
	-- Get island position
	posX, posZ = GetIslandPosition(ISLAND_NUMBER)
	
	-- Create island at position
	CreateLayer(posX, 148, posZ, E_BLOCK_DIRT)
	CreateLayer(posX, 149, posZ, E_BLOCK_DIRT)
	CreateLayer(posX, 150, posZ, E_BLOCK_GRASS)
	
	-- Plant a tree
	SKYBLOCK:GrowTreeFromSapling(5 + posX, 151, posZ, E_META_SAPLING_APPLE)
	
	-- Create a chest and add items
	SKYBLOCK:SetBlock(posX, 151, 4 + posZ, E_BLOCK_CHEST, 2)
	SKYBLOCK:DoWithChestAt(posX, 151, 4 + posZ,
		function(a_ChestEntity)
            a_ChestEntity:SetSlot(0, 0, cItem(E_ITEM_LAVA_BUCKET, 1));
			a_ChestEntity:SetSlot(1, 0, cItem(E_BLOCK_ICE, 2));
            a_ChestEntity:SetSlot(2, 0, cItem(E_ITEM_MELON_SLICE, 1));
            a_ChestEntity:SetSlot(3, 0, cItem(E_BLOCK_CACTUS, 1));
            a_ChestEntity:SetSlot(4, 0, cItem(E_BLOCK_BROWN_MUSHROOM, 1));
            a_ChestEntity:SetSlot(5, 0, cItem(E_BLOCK_RED_MUSHROOM, 1));
            a_ChestEntity:SetSlot(6, 0, cItem(E_BLOCK_PUMPKIN, 1));
            a_ChestEntity:SetSlot(7, 0, cItem(E_ITEM_SUGARCANE, 1));
            a_ChestEntity:SetSlot(8, 0, cItem(E_ITEM_CARROT, 1));
            a_ChestEntity:SetSlot(0, 1, cItem(E_ITEM_POTATO, 1));
            a_ChestEntity:SetSlot(1, 1, cItem(E_ITEM_BONE, 3));
		end
	);
	
	return ISLAND_NUMBER, posX, posZ
end

function CreateLayer(posX, posY, posZ, material) -- Creates a layer for the island
	for x = -1,6 do
		for z = -1,1 do
			SKYBLOCK:SetBlock(x + posX, posY, z + posZ, material, 0)
		end 
	end
	
	for x = -1,1 do
		for z = 2,4 do
			SKYBLOCK:SetBlock(x + posX, posY, z + posZ, material, 0)
		end 
	end
end

function GetIslandPosition(n) -- Calculates with the island number the positions of the island. Returns x and z
	if (n <= 0) then -- spawn platform
		return 0, 0
	end

	local distance = ISLAND_DISTANCE	
	local posX = 0
	local posZ = 0
	local r = math.floor(0.5 + math.sqrt(n / 2.0 - 0.25))
	local nAufRing = n - 2 * r * (r - 1)
	local seite = math.ceil(nAufRing / r)
	local posSeite = nAufRing - (seite - 1) * r - 1
	
	if (seite == 1) then
		posX = (posSeite - r) * distance
		posZ = -posSeite * distance
	elseif (seite == 2) then
		posX = posSeite * distance
		posZ = (posSeite - r) * distance
	elseif (seite == 3) then
		posX = (r - posSeite) * distance
		posZ = posSeite * distance
	elseif (seite == 4) then
		posX = -posSeite * distance
		posZ = (r - posSeite) * distance
	else
		posX = 0
		posZ = 0
	end
		
	-- print("r = " .. r)
	-- print("nAufRing = " .. nAufRing)
	-- print("seite = " .. seite)
	-- print("posSeite = " .. posSeite)
	return posX, posZ
end

function GetIslandNumber(posX, posZ) -- Calculates with the positions x and z a island number. Returns the island number
	local px = posX
	local pz = posZ
    local distance = ISLAND_DISTANCE
     
    -- spawn platform
	if (px >= -(distance / 2.0) and px <= (distance / 2.0)) then
		if (pz >= -(distance / 2.0) and pz <= (distance / 2.0)) then
			return 0
		end
    end

	local xd = math.floor(round(px / (distance)))
	local zd = math.floor(round(pz / (distance)))
	local ring = math.abs(xd) + math.abs(zd)

	local seite = 0
	local posSeite = 0
	if (xd < 0 and zd <= 0) then
		seite = 1
		posSeite = -zd
    elseif (xd >= 0 and zd < 0) then
		seite = 2
		posSeite = xd
	elseif (xd > 0 and zd >= 0) then
		seite = 3
		posSeite = zd
	else
		seite = 4
		posSeite = -xd
	end
	local nAufRing = posSeite + 1 + (seite - 1) * ring
	local n = nAufRing + 2 * ring * (ring - 1)
    return n
end
