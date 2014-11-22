local cursor = require 'cursor'
local player = {}
--config
player.radius = 16
player.density = 1
player.playernames = {}
player.money = 100
player.minions = 10
player.speed = 10000
local counter = 1
jcounter = 0

function player.load()
  gr = love.graphics
  player.image = love.graphics.newImage("player.png")
  for i, v in ipairs(love.joystick.getJoysticks()) do
    jcounter = i

  end
  for i = 1 , jcounter, 1 do
    player.new("player"..i, 100, 100)
  end
end

function player.update(dt)
  for i, v in ipairs(player.playernames) do
      player[v].cursor:update(dt)
  end
end

function player.new(pname, px , py)
  player[pname] = {}
  table.insert(player.playernames, pname)
  player[pname].name = pname
  player[pname].shape = love.physics.newCircleShape(player.radius)
  player[pname].body = love.physics.newBody(world, px, py, "dynamic")
  player[pname].fix = love.physics.newFixture(player[pname].body, player[pname].shape, player.density)
  player[pname].body:setLinearDamping(5)
  player[pname].money = player.money
  player[pname].minions = player.minions

  for i, v in ipairs(love.joystick.getJoysticks()) do
    if counter == i then
      player[pname].joystick = v
    end
  end
  counter = counter + 1

  player[pname].cursor = cursor.new(player[pname])

  return player[pname]
end



function player.move(name, x ,y)
  player[name].body:applyForce(x, y)

end


function player.draw()
  for i, v in ipairs(player.playernames) do
      love.graphics.draw(player.image, player[v].body:getX() - player.image:getWidth()/2, player[v].body:getY() - player.image:getHeight()/2)
      player[v].cursor:draw()
  end
end

return player
