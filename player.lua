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
local minioncost = 1

jcounter = 0 --used to list the gamepads

local colors = {
  {255,0,0},
  {0,255,0},
  {0,0,255},
  {255,255,255}
}

function player.load()
  gr = love.graphics
  player.image = love.graphics.newImage("player.png")

  --counts the controller
  for i, v in ipairs(love.joystick.getJoysticks()) do
    jcounter = i
  end
  --creates a player for each controller
  for i = 1 , jcounter, 1 do
    player.new("player"..i, 100+i*10, 100+i*10, i)
  end
end

function player.update(dt)
  for i, v in ipairs(player.playernames) do
      player[v].cursor:update(dt)
  end
end
function player.buy(playername)
  if player[playername].money >= minioncost then
    player[playername].money = player[playername].money -minioncost
    player[playername].minions = player[playername].minions + 1
  end
  if player[playername].money < minioncost then
    print "not enough money to buy minion!"
  end
end

function player.new(pname, px , py, i)
  player[pname] = {}
  table.insert(player.playernames, pname)
  player[pname].name = pname
  player[pname].shape = love.physics.newCircleShape(player.radius)
  player[pname].body = love.physics.newBody(world, px, py, "dynamic")
  player[pname].fix = love.physics.newFixture(player[pname].body, player[pname].shape, player.density)
  player[pname].body:setLinearDamping(5)
  player[pname].money = player.money
  player[pname].minions = player.minions
  player[pname].color = colors[i]
  fixtureObjects[player[pname].fix] = player[pname]
  table.insert(allObjects,player[pname])

  --assings a free controller to a player
  for i, v in ipairs(love.joystick.getJoysticks()) do
    if counter == i then
      player[pname].joystick = v
    end
  end
  counter = counter + 1

  player[pname].cursor = cursor.new(player[pname])

  player[pname].beginContact = function () end
  player[pname].endContact = function () end

  return player[pname]
end



function player.move(name, x ,y)
  player[name].body:applyForce(x, y)

end


function player.draw()
  for i, v in ipairs(player.playernames) do
    love.graphics.setColor(player[v].color)
    love.graphics.draw(player.image, player[v].body:getX() - player.image:getWidth()/2, player[v].body:getY() - player.image:getHeight()/2)
    player[v].cursor:draw()
    love.graphics.setColor(255,255,255)
  end
end

return player
