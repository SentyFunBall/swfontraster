-- Author: SentyFunBall
-- GitHub: https://github.com/SentyFunBall
-- Workshop: 

--Code by STCorp. Do not reuse.--
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey


--[====[ HOTKEYS ]====]
-- Press F6 to simulate this file
-- Press F7 to build the project, copy the output from /_build/out/ into the game to use
-- Remember to set your Author name etc. in the settings: CTRL+COMMA


--[====[ EDITABLE SIMULATOR CONFIG - *automatically removed from the F7 build output ]====]
---@section __LB_SIMULATOR_ONLY__
do
    ---@type Simulator -- Set properties and screen sizes here - will run once when the script is loaded
    simulator = simulator
    simulator:setScreen(1, "9x5")
    simulator:setProperty("ExampleNumberProperty", 123)

    -- Runs every tick just before onTick; allows you to simulate the inputs changing
    ---@param simulator Simulator Use simulator:<function>() to set inputs etc.
    ---@param ticks     number Number of ticks since simulator started
    function onLBSimulatorTick(simulator, ticks)

        -- touchscreen defaults
        local screenConnection = simulator:getTouchScreen(1)
        simulator:setInputBool(1, screenConnection.isTouched)
        simulator:setInputNumber(1, screenConnection.width)
        simulator:setInputNumber(2, screenConnection.height)
        simulator:setInputNumber(3, screenConnection.touchX)
        simulator:setInputNumber(4, screenConnection.touchY)

        -- NEW! button/slider options from the UI
        simulator:setInputBool(31, simulator:getIsClicked(1))       -- if button 1 is clicked, provide an ON pulse for input.getBool(31)
        simulator:setInputNumber(31, simulator:getSlider(1))        -- set input 31 to the value of slider 1

        simulator:setInputBool(32, simulator:getIsToggled(2))       -- make button 2 a toggle, for input.getBool(32)
        simulator:setInputNumber(32, simulator:getSlider(2) * 50)   -- set input 32 to the value from slider 2 * 50
    end;
end
---@endsection


--[====[ IN-GAME CODE ]====]

-- try require("Folder.Filename") to include code from another file in this, so you can store code in libraries
-- the "LifeBoatAPI" is included by default in /_build/libs/ - you can use require("LifeBoatAPI") to get this, and use all the LifeBoatAPI.<functions>!

require("SenFont")

local font = {
    meta = {
        name = "SenFont",
        version = "1.0",
        author = "SentyTek",
        unitsPerDisplay = 1, --1 unit is 32x32 pixels. fonts may be bigger or smaller
    },
    cmap = {
        ["P"] = 1,
    },
    glyph = {
        { --p
            advance_width = 20, --defined as pixels
            bound = {x=0, y=0, w=20, h=32}, --defined as pixels
            data = {
                --x, y coordinates in pixel offset to the top left of the glyph.
                --goes {startX, startY}, {controlX, controlY}, {endX, endY}
                --if only two points in a segment, it's a line
                --if three points, it's a bezier curve
                {
                    -- Outer contour (clockwise)
                    {{6, 0}, {0, 0}},
                    {{0, 0}, {0, 31}},
                    {{0, 31}, {5, 31}},
                    {{5, 31}, {5, 13}},
                    {{5, 13}, {20, 13}, {20, 7}},
                    {{20, 7}, {20, 0}, {6, 0}}
                },
                {
                    -- Inner contour (counterclockwise)
                    {{5, 3}, {5, 10}},
                    {{5, 10}, {16, 10}, {16, 6}},
                    {{16, 6}, {16, 3}, {5, 3}}
                }
            }
        }
    }
}

SenFont.importFont(font)
render = SenFont.render
debugCol = true
tick = 0
function onDraw()
    lines = 0
    tick = tick + 1
    screen.setColor(255,255,255)
    --screen.drawText(100, 100, "P")
    time = os.clock()*1000

    --render(glyph, x, y, [scale, {flipv, fliph, rotateRadians}])
    render("P", 0, 0, 1, {hollow = true})
    --[[render("P", 32, 32, 1)
    render("P", 64, 32, 1, {flipV = true})
    render("P", 96, 32, 1, {flipH = true})
    render("P", 128, 32, 1, {flipV = true, flipH = true})
    render("P", 200, 32, 1, {rotate = tick / math.pi / 2})
    render("P", 32, 100, 0.5)
    render("P", 64, 100, 2)]]
    --SenFont.drawText("PPPP", 10, 10, 1)

    --renderG(SenFont.font.glyph[1], 0, 0, 2)

    time = os.clock()*1000 - time
    screen.drawText(200, 150, "Time: "..time)
    screen.drawText(200, 140, "Lines: "..lines)
end