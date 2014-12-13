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
player.image = love.graphics.newImage("player.png")
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
  for i, v in ipairs(joysticks) do
    jcounter = i
  end
  --creates a player for each controller
  for i = 1 , jcounter, 1 do
    player.new("player"..i, 100+i*10, 100+i*10, i)
  end
end

function player:update(dt)
  for i, v in ipairs(players) do
      v.cursor:update(dt)
  end
end

function player.buy(p)
  if p.money >= minioncost then
    p.money = p.money - minioncost
    p.minions = p.minions + 1
  end
  if p.money < minioncost then
    print "not enough money to buy minions!"
  end
end

function player.new(pname, px , py, i)
  local newPlayer = {}
  setmetatable(newPlayer, player.mt)
  --old--
  player[pname] = {}
  table.insert(player.playernames, pname)
  --old--
  newPlayer.name = pname
  newPlayer.shape = love.physics.newCircleShape(player.radius)
  newPlayer.body = love.physics.newBody(world, px, py, "dynamic")
  newPlayer.fix = love.physics.newFixture(newPlayer.body, newPlayer.shape, player.density)
  newPlayer.body:setLinearDamping(5)
  newPlayer.money = player.money
  newPlayer.minions = player.minions
  newPlayer.color = colors[i]
  newPlayer.image = love.graphics.newImage("player.png")
  fixtureObjects[newPlayer.fix] = newPlayer


  --assings a free controller to a player
  for i, v in ipairs(joysticks) do
    if counter == i then
      newPlayer.joystick = v
    end
  end
  counter = counter + 1

  newPlayer.cursor = cursor.new(newPlayer)

  newPlayer.beginContact = function () end
  newPlayer.endContact = function () end

  table.insert(allObjects, newPlayer)
  table.insert(players, newPlayer)

  newPlayer.fix:setCategory(4)

  return newPlayer
end



function player.move(x ,y, p)
  p.body:applyForce(x, y)
end


function player.draw()
  for i, v in ipairs(players) do
    love.graphics.setColor(v.color)
    love.graphics.draw(player.image, v.body:getX() - player.image:getWidth()/2, v.body:getY() - player.image:getHeight()/2)
    v.cursor:draw()
    love.graphics.setColor(255,255,255)
  end
end

return player
