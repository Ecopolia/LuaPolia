-- HexGrid object
local HexGrid = {}

function HexGrid.new(hexRadius)
  local grid = {
    hexRadius = hexRadius,
    xOffset = hexRadius * math.sqrt(3),
    yOffset = hexRadius * 1.5,
    xSpacing = 10,
    ySpacing = 10,
    rows = 0,
    columns = 0,
    mouseX = 0,
    mouseY = 0,
    selectedRow = 0,
    selectedCol = 0,
    camera = {
      x = 0,
      y = 0
    },
    keysPressed = {}
  }
  setmetatable(grid, { __index = HexGrid })
  return grid
end

function HexGrid:setSize(rows, columns)
  self.rows = rows
  self.columns = columns
end

/**
* Set the spacing between hexagons
* @param {number} xSpacing - The spacing between hexagons in the x direction
* @param {number} ySpacing - The spacing between hexagons in the y direction
*/
function HexGrid:setSpacing(xSpacing, ySpacing)
  self.xSpacing = xSpacing
  self.ySpacing = ySpacing
end

function HexGrid:updateMousePosition(x, y)
  self.mouseX = x
  self.mouseY = y
  self:selectedHexagon()
end

function HexGrid:selectedHexagon()
  self.selectedRow = 0
  self.selectedCol = 0

  -- Calculate the center position of the grid
  local gridWidth = self.columns * (self.xOffset + self.xSpacing)
  local gridHeight = self.rows * (self.yOffset + self.ySpacing)
  local centerX = love.graphics.getWidth() / 2 - gridWidth / 2
  local centerY = love.graphics.getHeight() / 2 - gridHeight / 2

  -- Adjust mouse coordinates based on camera position
  local mouseXAdjusted = self.mouseX + self.camera.x - centerX
  local mouseYAdjusted = self.mouseY + self.camera.y - centerY

  -- Calculate the row and column of the selected hexagon based on the adjusted mouse position
  local row = math.floor((mouseYAdjusted - (self.yOffset + self.xSpacing) / 2) / (self.yOffset + self.ySpacing))
  local col

  if row % 2 == 0 then
    col = math.floor((mouseXAdjusted - (self.xOffset + self.xSpacing) / 2 - (self.xOffset + self.xSpacing) / 4) / (self.xOffset + self.xSpacing))
  else
    col = math.floor(mouseXAdjusted / (self.xOffset + self.xSpacing)) - 1
  end

  if col >= 0 and col < self.columns and row >= 0 and row < self.rows then
    self.selectedRow = row + 1
    self.selectedCol = col + 1
  end
end


function HexGrid:calculateVertices(x, y)
  local vertices = {}
  for i = 1, 6 do
    local angle = (2 * math.pi / 6) * (i - 1) + math.pi / 6
    local vertexX = x + self.hexRadius * math.cos(angle)
    local vertexY = y + self.hexRadius * math.sin(angle)
    table.insert(vertices, vertexX)
    table.insert(vertices, vertexY)
  end
  return vertices
end

function HexGrid:draw()
  -- Calculate the center position of the grid
  local gridWidth = self.columns * self.xOffset
  local gridHeight = self.rows * self.yOffset
  local centerX = love.graphics.getWidth() / 2 - gridWidth / 2
  local centerY = love.graphics.getHeight() / 2 - gridHeight / 2

  local hexagonSpacingX = self.xSpacing  -- Adjust the spacing between hexagons in the x direction
  local hexagonSpacingY = self.ySpacing  -- Adjust the spacing between hexagons in the y direction

  for row = 1, self.rows do
    for col = 1, self.columns do
      local x = centerX + col * (self.xOffset + hexagonSpacingX) - self.camera.x
      if row % 2 == 0 then
        x = x + (self.xOffset + hexagonSpacingX) / 2
      end
      local y = centerY + row * (self.yOffset + hexagonSpacingY) - self.camera.y

      local vertices = self:calculateVertices(x, y)

      if row == self.selectedRow and col == self.selectedCol then
        love.graphics.setColor(1, 1, 1)  -- Set color to white for the selected hexagon
        love.graphics.polygon('fill', vertices)
      else
        love.graphics.setColor(1, 1, 1)  -- Set color to black for other hexagons
        love.graphics.polygon('line', vertices)
      end
    end
  end
end


-- Camera methods
function HexGrid:moveCamera(dx, dy)
  local gridWidth = self.columns * self.xOffset
  local gridHeight = self.rows * self.yOffset
  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()

  -- Calculate the maximum allowed camera movement based on the grid and screen sizes
  local left = -(gridWidth - screenWidth) / 2
  local top = -(gridHeight - screenHeight) / 2
  
  local right = -left + (2 * self.hexRadius)
  local bot = -top + (2 * self.hexRadius)

  -- Limit camera movement within the grid bounds
  self.camera.x = math.max(left, math.min(right, self.camera.x + dx))
  self.camera.y = math.max(top, math.min(bot, self.camera.y + dy))
end


function HexGrid:updateCameraMovement(dt)
  local moveSpeed = 300 -- Adjust the move speed as needed

  if (self.keysPressed["up"] or self.keysPressed["w"]) then
    self:moveCamera(0, -moveSpeed * dt)
  end
  if (self.keysPressed["down"] or self.keysPressed["s"]) then
    self:moveCamera(0, moveSpeed * dt)
  end
  if (self.keysPressed["left"] or self.keysPressed["a"]) then
    self:moveCamera(-moveSpeed * dt, 0)
  end
  if (self.keysPressed["right"] or self.keysPressed["d"]) then
    self:moveCamera(moveSpeed * dt, 0)
  end

  self:selectedHexagon()
end

return HexGrid