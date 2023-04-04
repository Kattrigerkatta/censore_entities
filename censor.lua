local Censor = {
    color = { 255, 255, 255, 255 }
}

function TableGetTableSort(tab)
	if type(tab) ~= 'table' then return false end
	local tablength = #tab
	local actualLength = Table.SizeOf(tab)

	if tablength ~= actualLength then
		return 'pairs'
	else
		return 'ipairs'
	end
end

function max(t, fn)
    if #t == 0 then return nil, nil end
    local key, value = 1, t[1]
    for i = 2, #t do
        if fn(value, t[i]) then
            key, value = i, t[i]
        end
    end
    return key, value
end

function round(num, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((num * power) + 0.5) / (power)
	else
		return math.floor(num + 0.5)
	end
end

function generateScreenCoords(tab)
    local nTab = {}

    for k, v in ipairs(tab) do
        local _, x, y  = GetScreenCoordFromWorldCoord(v.x, v.y, v.z)
        if _ then
            table.insert(nTab, { x = round(x, 2), y = round(y, 2) })
        end
    end

    return nTab
end

local link = "https://cdn.discordapp.com/attachments/919964850657050676/1092616560138518658/Verpixelt.png"
local dobj = CreateDui(link, 512, 512)
local RuntimeTXD = CreateRuntimeTxd('ve')
local txdHandle = GetDuiHandle(dobj)
local Textue = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'ves', txdHandle)

Citizen.CreateThread(function()
    while true do
        for k, v in ipairs(GetGamePool('CPed')) do
            if (#(GetEntityCoords(v) - GetEntityCoords(PlayerPedId()))) <= 15.0 and v ~= PlayerPedId() then
                local c = GetEntityCoords(v)
                local _, x, y = GetScreenCoordFromWorldCoord(c.x, c.y, c.z)
                if _ then
                    local fo, ri, up, pos = GetEntityMatrix(v)

                    local function g_e(ent, _ri, _fo, _up)
                        _ri = _ri/1.9
                        _fo = _fo/1.9
                        return GetOffsetFromEntityInWorldCoords(ent, _ri, _fo, _up)
                    end

                    -- top 4 --
                    local t_f_r, t_f_l, t_b_r, t_b_l = g_e(v, #ri, #fo, #up), g_e(v, -#ri, #fo, #up), g_e(v, #ri, -#fo, #up), g_e(v, -#ri, -#fo, #up)
                    local b_f_r, b_f_l, b_b_r, b_b_l = g_e(v, #ri, #fo, -#up), g_e(v, -#ri, #fo, -#up), g_e(v, #ri, -#fo, -#up), g_e(v, -#ri, -#fo, -#up)

                    local coords = { t_f_r, t_f_l, t_b_r, t_b_l, b_f_r, b_f_l, b_b_r, b_b_l }
                    local nCoords = generateScreenCoords(coords)

                    local _, m_left = max(nCoords, function(a, b) return a.x < b.x end)
                    local _, m_right = max(nCoords, function(a, b) return a.x > b.x end)
                    local _, m_top = max(nCoords, function(a, b) return a.y < b.y end)
                    local _, m_bottom = max(nCoords, function(a, b) return a.y > b.y end)

                    local n_height = m_bottom.y - m_top.y
                    local n_width = m_right.x - m_left.x
                    local n_x = m_left.x + (n_width)/2
                    local n_y = m_top.y + (n_height)/2

                    -- DRAW RECT CODE --
                    -- DrawRect(n_x, n_y, n_width, n_height, Censor.color[1], Censor.color[2], Censor.color[3], Censor.color[4])

                    -- DRAW TEXTURE CODE --
                    DrawSprite('ve', 'ves', n_x, n_y, n_width, n_height, 0.0, 255, 255, 255, 255)
                end
            end
        end
        Citizen.Wait(0)
    end
end)
