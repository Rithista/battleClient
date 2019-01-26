
game = {}
local MAP_WIDTH = 100
local MAP_HEIGHT = 100
local TILE_WIDTH = 32
local TILE_HEIGHT = 32

function game.findTileSize()
    TILE_WIDTH = 32
    return TILE_WIDTH
end

worldImg = {}
worldImg["Grass"] = love.graphics.newImage("assets/Grass.png")
worldImg["Forest"] = love.graphics.newImage("assets/Forest.png")
worldImg["Mine"] = love.graphics.newImage("assets/Mine.png")


-- Define tile types here




-- End of tile types definition

local rans = {13,14,15}
function myRandom()
    return rans[math.random(#rans)]
end

--game.map = {}

--for i = 1, 100 do
 --   game.map[i] = {}
 --   for k = 1, 100 do
 --       game.map[i][k] = myRandom()
 --   end


function getMap()
    newGameMap = {}

    --Initialise world with grass

    for i = 1, 100*100 do
        newGameMap[i] = "Grass"
    end
    b, c, h = http.request("http://freshplay.co.uk/b/api.php?a=get&scope=world")
    json = require("json")

    world_decoded = json:decode(b)
    for i, v in pairs(world_decoded) do
        newGameMap[i] = v.buildingType
        print(v.buildingType)
    end
end

function game.load()
    getMap()
end

function game.draw()

    local x = 0
    local y = 0
    for i = 1, 100*100 do
        if worldImg[newGameMap[i]] then
            love.graphics.draw(worldImg[newGameMap[i]], x, y)
        else
          print("CAN'T FIND BUILDING TYPE "..tostring(newGameMap[i]))
        end
        x = x + 32
        if x >= 100*32 then
            x = 0
            y = y + 32
        end
    end

    local mCol = math.floor(love.mouse.getX() / TILE_WIDTH) + 1
    local mLine = math.floor(love.mouse.getY() / TILE_HEIGHT) + 1
    if mCol >= 1 and mCol <= MAP_WIDTH and mLine >= 1 and mLine <= MAP_HEIGHT then 
        local id = newGameMap[mCol + ((mLine - 1) * 100)]
        love.graphics.print("ID : "..tostring(id), 1, 1)
        love.graphics.print("X : "..tostring(mCol).. " Y : "..tostring(mLine), 100, 1)
    else
        love.graphics.print("Not a tile")
    end
end


return game