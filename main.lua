palikat = {}
putoamisMaxDelay = 0.3
tileSize = 32
inputMaxDelay = 0.1
inputMaxDelayDown = 0.25
active = nil
fieldXStart = 100
fieldYStart = 100
fieldX = 10
fieldY = 19
function love.load()
    --table.insert(palikat,{x=0,y=0})
    putoamisDelay = 0
    inputDelay = 0
    inputDelayDown = 0
end

function occupied(x, y)
    for i, palikka in ipairs(palikat) do
        if palikka.x == x and palikka.y == y then
            return true
        end
    end
    return false
end

function love.update(dt)
    putoamisDelay = putoamisDelay + dt
    inputDelay = inputDelay + dt
    inputDelayDown = inputDelayDown + dt
    if active == nil then
        uusi = { x = 5, y = 0 }
        table.insert(palikat, uusi)
        active = uusi
    end
    if putoamisDelay >= putoamisMaxDelay then
        active.y = active.y + 1
        putoamisDelay = 0
    end
    if love.keyboard.isDown("right") and inputDelay >= inputMaxDelay and active.x < fieldX - 1 then
        active.x = active.x + 1
        inputDelay = 0
    end
    if love.keyboard.isDown("left") and inputDelay >= inputMaxDelay and active.x > 0 then
        active.x = active.x - 1
        inputDelay = 0
    end
    if love.keyboard.isDown("down") and inputDelayDown >= inputMaxDelayDown then
        repeat
            active.y = active.y + 1
        until occupied(active.x, active.y + 1) or active.y == fieldY - 1
        inputDelayDown = 0
    end
    --	if love.keyboard.isDown("space") and inputDelaySpace >= inputMaxDelaySpace then
    --		table.insert(palikat,{x=5,y=0})
    --		inputDelaySpace = 0
    --	end
    if occupied(active.x, active.y + 1) or active.y == fieldY - 1 then
        uusi = { x = 5, y = 0 }
        table.insert(palikat, uusi)
        active = uusi
        if occupied(active.x, active.y) then
            --game over
        end
    end
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.line(fieldXStart, fieldYStart, fieldX * tileSize + fieldXStart, fieldYStart)
    love.graphics.line(fieldXStart, fieldYStart, fieldXStart, fieldY * tileSize + fieldYStart)
    love.graphics.line(fieldX * tileSize + fieldXStart, fieldYStart, fieldX * tileSize + fieldXStart, fieldY * tileSize + fieldYStart)
    love.graphics.line(fieldXStart, fieldY * tileSize + fieldYStart, fieldX * tileSize + fieldXStart, fieldY * tileSize + fieldYStart)
    love.graphics.setColor(255, 0, 0)
    for i, palikka in ipairs(palikat) do
        love.graphics.rectangle('fill', palikka.x * tileSize + fieldXStart, palikka.y * tileSize + fieldYStart, tileSize, tileSize)
    end
    love.graphics.setColor(255, 50, 50)
    for i, palikka in ipairs(palikat) do
        love.graphics.rectangle('fill', palikka.x * tileSize + 2 + fieldXStart, palikka.y * tileSize + 2 + fieldYStart, tileSize - 4, tileSize - 4)
    end
end