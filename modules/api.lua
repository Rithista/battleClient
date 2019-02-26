--[[
    API
    This file can handle all interactions between the game and the API.
    It was created specifically for the scripting capabilities of a research project undertaken by Thomas Lock as part of his undergraduate Computer Science study, 2018/19.
    v1.0
]]
local http = require("socket.http")
local json = require("libraries.json")

api = {
    url = "http://freshplay.co.uk/b/api.php",
    get = function (action)

        print("Calling "..api.url..action)
        b, c, h = http.request(api.url..action)
        return json:decode(b)

    end
}

script = {
    code = [[]],
    time = 1,
    loaded = false
}

function loadScript(url)
    script.code = love.filesystem.read( url )
    script.loaded = true
    print("Loaded "..tostring(script.code))
end

function updateScript(dt)
    if script.loaded then
        script.time = script.time - 1*dt

        if script.time < 0 then
            local s = assert(loadstring(script.code))
            s()
            script.time = 2
            updateWorld()
        end
    end
end

function drawScriptTimer()
    love.graphics.setColor(0,0,1)
    love.graphics.rectangle("fill", 0, 0, (script.time/5)*love.graphics.getWidth(), 12)
    love.graphics.setColor(1,1,1)
end