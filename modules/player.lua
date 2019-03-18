player = {}

function login(username,password)
    b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=login&username="..username.."&password="..password)
    b = string.gsub(b, "%s+", "")
    if tonumber(b) then
        player.authcode = b
        
        player = api.get("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=data&authcode="..player.authcode)
    
        buildingCount = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=buildingSum&authcode="..player.authcode)
        buildingCount = tonumber(buildingCount)
    else
        love.window.showMessageBox("Unable to login","Username or password is incorrect.")
        player = {}
    end
end

function register(username,password)
    b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=register&username="..username.."&password="..password)
    b = string.gsub(b, "%s+", "")
    if tonumber(b) then
        player.authcode = b
        player = api.get("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=data&authcode="..player.authcode)

        buildingCount = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=buildingSum&authcode="..player.authcode)
        buildingCount = tonumber(buildingCount)
    else
        love.window.showMessageBox("Unable to register","An account with this username already exists!")
        player = {}
    end
end

function drawLoginBox()
    if not usernameBox then
        usernameBox = addTextBox(0,30,200,tFont,"username")
        passwordBox = addTextBox(0,32+tFont:getHeight(),200,tFont,"password")
        scriptBox = addTextBox(0,54+tFont:getHeight()*4,200,tFont,"example.lua")
    end

    if not player.authcode then
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle("fill",0,0,200,140)
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(bFont)
        love.graphics.printf("Please login", 0, 0, 200, "center")
        drawTextBox(usernameBox)
        drawTextBox(passwordBox)
        drawTextBox(scriptBox)
        if drawButton("Login",10,2+32+tFont:getHeight()*2,180,bFont) then login(textbox[usernameBox].text,textbox[passwordBox].text) end
        if drawButton("Register",10,2+32+tFont:getHeight()*2 + bFont:getHeight(),180,bFont) then register(textbox[usernameBox].text,textbox[passwordBox].text) end
        if drawButton("Load Script",10,54+tFont:getHeight()*5,180,bFont) then loadScript(textbox[scriptBox].text) end
    end
end

function drawScriptControls()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill",0,0,200,140)
    love.graphics.setColor(1,1,1,1)
    
    love.graphics.setColor(0,0,1)
    love.graphics.rectangle("fill", 0, 0, (script.time/2)*200, 12)
    love.graphics.setColor(1,1,1)

    if drawButton("Play",10,32,180,bFont) then script.paused = false end
    if drawButton("Pause",10,32+bFont:getHeight(),180,bFont) then script.paused = true end
    if drawButton("Reload",10,32+bFont:getHeight()*2,180,bFont) then loadScript(textbox[scriptBox].text) end
    if drawButton("Eject",10,32+bFont:getHeight()*3,180,bFont) then script.loaded = false end
end

function drawPlayerStats()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),24)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(bFont)
    love.graphics.print("King "..player.username)

    if buildingCount == 0 then
        love.graphics.print("Choose a tile to place your castle.", bFont:getWidth("King "..player.username.."  "), 0)
    else
        love.graphics.print(player.gold.."    "..player.wood.."    "..player.stone.."    "..player.food.."    "..player.pop, bFont:getWidth("King "..player.username.."    "), 4)
        love.graphics.draw(statImg["gold"],bFont:getWidth("King "..player.username.."    "..player.gold))
        love.graphics.draw(statImg["wood"],bFont:getWidth("King "..player.username.."    "..player.gold.."    "..player.wood))
        love.graphics.draw(statImg["stone"],bFont:getWidth("King "..player.username.."    "..player.gold.."    "..player.wood.."    "..player.stone))
        love.graphics.draw(statImg["food"],bFont:getWidth("King "..player.username.."    "..player.gold.."    "..player.wood.."    "..player.stone.."    "..player.food))
        love.graphics.draw(statImg["pop"],bFont:getWidth("King "..player.username.."    "..player.gold.."    "..player.wood.."    "..player.stone.."    "..player.food.."    "..player.pop))
    end
end

function drawBuildingBox(x, y)
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill",x,y,320,320)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(bFont)
    love.graphics.printf("Building Box",x,y,320,"center")
    local cx = x
    local cy = y+bFont:getHeight()
    for i, v in pairs(buildable) do
        if v.requirement ~= "God" then
            if v.canBuild then
                love.graphics.setColor(1,1,1,1)
            else
                love.graphics.setColor(1,1,1,0.5)
            end

            if worldImg[v.buildingType] then
                love.graphics.draw(worldImg[v.buildingType], cx, cy)
            end
            if isMouseOver(cx,cy,32,32) then
                setTT(v.buildingType,"Costs "..v.goldCost.."g, "..v.woodCost.."w, "..v.stoneCost.."s. Built in "..v.timeToBuild.."m. Generates "..v.depositValue.." "..v.attribute.." every minute.")
                love.graphics.setColor(1,1,1)

                if love.mouse.isDown(1) then
                    --print("submitted build request")
                    world[selectedTile].buildingType = "Building"
                    api.get("http://freshplay.co.uk/b/api.php?a=build&position="..selectedTile.."&type="..v.buildingType.."&authcode="..player.authcode)
                    selectedTile = 1
                    time.updateWorld = 0
                    time.updateUser = 1
                end
            else
                love.graphics.setColor(0.4,0.4,0.4)
            end
            
            love.graphics.rectangle("line",cx,cy,32,32)
            love.graphics.setColor(1,1,1)

            cx = cx + 32
            if cx > x+320 then
                cx = x
                cy = cy + 32
            end
        end
    
    end
end