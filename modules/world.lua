require "modules.updateWorld"
update = love.thread.newThread(updateCode)

world = {}

cID = 1 -- the ID of the tile that the cursor is currently over
selectedTile = 1 -- the ID of the tile that is currently selected

cam = {x = 0, y = 0}

worldPosition = {}

movingUnits = false
moveTile = 0
unitMove = {}

function updateWorld(refreshCanvas)
   update:start()

   refereshCanvas = true
end

function updateWorldCanvas()
    if world and world[1] then
            
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

                love.math.setRandomSeed(i) -- for position units on tiles

                if tonumber(world[i].units) and tonumber(world[i].units) > 0 then
                    if player.username == world[i].username then
                        love.graphics.setColor(0,0,1)
                    else
                        love.graphics.setColor(1,0,0)
                    end
                    
                    for i = 1, tonumber(world[i].units) do
                        local ux = love.math.random(0,32)
                        local uy = love.math.random(0,32)
                      --  love.graphics.rectangle("fill",x+ux,y+uy,1,1)
                    end
                end
                love.graphics.setColor(1,1,1)
            --  love.graphics.print(i, x, y)
                worldPosition[i] = {
                    x = x,
                    y = y
                }
                x = x + 32
                if x >= 100*32 then
                    x = 0
                    y = y + 32
                end
            end
        love.graphics.setCanvas()
    end
end

function world.load()
    worldCanvas = love.graphics.newCanvas(100*32, 100*32)
    updateWorld(true)
end

function world.draw()
    if world and world[1] then
        love.graphics.draw(worldCanvas,-cam.x,-cam.y)

        if movingUnits == true then -- unit movement
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(worldImg[world[moveTile].buildingType],worldPosition[moveTile].x-cam.x, worldPosition[moveTile].y-cam.y)

            for i = 1, #unitMove do
                love.graphics.setColor(0,0,1)
                love.graphics.rectangle("fill",unitMove[i].x-cam.x,unitMove[i].y-cam.y,1,1)
            end
        end
        
        local x = 0
        local y = 0
        for i = 1, 100*100 do
            if isMouseOver(x-cam.x, y-cam.y, 32, 32) then
                cID = i -- set tile that mouse is over
                love.graphics.setColor(0,0,0,0.8)
                love.graphics.rectangle("line", x-cam.x, y-cam.y, 32, 32)
                if buildingCount == 0 and player.authcode then -- draw castle placement for first time users
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
    
            -- draw movement buttons
            if player.authcode and world[selectedTile].username == player.username and i == selectedTile then
                if world[selectedTile-1].username ~= player.username then
                    love.graphics.setColor(0.8,0,0,0.3)
                else
                    love.graphics.setColor(0,0,0.8,0.3)
                end
                love.graphics.rectangle("fill",x-32-cam.x,y-cam.y,32,32)
                if world[selectedTile+1].username ~= player.username then
                    love.graphics.setColor(0.8,0,0,0.3)
                else
                    love.graphics.setColor(0,0,0.8,0.3)
                end
                love.graphics.rectangle("fill",x+32-cam.x,y-cam.y,32,32)
                if world[selectedTile+100].username ~= player.username then
                    love.graphics.setColor(0.8,0,0,0.3)
                else
                    love.graphics.setColor(0,0,0.8,0.3)
                end
                love.graphics.rectangle("fill",x-cam.x,y+32-cam.y,32,32)
                if world[selectedTile-100].username ~= player.username then
                    love.graphics.setColor(0.8,0,0,0.3)
                else
                    love.graphics.setColor(0,0,0.8,0.3)
                end
                love.graphics.rectangle("fill",x-cam.x,y-32-cam.y,32,32)
            end

            -- draw peaking
        -- if love.keyboard.isDown(KEY_PEAK) then
                if distanceFrom(cx,cy,x-cam.x,y-cam.y) < 200 and world[i].username ~= "Mother Nature" then
                    local alpha = 1-distanceFrom(cx-16,cy-16,x-cam.x,y-cam.y)/300
                    love.graphics.setColor(0,0,0,alpha)
                    if love.keyboard.isDown(KEY_PEAK) then  love.graphics.rectangle("fill",x-cam.x,y-cam.y,32,tFont:getHeight()) end
                    if player.username == world[i].username then
                        love.graphics.setColor(0,0,1,alpha)
                    else
                        love.graphics.setColor(1,0,0,alpha)
                    end

                    love.graphics.print(world[i].units, x-cam.x, y-cam.y)

                    love.math.setRandomSeed(i) -- for position units on tiles

                    if tonumber(world[i].units) and tonumber(world[i].units) > 0 then
                        if player.username == world[i].username then
                            love.graphics.setColor(0,0,1,alpha)
                        else
                            love.graphics.setColor(1,0,0,alpha)
                        end
                        
                        for i = 1, tonumber(world[i].units) do
                            local ux = love.math.random(0,32)
                            local uy = love.math.random(0,32)
                            love.graphics.rectangle("fill",x+ux-cam.x,y+uy-cam.y,1,1)
                        end
                    end
                end
        --  end

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

      

        drawFight(0,love.graphics.getHeight()/2-100)

        love.graphics.print("ID : "..tostring(cID).."\nTYPE : "..tostring(world[cID].buildingType))
    end
end

function world.update(dt)
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
            player = api.get("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=data&authcode="..player.authcode)
            time.updateUser = 30

            buildable = api.get("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=buildable&authcode="..player.authcode)
        end

        if time.updateWorld < 0 then
            updateWorld()
            time.updateWorld = 60
        end
    end

    if love.keyboard.isDown(KEY_CAM_SPEED) then
        if world[cID].buildingType == "Building" then
            local construct = atComma(world[cID].special)
            setTT("Tile Information",world[cID].buildingType.." a "..construct[2].." ("..construct[1].." minutes remaining), owned by "..world[cID].username..".")
        else
            setTT("Tile Information",world[cID].buildingType..", owned by "..world[cID].username..".")
        end
    end

    updateFight(dt)
    if love.thread.getChannel( 'world' ):getCount() and love.thread.getChannel( 'world' ):getCount() > 0 then
        world = love.thread.getChannel( 'world' ):pop()
        updateWorldCanvas()
    end

    -- moving units
    movingUnits = false -- any unit not in their correct position will set this to true
    for i = 1, #unitMove do
        local speed = 28*dt
        if unitMove[i].x < unitMove[i].targetX then unitMove[i].x = unitMove[i].x + speed
        elseif unitMove[i].x > unitMove[i].targetX then unitMove[i].x = unitMove[i].x - speed end
        if unitMove[i].y < unitMove[i].targetY then unitMove[i].y = unitMove[i].y + speed
        elseif unitMove[i].y > unitMove[i].targetY then unitMove[i].y = unitMove[i].y - speed end
        if distanceFrom(unitMove[i].x,unitMove[i].y,unitMove[i].targetX,unitMove[i].targetY) > 3 then -- check whether all units are now in their position
            movingUnits = true 
        end
    end
end

function world.press(x, y, button) -- handles mouse presses when in world phase
   -- updateWorld()
--  setTT("Tile Information",world[cID].buildingType..", owned by "..world[cID].username..".")
    if buildingCount == 0 and player.authcode then --TODO: THESE CANNOT BE FIXED YET AS THE API DOESN'T RETURN JSON FOR ALL RESULTS PROPERLY
        api.get("http://freshplay.co.uk/b/api.php?a=build&position="..cID.."&type=Castle&authcode="..player.authcode)
        buildingCount = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=buildingSum&authcode="..player.authcode)
        buildingCount = tonumber(buildingCount)
        updateWorld()
    elseif player.authcode and (cID + 100 == selectedTile or cID - 100 == selectedTile or cID + 1 == selectedTile or cID - 1 == selectedTile) and world[selectedTile].username == player.username then
        b = http.request("http://freshplay.co.uk/b/api.php?a=move&position="..selectedTile.."&newPosition="..cID.."&number="..(world[selectedTile].units-1).."&authcode="..player.authcode)
       -- print("http://freshplay.co.uk/b/api.php?a=move&position="..selectedTile.."&newPosition="..cID.."&authcode="..player.authcode)
        b = string.gsub(b, "%s+", "")
        a = atComma(b)
        if a[2] then newFight(tonumber(a[1]),tonumber(a[2]),tonumber(a[3]),tonumber(a[4])) -- start fight animation
        else
            world[cID].username = player.username -- set local tile info to match what server should return
            moveUnits(selectedTile,cID,world[selectedTile].units-1) -- begin unit movement
            world[cID].units = world[cID].units + world[selectedTile].units-1
            world[selectedTile].units = world[selectedTile].units - world[selectedTile].units + 1
            selectedTile = cID -- select the destination tile to make movement easier
            updateWorldCanvas()
        end
        updateWorld()
        selectedTile = cID
    end

    if button == 2 then
        selectedTile = cID
    end
end

function moveUnits(currentTile, newTile, amount)
    unitMove = {}
    moveTile = newTile
    movingUnits = true
    love.math.setRandomSeed(newTile) -- position on tiles is determined by using the id of the tile as a random seed
    for i = 1, amount do
        unitMove[#unitMove + 1] = {
            targetX = worldPosition[newTile].x+love.math.random(0,32),
            targetY = worldPosition[newTile].y+love.math.random(0,32)
        }
    end


    love.math.setRandomSeed(currentTile)
    for i = 1, #unitMove do -- we need to use the randomseed of the last tile to find their original position
        unitMove[i].x = worldPosition[currentTile].x+love.math.random(0,32)
        unitMove[i].y = worldPosition[currentTile].y+love.math.random(0,32)
    end
end

return world