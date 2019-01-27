http = require("socket.http")
json = require("libraries.json")
utf8 = require("utf8")
local world = require("modules.world")

bFont = love.graphics.newFont(16)
tFont = love.graphics.newFont(11)

require "libraries.tools"
require "settings"
require "libraries.ui"
require "modules.player"

phase = "world"


function love.load()
    world.load()
end

function love.draw()
    if phase == "world" then
        world.draw()

        if player.authcode then -- player is logged in
            drawPlayerStats()
        end
    end

    drawLoginBox()
    drawUIElements()
end


function love.update(dt)
    if phase == "world" then
        world.update(dt)
    end

    updateUIElements(dt)
end

function love.mousepressed(x, y, button, istouch)
    if phase == "world" then
        world.press(x, y, button)
    end

    uiPress(x,y)
end