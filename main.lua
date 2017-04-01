--Constants
local BLOCKS = {}
local DROP_DELAY = 0.01--0.3
local TILE_SIZE = 32
local INPUT_DELAY = 0.1
local DOWN_INPUT_DELAY = 0.25
local FIELD_X_START = 100
local FIELD_Y_START = 100
local FIELD_X = 10
local FIELD_Y = 19
--File-global variables
local activeBlocks
local dropTimer
local inputTimer
local downInputTimer
local gamestate
--Namespace for functions
local tetris = {}
function love.load()
    --table.insert(palikat,{x=0,y=0})
    dropTimer = 0
    inputTimer = 0
    downInputTimer = 0
    gamestate = "game"
end

function occupied(x, y)
    for _, palikka in ipairs(BLOCKS) do
        if palikka.x == x and palikka.y == y then
            return true
        end
    end
    return false
end

function spawnTetromino(name, position)
    position = position or math.floor(FIELD_X / 2)
    --TODO
end

function love.update(dt)
    if gamestate == "game" then
        tetris.updategame(dt)
    end
end

function tetris.updategame(dt)
    dropTimer = dropTimer + dt
    inputTimer = inputTimer + dt
    downInputTimer = downInputTimer + dt
    if activeBlocks == nil then
        local uusi = { x = 5, y = 0 }
        table.insert(BLOCKS, uusi)
        activeBlocks = uusi
    end
    if love.keyboard.isDown("down") and downInputTimer >= DOWN_INPUT_DELAY then
        repeat
            activeBlocks.y = activeBlocks.y + 1
        until occupied(activeBlocks.x, activeBlocks.y + 1) or activeBlocks.y == FIELD_Y - 1
        downInputTimer = 0
        dropTimer = 1000
    end

    if dropTimer >= DROP_DELAY then
        local todrop=1
        if occupied(activeBlocks.x, activeBlocks.y + 1) or activeBlocks.y == FIELD_Y - 1 then
            local uusi = { x = 5, y = 0 }
            activeBlocks = uusi
            if occupied(activeBlocks.x, activeBlocks.y) then
                gamestate = "gameover"
            end
            table.insert(BLOCKS, uusi)

            todrop=0
        end

        activeBlocks.y = activeBlocks.y + todrop
        dropTimer = 0
    end
    if love.keyboard.isDown("right") and inputTimer >= INPUT_DELAY and activeBlocks.x < FIELD_X - 1 then
        activeBlocks.x = activeBlocks.x + 1
        inputTimer = 0
    end
    if love.keyboard.isDown("left") and inputTimer >= INPUT_DELAY and activeBlocks.x > 0 then
        activeBlocks.x = activeBlocks.x - 1
        inputTimer = 0
    end
end

function love.draw()
    if gamestate == "game" or gamestate == "gameover" then
        tetris.drawgame()
    elseif gamestate == "mainmenu" then
        tetris.drawmainmenu()
    end
end

function tetris.drawgame()

    --Blocks
    love.graphics.setColor(255, 0, 0)
    for _, palikka in ipairs(BLOCKS) do
        love.graphics.rectangle('fill', palikka.x * TILE_SIZE + FIELD_X_START, palikka.y * TILE_SIZE + FIELD_Y_START, TILE_SIZE, TILE_SIZE)
    end
    love.graphics.setColor(255, 50, 50)
    for _, palikka in ipairs(BLOCKS) do
        love.graphics.rectangle('fill', palikka.x * TILE_SIZE + 2 + FIELD_X_START, palikka.y * TILE_SIZE + 2 + FIELD_Y_START, TILE_SIZE - 4, TILE_SIZE - 4)
    end
    --Border
    love.graphics.setColor(255, 255, 255)
    love.graphics.line(FIELD_X_START, FIELD_Y_START, FIELD_X * TILE_SIZE + FIELD_X_START, FIELD_Y_START)
    love.graphics.line(FIELD_X_START, FIELD_Y_START, FIELD_X_START, FIELD_Y * TILE_SIZE + FIELD_Y_START)
    love.graphics.line(FIELD_X * TILE_SIZE + FIELD_X_START, FIELD_Y_START, FIELD_X * TILE_SIZE + FIELD_X_START, FIELD_Y * TILE_SIZE + FIELD_Y_START)
    love.graphics.line(FIELD_X_START, FIELD_Y * TILE_SIZE + FIELD_Y_START, FIELD_X * TILE_SIZE + FIELD_X_START, FIELD_Y * TILE_SIZE + FIELD_Y_START)
    --Game over overlay
    if gamestate == "gameover" then
        love.graphics.setColor(128, 128, 128)
        love.graphics.rectangle('fill', 0, 350, 500, 80)
        love.graphics.setFont(love.graphics.newFont(70))
        love.graphics.setColor(128, 0, 0)
        love.graphics.print("GAME OVER", 40, 350)
    end
end