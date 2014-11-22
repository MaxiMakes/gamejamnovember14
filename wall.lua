local wall = {}
wall.mt = { __index = wall }

function wall.new(x,y,dx,dy,player)
  local x,y,dx,dy = round(x),round(y),round(dx),round(dy)

  local new = {}
  setmetatable(new,wall.mt)

  new.body = love.physics.newBody(world, x+dx/2, y+dy/2) 
  new.shape = love.physics.newRectangleShape(dx, dy)
  new.fixture = love.physics.newFixture(new.body, new.shape) --attach shape to body

  new.hp = dx * dy
  new.player = player

  local newRange = {}

  newRange.body = love.physics.newBody(world, new.body:getX(), new.body:getY()) 
  newRange.shape = love.physics.newCircleShape(math.max(dx,dy)*2)
  newRange.fixture = love.physics.newFixture(newRange.body, newRange.shape) --attach shape to body
  newRange.fixture:setSensor(true)

  return new
end

function wall:draw()
  love.graphics.polygon("fill", self.body:getWorldPoints(self.shape:getPoints()))
end

function wall.beginContact(self, b, coll)
end

function wall.endContact(self, b, coll)
end

return wall
