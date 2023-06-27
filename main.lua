function love.load()
  love.window.setTitle("Hello World")
end

function love.update(dt)
  require("libs/lurker").update()
  require("libs/lovebird").update()
end

function love.draw()

end
