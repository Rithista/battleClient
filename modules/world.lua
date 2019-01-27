world = {}

worldImg = {}
worldImg["Grass"] = love.graphics.newImage("assets/Grass.png")
worldImg["Forest"] = love.graphics.newImage("assets/Forest.png")
worldImg["Mine"] = love.graphics.newImage("assets/Mine.png")
worldImg["Castle"] = love.graphics.newImage("assets/Castle.png")

cID = 1 -- the ID of the tile that the cursor is currently over
selectedTile = 1 -- the ID of the tile that is currently selected

cam = {x = 0, y = 0}

function updateWorld()
    world = {}

    b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=world")

    world_decoded = json:decode(b)
    for i, v in pairs(world_decoded) do
        world[i] = v
    end

    love.graphics.setCanvas(worldCanvas)
        love.graphics.clear()
        love.graphics.setBlendMode("alpha")
        local x = 0
        local y = 0
        for i = 1, 100*100 do
            if worldImg[world[i].buildingType] then
                love.graphics.draw(worldImg[world[i].buildingType], x, y)
            else
                love.graphics.rectangle("fill",x,y,32,32)
            end

            if world[i].units and world[i].units > 0 then

            end
    
            x = x + 32
            if x >= 100*32 then
                x = 0
                y = y + 32
            end
        end
    love.graphics.setCanvas()
end

function world.load()
    worldCanvas = love.graphics.newCanvas(100*32, 100*32)
    updateWorld()
end

function world.draw()
    love.graphics.draw(worldCanvas,-cam.x,-cam.y)

    local x = 0
    local y = 0
    for i = 1, 100*100 do
        if isMouseOver(x-cam.x, y-cam.y, 32, 32) then
            cID = i -- set tile that mouse is over
            love.graphics.setColor(0,0,0,0.8)
            love.graphics.rectangle("line", x-cam.x, y-cam.y, 32, 32)
            if not buildingCount and player.authcode then
                if world[cID].buildingType == "Grass" and not tonumber(world[cID].units) then
                    love.graphics.setColor(1,1,1,0.5)
                else
                    love.graphics.setColor(1,0,0,0.5)
                end
                love.graphics.draw(worldImg["Castle"], x-cam.x, y-cam.y)
            end
        end

        if i == selectedTile then
            love.graphics.setColor(0,0,0,0.5)
            love.graphics.rectangle("fill", x-cam.x, y-cam.y, 32, 32)
        end

        love.graphics.setColor(1,1,1,1)

        x = x + 32
        if x >= 100*32 then
            x = 0
            y = y + 32
        end
    end

    love.graphics.print("ID : "..tostring(cID).."\nTYPE : "..tostring(world[cID].buildingType))
end

function world.update(dt)
    cx, cy = love.mouse.getPosition()

    local camSpeed = 64*dt
    if love.keyboard.isDown(KEY_CAM_SPEED) then camSpeed = 256*dt end
    
    if love.keyboard.isDown(KEY_CAM_LEFT) then
        cam.x = cam.x - camSpeed
    elseif love.keyboard.isDown(KEY_CAM_RIGHT) then
        cam.x = cam.x + camSpeed
    end

    if love.keyboard.isDown(KEY_CAM_UP) then
        cam.y = cam.y - camSpeed
    elseif love.keyboard.isDown(KEY_CAM_DOWN) then
        cam.y = cam.y + camSpeed
    end
end

function world.press(x, y, button) -- handles mouse presses when in world phase
   -- updateWorld()
   -- setTT("Tile Information",world[cID].buildingType..", owned by "..world[cID].username..".")
    selectedTile = cID
end

return world