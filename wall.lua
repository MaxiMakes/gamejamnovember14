require 'util'
local sensor = require 'sensor'

local wall = {}
wall.mt = { __index = wall }
wall.cost = 10

function wall.new(x,y,dx,dy,player)
  local x,y,dx,dy = round(x),round(y),round(dx),round(dy)
  local blocks = (math.abs(dy)/10)*(math.abs(dx)/10)
  local cost = wall.cost*blocks

  if player.money >= cost then
    player.money = player.money - cost 
  else
    return nil
  end


  if dx < 0 then
    x = x + dx
    dx = -dx
  end
  if dy < 0 then
    y = y + dy
    dy = -dy
  end

  local new = {}
  setmetatable(new,wall.mt)

  new.body = love.physics.newBody(world, x+dx/2, y+dy/2, "static")
  new.shape = love.physics.newRectangleShape(dx, dy)
  new.fixture = love.physics.newFixture(new.body, new.shape) --attach shape to body
  fixtureObjects[new.fixture] = new
  table.insert(allObjects,new)

  new.hp = dx * dy
  new.player = player
  new.isWall = true
  new.minions = 0
  new.blocks = blocks
  new.timer = 0

  new.fixture:setCategory(2)

  local body = love.physics.newBody(world, new.body:getX(), new.body:getY(), "dynamic")
  local shape = love.physics.newCircleShape(math.max(dx,dy)*2)

  local newSensor = sensor.new(body, shape, function(x) return player ~= x.player end)

  newSensor.fixture:setCategory(5)

  newSensor.fixture:setMask(1,3, 5) -- do not shoot controllpoints or cursors or sensors

  newSensor.isSensor = true

  new.sensor = newSensor
  new.sensorShape = shape
  new.sensorBody = body

  fixtureObjects[newSensor.fixture] = newSensor
  table.insert(allObjects,newSensor)

  return new

end

function wall:draw()
  love.graphics.setColor(self.player.color)
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  love.graphics.circle("line", self.sensorBody:getX(), self.sensorBody:getY(), self.sensorShape:getRadius())
  love.graphics.setColor(255,255,255)

  for i = 1, self.minions do
    love.graphics.circle("fill", self.body:getX() + i*5, self.body:getY(), 5, 5)
  end

  love.graphics.print(count(self.sensor.inSensor), 200, 100)
end

function wall.beginContact(a,b,coll)
end

function wall.endContact(a,b,coll)
end

function wall:update(dt)
  self.timer = self.timer + dt

  if self.timer > 1 then
    self.timer = 0

    local n, k = next(self.sensor.inSensor)
    if n then
      n:getDamaged(1)
    end
  end
end

function wall:getDamaged(x)
  print("MAUER ATTACKIERT")
end

return wall
