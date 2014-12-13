local controller = {}

-- works like joystick
function controller.new(axes,a,b,c)
  local newController = {}

  function newController:isDown(x)
    if x == "a" then
      return a()
    elseif x == "b" then
      return b()
    elseif x == "c" then
      return c()
    end
  end

  newController.getAxes = axes

  return newController
end

-- takes keyboard keys as strings
function controller.newKeyboard(up,down,left,right,up2,down2,left2,right2,a,b,c)

  local k = love.keyboard.isDown

  function axes()
    local x,y,x2,y2 = 0,0,0,0

    if k(up) then
      y = -1
    end
    if k(down) then
      y = 1
    end
    if k(left) then
      x = -1
    end
    if k(right) then
      x = 1
    end
    if k(up2) then
      y2 = -1
    end
    if k(down2) then
      y2 = 1
    end
    if k(left2) then
      x2 = -1
    end
    if k(right2) then
      x2 = 1
    end

    return x,y,x2,y2
  end


  return controller.new(axes,function() return k(a) end, function() return k(b) end, function() return k(c) end)
end

return controller
