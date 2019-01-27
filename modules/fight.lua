troops = {}
fightAlpha = 0
tatk = 0
tdef = 0

troop1 = love.graphics.newImage("assets/troop1.png")
troop2 = love.graphics.newImage("assets/troop2.png")
deadTroop = love.graphics.newImage("assets/Gravestone.png")

function newFight(atk, def, units, newUnits)
    atk = tonumber(atk)-1
    def = tonumber(def)-1
    tatk = atk
    tdef = def
    fightAlpha = 300
    troops = {}
    for i = 1, units do
        troops[#troops + 1] = {
            x = love.math.random(0, 4),
            y = love.math.random(20,180),
            dead = false,
            speed = love.math.random(60,100)
        }
    end

    for i = 1, newUnits do
        troops[#troops + 1] = {
            x = love.math.random(180, 200),
            y = love.math.random(20,180),
            dead = false,
            speed = love.math.random(-100,-60)
        }
    end
end

function updateFight(dt)
    for i, v in pairs(troops) do
        if not troops[i].dead then
            troops[i].x = troops[i].x + v.speed*dt
        end

        if troops[i].x > 99 and troops[i].x < 101 then
            if v.speed > 0 then
                if tatk > 0 then
                    troops[i].dead = true
                    tatk = tatk - 1
                end
            elseif v.speed < 0 then
                if tdef > 0 then
                    troops[i].dead = true
                    tdef = tdef - 1
                end
            end
        end
    end

    if tatk < 1 and tdef < 1 then
        fightAlpha = fightAlpha - 0.4*dt
    end
end

function drawFight(x,y)
    love.graphics.setColor(0,0,0,fightAlpha)
    love.graphics.rectangle("fill",x,y,200,200)
    
    love.graphics.setColor(1,1,1,fightAlpha)
    for i, v in pairs(troops) do
        if v.dead then love.graphics.draw(deadTroop,v.x+x,v.y+y)
        elseif v.speed > 0 then love.graphics.draw(troop1,v.x+x,v.y+y)
        elseif v.speed < 0 then love.graphics.draw(troop2,v.x+x,v.y+y) end
    end
end