LoadLibrary("Asset")
LoadLibrary("Renderer")
LoadLibrary("Vector")
LoadLibrary("System")
LoadLibrary("Mouse")

Asset.Run("rules_data.lua")
Asset.Run("print_table.lua")
Asset.Run("util.lua")
Asset.Run("rule_set.lua")

local width = System.ScreenWidth()
local height = System.ScreenHeight()
local buttonHeight = 80
local coreYOff = 90

math.randomseed( os.time() )
gRenderer = Renderer.Create()
gRenderer:AlignTextX("center")

gRules = RuleSet:Create(adventure_game_patterns)

gPuzzle =
{
    problem = "",
    problemDesc = "",
    solution = "",
    solutionDesc = {}
}


function generatePuzzle()

    local exp = gRules:Run("[start]")

    --
    -- Munging the data
    --

    local problem = exp:sub(1, exp:find("#") - 1)
    local solution = exp:sub(exp:find("#") + 1)

    local first = RuleSet.Trim(_, problem:sub(problem:find(":") + 1))
    local second = RuleSet.Trim(_, solution:sub(solution:find(":") + 1))

    second = RuleSet.StrSplit(_, second, "&")
    for k, v in ipairs(second) do
        second[k] = RuleSet.Trim(_, second[k])
    end

    gPuzzle.problem = problem
    gPuzzle.problemDesc = problem_description[first]

    gPuzzle.solution = solution
    gPuzzle.solutionDesc =
    {
        solution_description[second[1]],
        solution_description[second[2]]
    }

end

function drawButton()

    local texCol = Vector.Create(0.7, 0.7, 0.7, 1)
    local butCol = Vector.Create(1, 1, 1, 0.05)
    local buttonTop = -height/2 + buttonHeight
    local x = 0
    local y = -height/2 + (buttonHeight/2)
    if Mouse.Y() <= buttonTop then
        texCol = Vector.Create(0.9, 0.9, 0.9, 1)
        butCol = Vector.Create(1, 1, 1, 0.08)

        if Mouse.JustReleased(MOUSE_BUTTON_LEFT) then
            generatePuzzle()
        elseif Mouse.Held(MOUSE_BUTTON_LEFT) then
            x = x + 2
            y = y - 2
        end
    end

    gRenderer:ScaleText(1.2)
    gRenderer:DrawRect2d(-width/2,
                         -height/2,
                         width/2,
                         buttonTop,
                         butCol)
    gRenderer:SetFont("font")
    gRenderer:AlignTextX("center")
    gRenderer:AlignTextY("center")
    gRenderer:DrawText2d(x, y,
                         "Press to Generate Puzzle.",
                         texCol)
end

function drawHeader()
    gRenderer:SetFont("bold")
    gRenderer:AlignTextX("left")
    gRenderer:AlignTextY("top")
    gRenderer:ScaleText(3)
    local title = "Puzzle Familiar"
    local size = gRenderer:MeasureText(title)
    local x = -width/2 + 2
    local y = height/2 - 2
    gRenderer:DrawText2d(x, y,
                         title,
                         Vector.Create(1,1,1,0.2))
    gRenderer:ScaleText(0.75)
    gRenderer:AlignTextX("right")
    x = x + size:X()
    y = y - size:Y() + 10
    local twitterId = "@danschuller"
    local twitterSize = gRenderer:MeasureText(twitterId)
    local twitterCol = Vector.Create(1, 1, 1, 0.1)

    if Mouse.X() <= x and Mouse.X() >= x - twitterSize:X()
    and Mouse.Y() <= y and Mouse.Y() >= y - twitterSize:Y()  then
        twitterCol = Vector.Create(1, 1, 1, 0.9)
        if Mouse.JustReleased(MOUSE_BUTTON_LEFT) then
            System.OpenURL("https://twitter.com/DanSchuller")
        elseif Mouse.Held(MOUSE_BUTTON_LEFT) then
            x = x + 2
            y = y - 2
        end
    end

    gRenderer:DrawText2d(x, y, twitterId, twitterCol)

end

function drawPuzzleTip()
    local tab = 40
    local titleCol = Vector.Create(0.9, 0.9, 0.9, 1)
    local descCol = Vector.Create(0.75, 0.75, 0.75, 1)
    local descDescender = 36
    gRenderer:ScaleText(1.5)
    gRenderer:AlignTextX("left")
    gRenderer:SetFont("bold")
    local x = -width/2 + tab
    local y = height/2 - coreYOff
    gRenderer:DrawText2d(x, y, gPuzzle.problem, titleCol)
    gRenderer:SetFont("light")
    gRenderer:ScaleText(1.0)
    y = y - descDescender
    gRenderer:DrawText2d(x, y, gPuzzle.problemDesc, descCol)

    y = y- 50
    gRenderer:ScaleText(1.5)
    gRenderer:AlignTextX("left")
    gRenderer:SetFont("bold")
    local x = -width/2 + tab
    gRenderer:DrawText2d(x, y, gPuzzle.solution, titleCol, width *0.9)
    local soluSize = gRenderer:MeasureText(gPuzzle.solution, width * 0.9)
    gRenderer:SetFont("light")
    gRenderer:ScaleText(1.0)
    y = y - soluSize:Y()--descDescender
    local soluDesc1 = gPuzzle.solutionDesc[1] or ""
    local wMod = 0.8
    local descSize = gRenderer:MeasureText(soluDesc1, width * wMod)
    gRenderer:DrawText2d(x, y, soluDesc1, descCol, width * wMod)
    y = y - descSize:Y() - 4

    gRenderer:DrawText2d(x, y,
                         gPuzzle.solutionDesc[2] or "",
                         descCol,
                         width * wMod)
end

function update()
    drawHeader()
    drawPuzzleTip()
    drawButton()
end