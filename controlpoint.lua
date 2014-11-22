local control = {}
control.mt = { __index = control }

local takeoverSpeed = 10

local function defaultF(self)
  self.storage = self.storage + 10
  return self.storage
end

function control.new(x,y,dx,dy,f,interval)
  local newPoint = {}
  setmetatable(newPoint,control.mt)

  --TODO: masken machen, damit das ganze nur mit spieler kollidiert

  newPoint.storage = 0
  newPoint.t = 0
  newPoint.f = f or defaultF
  newPoint.interval = interval or 5
  newPoint.playersAround = {}
  newPoint.ownership = 0

  newPoint.body = love.physics.newBody(world, x+dx/2, y+dy/2)
  newPoint.shape = love.physics.newRectangleShape(dx, dy)
  newPoint.fixture = love.physics.newFixture(newPoint.body, newPoint.shape) --attach shape to body
  newPoint.fixture:setSensor(true)


  fixtureObjects[newPoint.fixture] = newPoint
  table.insert(allObjects,newPoint)

  return newPoint
end

function control:update(dt)
  --restock storage
  self.t = self.t + dt

  if self.t > self.interval then
    self.t = self.t - self.interval

    self:f()
  end

  --[[
  --react to players around
  if #self.playersAround == 1 then
    local p = self.playersAround[1]
    if p == self.owner then
      player.storage = self.storage
      self.storage = 0
    elseif p == self.newGuy then
      self.ownership = self.ownership + takeoverSpeed
      if self.ownership > 0 then
        self.owner = p
      end
    else
      self.newGuy = player
      self.ownership = takeoverSpeed
    end
  end
  --]]
  if #self.playersAround == 1 then
    self.playersAround[1].money = self.playersAround[1].money + self.storage
    self.storage = 0
  end
end

function control:draw()
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  love.graphics.print('Hello World!', self.body:getX()+10, self.body:getY()+10)
  love.graphics.print(self.storage, self.body:getX()+10, self.body:getY()+30)
  if self.owner then
    love.graphics.print('owner' .. self.owner, self.body:getX()+10, self.body:getY()+50)
  end
  love.graphics.print('spieler ' .. #self.playersAround, self.body:getX()+10, self.body:getY()+70)
end

function control:ownedBy(player)
  self.owner = player
end

function control:beginContact(b, coll)
  for i,v in ipairs(self.playersAround) do
    if v == b then
      return
    end
  end

  table.insert(self.playersAround,b)
end

function control:endContact(b, coll)
  for i,v in ipairs(self.playersAround) do
    if v == b then
      table.remove(self.playersAround,i)
    end
  end
end

return control
