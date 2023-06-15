screenWidth, screenHeight = term.getSize()
yMid = math.floor(screenHeight/2)
xMid = math.floor(screenWidth/2)

keyLeft = 263
keyRight = 262
keyUp = 265
keyDown = 264
keyW = 87 
keyA = 65
keyD = 68
keyS = 83
keyEnter = 257

require("/os/global/variables")

function printHeader()
    printAtPos(1, 1, osName)
    printAtPos(1, 2, "Version: "..osVersion)
end

function readAtPos(xPos, yPos)
    term.setCursorPos(xPos, yPos)
    return read()
end

function resetCursor()
    term.setCursorPos(1, 1)
end
function resetScreen()
    term.clear()
    resetCursor()
end

function clearLine()
    x, y = term.getCursorPos()
    for w = 1, screenWidth do
        printAtPos(w, y, " ")
    end
end

function printCenteredY(yPos, s)
    term.setCursorPos(
        math.floor(screenWidth / 2) - 5,
        yPos 
    )
    term.clearLine()
    term.write(s)
end

function printCenteredX(xPos, s)
    term.setCursorPos(
        xPos,
        math.floor(screenHeight / 2) - string.len(s) / 2
    )
    term.clearLine()
    term.write(s)
end

function printAtPos(xPos, yPos, s)
    term.setCursorPos(xPos, yPos)
    term.clearLine()
    term.write(s)
end
function overwriteAtPos(xPos, yPos, s)
    term.setCursorPos(xPos, yPos)
    term.write(s)
end

function printIfSelected(o, i, s, opt)
    if o == opt then
        printCenteredY(i, "[ "..s.." ]")
    else
        printCenteredY(i, " "..s.." ")
    end
end