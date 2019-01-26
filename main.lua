http = require("socket.http")
json = require("json")
local world = require("world")

phase = "world"


function love.load()
    world.load()
end

function love.update(dt)
end

function love.draw()
    if phase == "world" then
        world.draw()
    end
end

function love.keypressed(key)
end

function love.mousepressed(x, y, button, istouch)
    mouseX = x
    mouseY = y
end



