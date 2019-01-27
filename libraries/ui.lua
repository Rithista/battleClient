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
    love.graphics.setFont(bFont)
    love.graphics.print(tooltip.title,tooltip.x,tooltip.y)
    love.graphics.setFont(tFont)
    love.graphics.print(tooltip.desc,tooltip.x,tooltip.y+bFont:getHeight())
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
        active = false,
        hidden = false
    }


    return #textbox
end

function drawTextBox(i)
   v = textbox[i]
        if not v.hidden then
            if isMouseOver(v.x,v.y,v.width,v.font:getHeight()) then
                love.graphics.setColor(0.8,0.8,0.8,1)
            else
                love.graphics.setColor(1,1,1,1)
            end
            love.graphics.rectangle("fill",v.x,v.y,v.width,v.font:getHeight())

            love.graphics.setFont(v.font)
            if v.text == "" and not v.active then
                love.graphics.setColor(0,0,0,0.5)
                love.graphics.print(v.default,v.x,v.y)
            else
                love.graphics.setColor(0,0,0,1)
                love.graphics.print(v.text,v.x,v.y)
            end

            if v.active then love.graphics.print("|",v.x+v.font:getWidth(v.text),v.y) end
        end

    love.graphics.setColor(1,1,1,1)
end

function drawButton(text,x,y,width,font)
    if isMouseOver(x,y,width,font:getHeight()) then
        love.graphics.setColor(0.7,0.7,0.7,1)
    else
        love.graphics.setColor(1,1,1,1)
    end

    love.graphics.setFont(font)
    love.graphics.rectangle("line",x,y,width,font:getHeight())
    love.graphics.setColor(1,1,1,1)
    love.graphics.printf(text,x,y,width,"center")

    if isMouseOver(x,y,width,font:getHeight()) and love.mouse.isDown(1) then
        return true
    end
end

function updateUIElements(dt)
    tooltip.alpha = tooltip.alpha - 0.4*dt
end

function drawUIElements()
    drawTT()
end

function uiPress(x,y)
    for i, v in pairs(textbox) do
        if isMouseOver(v.x,v.y,v.width,v.font:getHeight()) then
            textbox[i].active = true
            activeTextBox = i
        else
            textbox[i].active = false -- clicking off the textbox disables its entry
        end
    end
end

function love.keypressed(key)
    if key == "backspace" and textbox[activeTextBox] then
        -- get the byte offset to the last UTF-8 character in the string.
        local byteoffset = utf8.offset(textbox[activeTextBox].text, -1)
 
        if byteoffset and textbox[activeTextBox].active == true then -- the activetextbox only changes when a new textbox is clicked on, not when that textbox is no longer active so this check is necessary
            -- remove the last UTF-8 character.
            -- string.sub operates on bytes rather than UTF-8 characters, so we couldn't do string.sub(text, 1, -2).
            textbox[activeTextBox].text = string.sub(textbox[activeTextBox].text, 1, byteoffset - 1)
        end
    elseif key == "r" then
        updateWorld()
    end
end

function love.textinput(t)
    if textbox[activeTextBox] and textbox[activeTextBox].active == true then
        textbox[activeTextBox].text = textbox[activeTextBox].text .. t
    end
end
 