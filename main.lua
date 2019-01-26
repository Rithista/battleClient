http = require("socket.http")
json = require("libraries.json")
local world = require("world")

require "libraries.tools"
require "settings"
require "libraries.ui"

phase = "world"


function love.load()
    world.load()

    font = love.graphics.newFont(16)
    tFont = love.graphics.newFont(11)
end

function love.draw()
    if phase == "world" then
        world.draw()
    end

    drawUIElements()
end


function love.update(dt)
    if phase == "world" then
        world.update(dt)
    end

    updateUIElements(dt)
end

function love.keypressed(key)
end

function love.mousepressed(x, y, button, istouch)
    if phase == "world" then
        world.press(x, y, button)
    end
end



