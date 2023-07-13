local HexGrid = {}

function HexGrid.new(hexRadius)
  local grid = {
    hexRadius = hexRadius,
    xOffset = hexRadius * math.sqrt(3),
    yOffset = hexRadius * 1.5,
    rows = 0,
    columns = 0,
    mouseX = 0,
    mouseY = 0,
    selectedRow = 0,
    selectedCol = 0
  }
  setmetatable(grid, { __index = HexGrid })
  return grid
end

function HexGrid:setSize(rows, columns)
  self.rows = rows
  self.columns = columns
end

function HexGrid:updateMousePosition(x, y)
  self.mouseX = x
  self.mouseY = y
  self:selectedHexagon()
end

function HexGrid:selectedHexagon()
  self.selectedRow = 0
  self.selectedCol = 0

  -- Calculate the row and column of the selected hexagon based on the mouse position
  local row = math.floor((self.mouseY - self.yOffset / 2) / self.yOffset)
  local col

  if row % 2 == 0 then
    col = math.floor((self.mouseX - self.xOffset / 2) / self.xOffset)
  else
    col = math.floor(self.mouseX / self.xOffset)
  end

  if col >= 0 and col < self.columns and row >= 0 and row < self.rows then
    self.selectedRow = row + 1
    self.selectedCol = col + 1
  end
end

function HexGrid:draw()
  for row = 1, self.rows do
    for col = 1, self.columns do
      local x = col * self.xOffset
      if row % 2 == 0 then
        x = x + self.xOffset / 2
      end
      local y = row * self.yOffset

      local vertices = self:calculateVertices(x, y)

      if row == self.selectedRow and col == self.selectedCol then
        love.graphics.setColor(1, 1, 1)  -- Set color to white for the selected hexagon
        love.graphics.polygon('fill', vertices)
      else
        love.graphics.setColor(1, 1, 1)
        love.graphics.polygon('line', vertices)
      end
    end
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

return HexGrid