function ShallowClone(t)
    local clone = {}
    for k, v in pairs(t) do
        clone[k] = v
    end
    return clone
end