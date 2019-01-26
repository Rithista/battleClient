http = require("socket.http")
json = require("libraries.json")
local world = require("world")

require "libraries.tools"
require "settings"

phase = "world"


function love.load()
    world.load()
end

function love.update(dt)
    if phase == "world" then
        world.update(dt)
    end
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



