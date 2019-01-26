tooltip = {
    title = "None",
    desc = "Nothing given to use yet!",
    alpha = 0,
    x = 0,
    y = 0
}

function setTT(title, desc)
    tooltip.title = title
    tooltip.desc = desc
    tooltip.alpha = 1.3
    tooltip.x = cx
    tooltip.y = cy
end

function drawTT()
    love.graphics.setColor(0,0,0,tooltip.alpha)
    love.graphics.rectangle("fill",tooltip.x,tooltip.y,tFont:getWidth(tooltip.desc),64)
    love.graphics.setColor(1,1,1,tooltip.alpha)
    love.graphics.setFont(font)
    love.graphics.print(tooltip.title,tooltip.x,tooltip.y)
    love.graphics.setFont(tFont)
    love.graphics.print(tooltip.desc,tooltip.x,tooltip.y+font:getHeight())
    love.graphics.setColor(1,1,1,1)
end

function updateUIElements(dt)
    tooltip.alpha = tooltip.alpha - 0.4*dt
end

function drawUIElements()
    drawTT()
end