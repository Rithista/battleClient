world = {}

worldImg = {}
worldImg["Grass"] = love.graphics.newImage("assets/Grass.png")
worldImg["Forest"] = love.graphics.newImage("assets/Forest.png")
worldImg["Mine"] = love.graphics.newImage("assets/Mine.png")

function updateWorld()
    world = {}

    b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=world")

    world_decoded = json:decode(b)
    for i, v in pairs(world_decoded) do
        world[i] = v
    end
end

function world.load()
    updateWorld()
end

function world.draw()
    local x = 0
    local y = 0
    for i = 1, 100*100 do
        if worldImg[world[i]] then
            love.graphics.draw(worldImg[world[i]], x, y)
        else
            love.graphics.rectangle("fill",x,y,32,32)
        end

        x = x + 32
        if x >= 100*32 then
            x = 0
            y = y + 32
        end
    end

   --[[ local mCol = math.floor(love.mouse.getX() / TILE_WIDTH) + 1
    local mLine = math.floor(love.mouse.getY() / TILE_HEIGHT) + 1
    if mCol >= 1 and mCol <= MAP_WIDTH and mLine >= 1 and mLine <= MAP_HEIGHT then 
        local id = world[mCol + ((mLine - 1) * 100)]
        love.graphics.print("ID : "..tostring(id), 1, 1)
        love.graphics.print("X : "..tostring(mCol).. " Y : "..tostring(mLine), 100, 1)
    else
        love.graphics.print("Not a tile")
    end]]
end


return world