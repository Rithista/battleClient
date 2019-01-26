world = {}

worldImg = {}
worldImg["Grass"] = love.graphics.newImage("assets/Grass.png")
worldImg["Forest"] = love.graphics.newImage("assets/Forest.png")
worldImg["Mine"] = love.graphics.newImage("assets/Mine.png")

cID = 0 -- the ID of the tile that the cursor is currently over

cam = {x = 0, y = 0}

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
        if worldImg[world[i].buildingType] then
            love.graphics.draw(worldImg[world[i].buildingType], x-cam.x, y-cam.y)
        else
            love.graphics.rectangle("fill",x-cam.x,y-cam.y,32,32)
        end

        if isMouseOver(x-cam.x, y-cam.y, 32, 32) then
            cID = i -- set tile that mouse is over
        end

        x = x + 32
        if x >= 100*32 then
            x = 0
            y = y + 32
        end
    end

    love.graphics.print("ID : "..tostring(cID).."\nTYPE : "..tostring(world[cid].buildingType))
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

return world