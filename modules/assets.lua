bFont = love.graphics.newFont(16)
tFont = love.graphics.newFont(11)

worldImg = {}
worldImg["Grass"] = love.graphics.newImage("assets/Grass.png")
worldImg["Forest"] = love.graphics.newImage("assets/Forest.png")
worldImg["Mine"] = love.graphics.newImage("assets/Mine.png")
worldImg["Castle"] = love.graphics.newImage("assets/Castle.png")

statImg = {
    food = love.graphics.newImage("assets/stats/food.png"),
    gold = love.graphics.newImage("assets/stats/gold.png"),
    pop = love.graphics.newImage("assets/stats/population.png"),
    wood = love.graphics.newImage("assets/stats/wood.png")
}