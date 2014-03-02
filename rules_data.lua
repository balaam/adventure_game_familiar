
adventure_game_patterns = [[
[start] -> [basic] | [basic] | [basic] | [basic] | [multi_solution]
[basic] -> Problem: " " [problem] "#" Solution: " " [solution]
[multi_solution] -> Problem: " " [problem] "#" Solution: " " [solution] " & " [solution]
[problem] -> guardian | "want FOO" | "key request" | "temporal item" | "hidden FOO" | "FOO out of reach" | "trapped" | "approaching danger"
[solution] -> [s1] | [s2]
[s1] -> "temporal" | "new item perception" | "combine items" | "trial and error" | "obvious item use" | "change item state"
[s2] -> "monkey see monkey do" | "repetition" | "spatial" | "bait item use" | "real world knowledge" | "sabotage"
]]

problem_description =
{
    ["guardian"] = "Something actively prevents you from progressing.",
    ["want FOO"] = "The character's need for something must be satisifed.",
    ["key request"] = "An item or piece of knowledge is required to progress.",
    ["temporal item"] = "Attempting to progress may cause a vital item to dissapear.",
    ["hidden FOO"] = "An object you need is hidden and can not be found in the usual way.",
    ["FOO out of reach"] = "There is evidence of FOO but you cannot access it.",
    ["trapped"] = "The character is trapped in someway and must escape before progressing.",
    ["approaching danger"] = "If you stay where you are and do nothing you will die (or similar)."
}

solution_description =
{
    ["temporal"] = "Do a certain action or item use at a certain time.",
    ["new item perception"] = "An item must be seen in a new light. May require the character to look at the item.",
    ["combine items"] = "Combine, two, usually inventory, items to produce a more useful item.",
    ["trial and error"] = "Actions must be taken in a certain order, worked out by trial and error.",
    ["obvious item use"] = "Straight forward, common-sense use of an object or action.",
    ["change item state"] = "Change the item through use or action.",
    ["monkey see monkey do"]  = "Copy the actions of some actor in the world.",
    ["repetition"]  = "Do the same action more than once. Doesn't succeed on the first time but does subsequently.",
    ["spatial"]  = "An action will only succeed if the character is in a certain place.",
    ["bait item use"]  = "Something nearby is interacted with in the hopes it will distract or remove the problem.",
    ["real world knowledge"]  = "The player is required to have a certain piece of knowledge or do research.",
    ["sabotage"]  = "Prevent a process from continuing.",
}