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

  new.hp = dx * dy
  new.player = player
  new.isWall = true
  new.minions = 0
  new.blocks = blocks

  local newRange = {}

  newRange.body = love.physics.newBody(world, new.body:getX(), new.body:getY())
  newRange.shape = love.physics.newCircleShape(math.max(dx,dy)*2)
  newRange.fixture = love.physics.newFixture(newRange.body, newRange.shape) --attach shape to body
  newRange.fixture:setSensor(true)

  new.inRange = {}

  function newRange.beginContact(b,coll)
    if not (b == new) then
      table.insert(new.inRange, b)
    end
  end

  function newRange.endContact(b,coll)
    for i,v in ipairs(new.inRange) do
      if v == b then
        table.remove(new.inRange,i)
        return
      end
    end
  end

  fixtureObjects[newRange.fixture] = newRange
  fixtureObjects[new.fixture] = new
  table.insert(allObjects, new)
  table.insert(allObjects, newRange)


  new.fixture:setCategory(2)
  newRange.fixture:setCategory(2)

  newRange.fixture:setMask(1,3) -- do not shoot controllpoints or cursors

  return new


end

function wall:draw()
  love.graphics.setColor(self.player.color)
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  love.graphics.setColor(255,255,255)

  for i = 1, self.minions do
    love.graphics.circle("fill", self.body:getX() + i*5, self.body:getY(), 5, 5)
  end

  love.graphics.print(#self.inRange, 200, 100)
end

function wall.beginContact(a,b,coll)
end

function wall.endContact(a,b,coll)
end


return wall
