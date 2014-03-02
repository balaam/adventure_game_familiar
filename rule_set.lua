RuleSet = {}
RuleSet.__index = RuleSet
function RuleSet:Create(str)
    local this = {}
    setmetatable(this, self)
    if str then
        this:LoadRules(str)
    end
    return this
end

function RuleSet:LoadRules(str)
    self.mRules = self:ToRules(str)
end

function RuleSet:ToLines(str)
    local t = {}
    local function helper(line)
        if line == "" then return "" end
        table.insert(t, line)
        return ""
    end
  helper((str:gsub("(.-)\r?\n", helper)))
  return t
end

function RuleSet:StrSplit(str, sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    str:gsub(pattern, (function(c) fields[#fields+1] = c end))
    return fields
end

function RuleSet:StrSplitQuote(str)
    local special =
    {
        n = "\n",
        r = "\r",
        t = "\t",
        v = "\v"
    }

    local ret = {}
    local len = string.len(str)

    local literal = false
    local quote = false
    local current = ""

    for i = 1, len do

        local c = str:sub(i, i)

        if literal then
            if c == '\"' then
                quote = not quote
            else
                c = special[c] or c
                current = current .. c
            end
            literal = false
        else
            if c == '\"' then
                quote = not quote
            elseif c == '\\' then
                literal = true
            elseif c == ' ' and not quote then
                table.insert(ret, current)
                current = ""
            else
                current = current .. c
            end
        end

    end

    if string.len(current) ~= 0 then
        table.insert(ret, current)
    end

    return ret
end

function RuleSet:Trim(s)
     local from = s:match"^%s*()"
     return from > #s and "" or s:match(".*%S", from)
end

function RuleSet:LineToRule(line)
    local t = self:StrSplit(line, "->")
    local body = self:StrSplit(t[2], "|")
    for k, v in ipairs(body) do
        body[k] = self:StrSplitQuote(self:Trim(body[k]))
        for i, j in ipairs(body[k]) do
            body[k][i] = body[k][i]
        end
    end
    return t[1], body
end

function RuleSet:ToRules(str)
    local lines = self:ToLines(str)
    local rules = {}
    for _, v in ipairs(lines) do
        local head, body = self:LineToRule(v)
        head = self:Trim(head)
        rules[head] = body
    end
    return rules
end

function RuleSet:Expand(rule)
    local body = self.mRules[rule]

    if body == nil then
        return rule
    end

    -- choose a random expansion from the body
    local element = ShallowClone(body[math.random(#body)])
    for k, v in ipairs(element) do
        element[k] = self:Expand(v)
    end
    return table.concat(element)
end

function RuleSet:Run(start)
    return self:Expand(start)
end