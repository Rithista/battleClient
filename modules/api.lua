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
    loaded = false,
    paused = false
}

function loadScript(url)
    if url == "" then url = "example.lua" end
    local s = love.filesystem.read( url )
    s = [[
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
    ]]..s
    script.code = love.thread.newThread( s )
    script.loaded = true
    print("Loaded "..tostring(script.code))
end

function updateScript(dt)
    if script.loaded and not script.paused then
        script.time = script.time - 1*dt

        if script.time < 0 then
            script.code:start( )
            
            script.time = 2
            updateWorld()
        end
        
    end
end