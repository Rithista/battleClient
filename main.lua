http = require("socket.http")
json = require("libraries.json")
utf8 = require("utf8")
local world = require("modules.world")
require "modules.assets"

require "libraries.tools"
require "settings"
require "libraries.ui"
require "modules.player"
require "modules.fight"
require "modules.api"
require "modules.islands"

phase = "islands" -- login*, islands, world 

time = {
    updateUser = 5,
    updateWorld = 10
}

function love.load()
    -- world.load()
    love.filesystem.setIdentity("battle-client")
    font = love.graphics.newFont(12)
    tFont = love.graphics.newFont(14)
    loadIslands()

    love.graphics.setBackgroundColor(0,0,0.5)
end

function love.draw()
    if phase == "islands" then
        drawIslands()
    elseif phase == "world" then
        world.draw()

        if authcode then -- player is logged in
            drawPlayerStats()
        end


        if script.loaded == true then drawScriptControls()
        elseif not authcode then drawLoginBox() end
    end

    drawUIElements()
    
end


function love.update(dt)
    if phase == "world" then
        world.update(dt)
        updateScript(dt)
    end

    updateUIElements(dt)
    cx, cy = love.mouse.getPosition()
end

function love.mousepressed(x, y, button, istouch)
    if phase == "world" then
        world.press(x, y, button)
    end

    uiPress(x,y)
end