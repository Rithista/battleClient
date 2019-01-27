world = {}

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

    if player.authcode then
        buildingCount = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=buildingSum&authcode="..player.authcode)
        buildingCount = tonumber(buildingCount)
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

            if tonumber(world[i].units) and tonumber(world[i].units) > 0 then
                if player.username == world[i].username then
                    love.graphics.setColor(1,0.84,0.26)
                else
                    love.graphics.setColor(1,0,0)
                end

                love.graphics.print(world[i].units, x, y)
            end
            love.graphics.setColor(1,1,1)
    
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
            if buildingCount == 0 and player.authcode then
                if world[cID].buildingType == "Grass" and tonumber(world[cID].units) == 0 then
                    love.graphics.setColor(1,1,1,0.5)
                else
                    love.graphics.setColor(1,0,0,0.5)
                end
                love.graphics.draw(worldImg["Castle"], x-cam.x, y-cam.y)
            end
        end

        if i == selectedTile then
            love.graphics.setColor(0,0,0,0.2)
            love.graphics.rectangle("fill", x-cam.x, y-cam.y, 32, 32)
        end
 
        if player.authcode and world[selectedTile].username == player.username and i == selectedTile then
            love.graphics.setColor(0,0,0.8,0.3)
            love.graphics.rectangle("fill",x-32-cam.x,y-cam.y,32,32)
            love.graphics.rectangle("fill",x+32-cam.x,y-cam.y,32,32)
            love.graphics.rectangle("fill",x-cam.x,y+32-cam.y,32,32)
            love.graphics.rectangle("fill",x-cam.x,y-32-cam.y,32,32)
        end

        love.graphics.setColor(1,1,1,1)

        x = x + 32
        if x >= 100*32 then
            x = 0
            y = y + 32
        end
    end

    if player.authcode and buildable and world[selectedTile].username == player.username and world[selectedTile].buildingType == "Grass" then
        love.graphics.setColor(1,1,1,1)
        drawBuildingBox(400,600)
    end

    drawFight(love.graphics.getWidth()/2-100,love.graphics.getHeight()/2-100)

    love.graphics.print("ID : "..tostring(cID).."\nTYPE : "..tostring(world[cID].buildingType))
end

function world.update(dt)
    cx, cy = love.mouse.getPosition()

    local camSpeed = 64*dt
    if love.keyboard.isDown(KEY_CAM_SPEED) then camSpeed = 256*dt end
    
    if love.keyboard.isDown(KEY_CAM_LEFT) and cam.x > 1   then
        cam.x = cam.x - camSpeed
    elseif love.keyboard.isDown(KEY_CAM_RIGHT) and cam.x+love.graphics.getWidth() < 100*32 then
        cam.x = cam.x + camSpeed
    end

    if love.keyboard.isDown(KEY_CAM_UP) and cam.y > 1 then
        cam.y = cam.y - camSpeed
    elseif love.keyboard.isDown(KEY_CAM_DOWN) and cam.y+love.graphics.getHeight() < 100*32 then
        cam.y = cam.y + camSpeed
    end

    if player.authcode then
        for i, v in pairs(time) do
            time[i] = time[i] - 1*dt
        end

        if time.updateUser < 0 then
            b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=data&authcode="..player.authcode)
            player = json:decode(b)
            time.updateUser = 30

            b = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=buildable&authcode="..player.authcode)
            buildable = json:decode(b)
        end

        if time.updateWorld < 0 then
            updateWorld()
            time.updateWorld = 60
        end
    end

    updateFight(dt)
end

function world.press(x, y, button) -- handles mouse presses when in world phase
   -- updateWorld()
--  setTT("Tile Information",world[cID].buildingType..", owned by "..world[cID].username..".")
    if buildingCount == 0 and player.authcode then
        http.request("http://freshplay.co.uk/b/api.php?a=build&position="..cID.."&type=Castle&authcode="..player.authcode)
        updateWorld()
    elseif player.authcode and (cID + 100 == selectedTile or cID - 100 == selectedTile or cID + 1 == selectedTile or cID - 1 == selectedTile) and world[selectedTile].username == player.username then
        b = http.request("http://freshplay.co.uk/b/api.php?a=move&position="..selectedTile.."&newPosition="..cID.."&number="..(world[selectedTile].units-1).."&authcode="..player.authcode)
       -- print("http://freshplay.co.uk/b/api.php?a=move&position="..selectedTile.."&newPosition="..cID.."&authcode="..player.authcode)
        b = string.gsub(b, "%s+", "")
        a = atComma(b)
        if a[2] then newFight(a[1],a[2]) end
        print(b)
        updateWorld()
        selectedTile = cID
    end

    if button == 2 then
        selectedTile = cID
    end
end

return world