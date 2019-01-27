player = {}

usernameBox = addTextBox(0,30,200,tFont,"username")
passwordBox = addTextBox(0,32+tFont:getHeight(),200,tFont,"password")

function login(username,password)
    b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=login&username="..username.."&password="..password)
    b = string.gsub(b, "%s+", "")
    if tonumber(b) then
        player.authcode = b
        b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=data&authcode="..player.authcode)
        player = json:decode(b)

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
        b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=data&authcode="..player.authcode)
        print("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=data&authcode="..player.authcode)
        player = json:decode(b)

        buildingCount = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=buildingSum&authcode="..player.authcode)
        buildingCount = tonumber(buildingCount)
    else
        love.window.showMessageBox("Unable to register","An account with this username already exists!")
        player = {}
    end
end

function drawLoginBox()
    if not player.authcode then
        love.graphics.setColor(0,0,0,1)
        love.graphics.rectangle("fill",0,0,200,100)
        love.graphics.setColor(1,1,1,1)
        love.graphics.setFont(bFont)
        love.graphics.printf("Please login", 0, 0, 200, "center")
        drawTextBox(usernameBox)
        drawTextBox(passwordBox)
        if drawButton("Login",10,2+32+tFont:getHeight()*2,180,bFont) then login(textbox[usernameBox].text,textbox[passwordBox].text) end
        if drawButton("Register",10,2+32+tFont:getHeight()*2 + bFont:getHeight(),180,bFont) then register(textbox[usernameBox].text,textbox[passwordBox].text) end
    end
end

function drawPlayerStats()
    love.graphics.setColor(0,0,0,1)
    love.graphics.rectangle("fill",0,0,love.graphics.getWidth(),24)
    love.graphics.setColor(1,1,1)
    love.graphics.setFont(bFont)
    love.graphics.print("King "..player.username)

    if buildingCount == 0 then
        love.graphics.print("Choose a tile to place your castle.", 0+bFont:getWidth("King "..player.username.."  "), 0)
    end
end