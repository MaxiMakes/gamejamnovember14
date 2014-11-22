local wall = {}
wall.mt = { __index = wall }

function wall.new(x,y,dx,dy,player)
  local x,y,dx,dy = round(x),round(y),round(dx),round(dy)

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

  local newRange = {}

  newRange.body = love.physics.newBody(world, new.body:getX(), new.body:getY()) 
  newRange.shape = love.physics.newCircleShape(math.max(dx,dy)*2)
  newRange.fixture = love.physics.newFixture(newRange.body, newRange.shape) --attach shape to body
  newRange.fixture:setSensor(true)


  fixtureObjects[newRange.fixture] = newRange
  fixtureObjects[new.fixture] = new
  table.insert(allObjects, new)

  return new
end

function wall:draw()
  love.graphics.setColor(self.player.color)
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
  love.graphics.setColor(255,255,255)

  for i = 1, self.minions do
    love.graphics.circle("fill", self.body:getX() + i*5, self.body:getY(), 5, 5)
  end
end

function wall.beginContact(a,b,coll)
end

function wall.endContact(a,b,coll)
end


return wall
