


game = {}
local MAP_WIDTH = 100
local MAP_HEIGHT = 100
local TILE_WIDTH = 32
local TILE_HEIGHT = 32

function game.findTileSize()
    TILE_WIDTH = 32
    return TILE_WIDTH
end

game.map = {}
game.map = {
            {13, 13, 13, 1, 1},
            {13, 13, 1, 1, 1},
            {13, 13, 1, 1, 13},
            {13, 1, 1, 13, 13},
            {1, 1, 13, 13, 13}
            }

game.tileSheet = nil
game.tileTexture = {}
game.tileType = {}

-- Define tile types here

    game.tileType[13] = "grass"
    game.tileType[1] = "dirt"
    game.tileType[12] = "null"
    game.tileType[15] = "red flower"
    game.tileType[14] = "yellow flower"


-- End of tile types definition

local rans = {13,14,15}
function myRandom()
    return rans[math.random(#rans)]
end

game.map = {}

for i = 1, 100 do
    game.map[i] = {}
    for k = 1, 100 do
        game.map[i][k] = myRandom()
    end
end


function game.load()
    print("game : loading textures")
    game.tileSheet = love.graphics.newImage("assets/tilesheet.png")
    local nbColone = game.tileSheet:getWidth() / TILE_WIDTH
    local nbLine = game.tileSheet:getHeight() / TILE_HEIGHT
    local l,c
    local id = 1
    game.tileTexture[0] = nil
    for l = 1, nbLine do
        for c = 1, nbColone do
            game.tileTexture[id] = love.graphics.newQuad((c - 1) * TILE_WIDTH, (l - 1)* TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT,
            game.tileSheet:getWidth(), game.tileSheet:getHeight())
        id = id + 1
        end
    end



    print("game: textures loaded")
end

function game.draw()
    local l,c 
    for l = 1, MAP_HEIGHT do
        for c = 1, MAP_WIDTH do
            local id = game.map[l][c]
            if id ~= 0 then
                love.graphics.draw(game.tileSheet,game.tileTexture[id], (c - 1)*TILE_WIDTH,(l - 1)* TILE_HEIGHT)
            end
        end
    end
    local mCol = math.floor(love.mouse.getX() / TILE_WIDTH) + 1
    local mLine = math.floor(love.mouse.getY() / TILE_HEIGHT) + 1
    if mCol >= 1 and mCol <= MAP_WIDTH and mLine >= 1 and mLine <= MAP_HEIGHT then
        local id = game.map[mLine][mCol]
        love.graphics.print("ID : "..tostring(id).. " Type : "..tostring(game.tileType[id]), 1, 1)
    else
        love.graphics.print("Not a tile")
    end
end


return game