i18n = require 'i18n'

function love.load()
  love.window.setTitle("Hello World")
  
  i18n.loadFile('i18n/fr.lua')
  i18n.loadFile('i18n/en.lua')

  i18n.setLocale('fr')
  
end


function love.update(dt)
  require("libs/lurker").update()
  require("libs/lovebird").update()
end

function love.draw()
  
end
