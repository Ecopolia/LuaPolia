-- HexGrid object
local HexGrid = {}

function HexGrid.new(hexRadius)
  local grid = {
    hexRadius = hexRadius,
    xOffset = hexRadius * math.sqrt(3),
    yOffset = hexRadius * 1.5,
    rows = 0,
    columns = 0
  }
  setmetatable(grid, { __index = HexGrid })
  return grid
end

function HexGrid:setSize(rows, columns)
  self.rows = rows
  self.columns = columns
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

      love.graphics.polygon('line', vertices)
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
