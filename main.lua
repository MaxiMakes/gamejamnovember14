local player = require 'player'
local control = require 'controlpoint'
local cursor = require 'cursor'
local controller = require 'controller'

function round(num, mult)
  mult = mult or 10
  return math.floor(num / mult + 0.5 ) * mult
end

fixtureObjects = {}
allObjects = {}

function love.load()
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  --joysticks = love.joystick.getJoysticks()
  print( controller.newKeyboard("up","down","left","right","w","s","a","d","y","x","c") )
  --function controller.newKeyboard(up,down,left,right,up2,down2,left2,right2,a,b,c)
  joysticks = { controller.newKeyboard("up","down","left","right","w","s","a","d","y","x","c") } 

  walls = {}
  players = {}

  --creating player

  player.load()


  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  love.window.setMode(650, 650) --set the window dimensions to 650 by 650 with no fullscreen, vsync on,

  -- test the control points
  controlPoints = {}
  table.insert(controlPoints, control.new(650/2,650/2,10,10))
end

function love.update(dt)
  world:update(dt) --this puts the world into motion
  player:update(dt)
  for i,v in ipairs(controlPoints) do
    v:update(dt)
  end

  for i,v in ipairs(walls) do
    v:update(dt)
  end
  --loop for player actions

  for i, v in ipairs(players) do
    jx , jy ,_,_ = v.joystick:getAxes()

    if v.joystick:isDown("c") then
      player.buy(v)
    end
    --[[
    if v.joystick:isDown("a") then
      v.cursor.body:setX(v.body:getX())
      v.cursor.body:setY(v.body:getY())
    end
    --]]
    player.move(jx*player.speed*dt, jy*player.speed*dt, v)
  end


end

function love.draw()

  local joysticks = love.joystick.getJoysticks()

  for i, joystick in ipairs(joysticks) do
      love.graphics.print(joystick:getName(), 10, i * 20)
  end

  for i, v in ipairs(players) do
     love.graphics.print("Player".. i .."'s'" .. "Money: " .. v.money, 40, i*10)
     love.graphics.print("Player".. i .."'s'" .. "Minions: " .. v.minions, 80, i*10+20)
  end
  --draw gameobjects

  for i,v in ipairs(walls) do
    v:draw()
  end
  for i,v in ipairs(controlPoints) do
    v:draw()
  end

  for i,v in ipairs(players) do
    player.draw()
  end



end

function love.keypressed(key, isrepeat)

  if key == "escape" then
    love.event.quit()
  end

  for i,v in ipairs(players) do

    if key == "right" then
      player.move(10*100,0,v)
    elseif key == "left" then
      player.move(-10*100,0,v)
    elseif key == "up" then
      player.move(0,-10*100,v)
    elseif key == "down" then
      player.move(0,10*100,v)
    end
  end
end

function beginContact(a, b, coll)
  local v = fixtureObjects[a]
  local w = fixtureObjects[b]
  v:beginContact(w,coll)
  w:beginContact(v,coll)
end

function endContact(a, b, coll)
  local v = fixtureObjects[a]
  local w = fixtureObjects[b]
  v:endContact(w,coll)
  w:endContact(v,coll)
end



function preSolve(a, b, coll)

end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)

end
