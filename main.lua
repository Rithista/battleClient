http = require("socket.http")
local myGame = require("game")


function love.load()

    -- in the main chunk somewhere:

-- every time after resolution changes, and also at initialization: 


    myGame.load()
end

function findTile(x)
    return x * myGame.findTileSize()
end

function love.update(dt)
    -- To move the cursor/current unit
    -- with a smooth L33T transition
	--player.act_y = player.act_y - ((player.act_y - player.grid_y) * player.speed * dt)
	--player.act_x = player.act_x - ((player.act_x - player.grid_x) * player.speed * dt)
end

function love.draw()

    myGame.draw()
end

function love.keypressed(key)
    
end

function love.mousepressed(x, y, button, istouch)
    mouseX = x
    mouseY = y
    -- mouseX = math.floor(mouseX/myGame.findTileSize()) * findTileSize()
    -- mouseY = math.floor(mouseY/myGamer.findTileSize()) * findTileSize() 
end

-- Make HTTP request to http://freshplay.co.uk/b/api.php?a=get&scope=world&type=buildings



