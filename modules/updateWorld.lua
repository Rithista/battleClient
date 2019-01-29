updateCode = [[
    http = require("socket.http")
    json = require("libraries.json")
    world = {}

    b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=world")

    world_decoded = json:decode(b)
    for i, v in pairs(world_decoded) do
        world[i] = v
    end

    love.thread.getChannel( 'world' ):push( world )
]]