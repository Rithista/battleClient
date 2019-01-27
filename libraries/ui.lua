tooltip = {
    title = "None",
    desc = "Nothing given to use yet!",
    alpha = 0,
    x = 0,
    y = 0
}

textbox = {}
activeTextBox = nil

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

function addTextBox(x,y,width,font,default)
    if not default then default = "Enter text.." end

    textbox[#textbox+1] = {
        x = x,
        y = y,
        width = width,
        font = font,
        default = default,
        text = "",
        active = false
    }
end

function drawTextBox()
    for i, v in pairs(textbox) do
        if isMouseOver(v.x,v.y,v.width,v.font:getHeight()) then
            love.graphics.setColor(0.8,0.8,0.8,1)
        else
            love.graphics.setColor(1,1,1,1)
        end
        love.graphics.rectangle("fill",v.x,v.y,v.width,v.font:getHeight())

        love.graphics.setFont(v.font)
        if v.text == "" then
            love.graphics.setColor(0,0,0,0.5)
            love.graphics.print(v.default)
        else
            love.graphics.setColor(0,0,0,1)
            love.graphics.print(v.text)
        end
    end
end

function updateUIElements(dt)
    tooltip.alpha = tooltip.alpha - 0.4*dt
end

function drawUIElements()
    drawTT()
end

function uiPress(x,y)
    for i = 1, #textbox do
        if isMouseOver(v.x,v.y,v.width,v.font:getHeight()) then
            textbox[i].active = true
            activeTextBox = i
        else
            textbox[i].active = false -- clicking off the textbox disables its entry
        end
    end
end

function love.keypressed(key)
    if key == "backspace" then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(text, -1)
 
        if byteoffset and textbox[activeTextBox].active == true then -- the activetextbox only changes when a new textbox is clicked on, not when that textbox is no longer active so this check is necessary
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            textbox[activeTextBox].text = string.sub(textbox[activeTextBox].text, 1, byteoffset - 1)
        end
    end
end

function love.textinput(t)
    if textbox[activeTextBox].active == true then
        textbox[activeTextBox].text = textBox[activeTextBox].text .. t
    end
end
 