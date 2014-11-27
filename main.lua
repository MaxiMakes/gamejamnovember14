local player = require 'player'
local control = require 'controlpoint'
local cursor = require 'cursor'

function round(num, mult)
  mult = mult or 30
  return math.floor(num / mult + 0.5 ) * mult
end

fixtureObjects = {}
allObjects = {}

function love.load()
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  joysticks = love.joystick.getJoysticks( )

  walls = {}

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
  player.update(dt)
  for i,v in ipairs(controlPoints) do
    v:update(dt)
  end

  for i = 1, jcounter, 1 do
    jx , jy ,_,_ = player["player"..i].joystick:getAxes()

    if player["player"..i].joystick:isDown(3) then
      player.buy("player"..i)
    end
    player.move("player"..i, jx*player.speed*dt, jy*player.speed*dt)
  end

end

function love.draw()
  player.draw()

  for i,v in ipairs(controlPoints) do
    v:draw()
  end

  local joysticks = love.joystick.getJoysticks()
  for i, joystick in ipairs(joysticks) do
      love.graphics.print(joystick:getName(), 10, i * 20)
  end
  for i, v in ipairs(player.playernames) do
     love.graphics.print(player[v].money, 40, i*40)
     love.graphics.print(player[v].minions, 80, i*40)
  end

  for i,v in ipairs(walls) do
    v:draw()
  end

end

function love.keypressed(key, isrepeat)

  if key == "escape" then
    love.event.quit()
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
