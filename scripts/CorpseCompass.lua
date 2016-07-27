require '/stats/player_primary.lua'

old_init = init
old_applyDamageRequest = applyDamageRequest

function init()
  old_init()
  self.lastDeathPosition = {0,0}
  sb.logInfo("CorpseCompass: init")
end

function applyDamageRequest(damageRequest)
  result = old_applyDamageRequest(damageRequest)
  
  if result[1] == nil then
	return result
  end
  -- sb.logInfo("Player is on %s", player.worldId())

  if result[1]["killed"] then
    self.lastDeathPosition = result[1]["position"]
    local underground = world.underground(self.lastDeathPosition)
	
    sb.logInfo("CorpseCompass: Player %s died %s at %s, %s", world.entityName(entity.id()), (underground and "underground" or "above ground"), tostring(self.lastDeathPosition[1]), tostring(self.lastDeathPosition[2]))
  -- elseif result[1]["healthLost"] > 0.0 then
    -- sb.logInfo(dump(result))
	-- sb.logInfo("%s was hit for %s but did not die", world.entityName(entity.id()), tostring(result[1]["healthLost"]))
  end

  return result
end


-- Dumps value as a string closely resemling Lua code that could be used to
-- recreate it (with the exception of functions, threads and recursive tables).
--
-- Basic usage: dump(value)
--
-- @param value The value to be dumped.
-- @param indent (optional) String used for indenting the dumped value.
-- @param seen (optional) Table of already processed tables which will be
--                        dumped as "{...}" to prevent infinite recursion.
-- from mrmagical at http://pastebin.com/M7Nmpg0T
function dump(value, indent, seen)
  if type(value) ~= "table" then
    if type(value) == "string" then
      return string.format('%q', value)
    else
      return tostring(value)
    end
  else

    --value = pairsByKeys(value)
    if type(seen) ~= "table" then
      seen = {}
    elseif seen[value] then
      return "{...}"
    end
    seen[value] = true
    indent = indent or ""
    if next(value) == nil then
      return "{}"
    end
    local str = "{"
    local first = true
    for k,v in pairs(value) do
      if first then
        first = false
      else
        str = str..","
      end
      str = str.."\n"..indent.."  ["..dump(k).."] = "..dump(v, indent.."  ")
    end
    str = str.."\n"..indent.."}"
    return str
  end
end

