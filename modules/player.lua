player = {}

function login(username,password)
    b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=login&username="..username.."&password="..password)

    if b ~= "false" then
        player.authcode = b
        b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=data&authcode="..player.authcode)
        player = json:decode(b)
    else
        love.window.showMessageBox("Unable to login","Username or password is incorrect.")
    end
end

function register(username,password)
    b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=register&username="..username.."&password="..password)
    
    if b ~= "false" then
        player.authcode = b
        b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=player&type=data&authcode="..player.authcode)
        player = json:decode(b)
    else
        love.window.showMessageBox("Unable to register","An account with this username already exists!")
    end
end

function drawLoginBox()
    
end