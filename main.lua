i18n = require 'libs/i18n'
Player = require 'objects/Player'
ripple = require 'libs/ripple'
lick = require "libs/lick"

local HexGrid = require 'systems/grid'
  local grid = HexGrid.new(30)
  grid:setSize(10, 10)

function love.load()
  love.window.setTitle("Hello World")
  
  i18n.loadFile('i18n/fr.lua')
  i18n.loadFile('i18n/en.lua')

  i18n.setLocale('fr')
  player = Player.new('John Doe', 100, 100, 100)
  local source = love.audio.newSource('assets/sounds/main_grassland.mp3', 'static')
  local sound = ripple.newSound(source, {
    loop = true,
  })
  -- sound:play()
  print("load")
  -- Usage example
  

end


function love.update(dt)
  require("libs/lurker").update()
  require("libs/lovebird").update()


end

function love.draw()
  -- Display the player's name top left  corner
  love.graphics.print(player.name, 10, 10)
  -- Display the player's holdings top right corner
  love.graphics.print(i18n('gold')..': '..player.currencies.gold, 700, 10)
  love.graphics.print(i18n('materials')..': '..player.currencies.materials, 700, 30)
  love.graphics.print(i18n('food')..': '..player.currencies.food, 700, 50)
  grid:draw()
end

function love.mousemoved(x, y)
  grid:updateMousePosition(x, y)
end