print("WEREABLE OFF")
function Spawn(entityKeyValues)
  local wearables = {}
  local cur = thisEntity:FirstMoveChild() 

  while cur ~= nil do 
    cur = cur:NextMovePeer() 
    if cur ~= nil and cur:GetClassname() ~= "" and cur:GetClassname() == "dota_item_wearable" then 
      table.insert(wearables, cur) 
    end
  end
 
  for i = 1, #wearables do 
    UTIL_Remove(wearables[i]) 
  end
end