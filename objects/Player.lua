-- player.lua

local Player = {}

function Player.new(name, initialGold, initialMaterials, initialFood)
  local player = {
    name = name,
    currencies = {
      gold = initialGold or 0,
      materials = initialMaterials or 0,
      food = initialFood or 0
    },
    farmLevel = 1,
    cityLevel = 1,
    crops = {},
    buildings = {}
  }

  setmetatable(player, { __index = Player })

  return player
end

function Player:addCurrency(currency, amount)
  self.currencies[currency] = self.currencies[currency] + amount
end

function Player:subtractCurrency(currency, amount)
  if self.currencies[currency] >= amount then
    self.currencies[currency] = self.currencies[currency] - amount
    return true
  else
    return false
  end
end

function Player:getCurrency(currency)
  return self.currencies[currency]
end

function Player:upgradeFarm()
  self.farmLevel = self.farmLevel + 1
  -- Implement upgrade logic for the farm
end

function Player:upgradeCity()
  self.cityLevel = self.cityLevel + 1
  -- Implement upgrade logic for the city
end

function Player:addCrop(crop)
  table.insert(self.crops, crop)
  -- Implement logic for adding a crop to the player's inventory
end

function Player:addBuilding(building)
  table.insert(self.buildings, building)
  -- Implement logic for adding a building to the player's inventory
end

return Player
