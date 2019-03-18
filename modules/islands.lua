--[[
    This file handles the Island selection menu.
]]

islands = {
    {id = 1, address = "http://freshplay.co.uk/b/api.php", players = 6, maxPlayers = 10, age = 3, scriptEnabled = true, scriptOnly = false, owner = "Fresh Play LTD", title = "Official#1", x = love.math.random(1,400), y = love.math.random(1, 400)}
} -- TODO: make this pull from the API

function loadIslands()
    islandImg = love.graphics.newImage("assets/Island.png")
end

function drawIslands()
    for i, v in pairs(islands) do
        
        love.graphics.draw(islandImg, v.x, v.y)
        if isMouseOver(v.x, v.y, 128, 128) then
            love.graphics.setColor(0,0,0,0.5)
            love.graphics.rectangle("fill",v.x,v.y,128,128)
            love.graphics.setColor(1,1,1,1)
            love.graphics.setFont(tFont)
            love.graphics.printf(v.title, v.x, v.y, 128, "center")
            love.graphics.setFont(font)
            love.graphics.printf("Owned by "..v.owner.."\n"..v.players.."/"..v.maxPlayers.."p\n"..v.age.." days old\nScript enabled: "..tostring(v.scriptEnabled).."\nScript only: "..tostring(v.scriptOnly),v.x,v.y+bFont:getHeight(),128,"center")

            if love.mouse.isDown(1) then
                api.url = v.address
                world.load()
                phase = "world"
            end
        end
    end
end