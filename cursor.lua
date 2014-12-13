local wall = require 'wall'

local cursor = {}
cursor.mt = { __index = cursor }

local function placeWall(x,y,dx,dy, ...)
  if math.abs(round(dx)) > 0 and math.abs(round(dy)) > 0 then
    return wall.new(x,y,dx,dy, ...)
  end
end

function cursor.new(player)
  local newCursor = {}
  setmetatable(newCursor, cursor.mt)

  newCursor.player = player

  newCursor.body = love.physics.newBody(world, player.body:getX(), player.body:getY(), "dynamic")
  newCursor.body:setLinearDamping(10)
  newCursor.shape = love.physics.newCircleShape(10)
  newCursor.fixture = love.physics.newFixture(newCursor.body, newCursor.shape) --attach shape to body
  newCursor.fixture:setSensor(true)

  newCursor.startDragX = 0
  newCursor.startDragY = 0
  newCursor.endDragX = 0
  newCursor.endDragY = 0


  newCursor.isPlacingWall = false

  table.insert(allObjects, newCursor)
  fixtureObjects[newCursor.fixture] = newCursor

  newCursor.fixture:setCategory(3)
  newCursor.fixture:setMask(1,3,4) -- do not collide with controllpoints, cursors or players

  return newCursor
end

function cursor:update(dt)

  local j = self.player.joystick
  local _,_,dx,dy = j:getAxes()
  self.body:applyForce(dx*dt*10000,dy*dt*10000)


  self.endDragY = self.body:getY()
  self.endDragX = self.body:getX()

  if not j:isDown("b") then
    if self.isPlacingWall then
      local w = placeWall(self.startDragX, self.startDragY, self.endDragX - self.startDragX, self.endDragY - self.startDragY, self.player)
      if w then
        table.insert(walls,w)
      end

      self.isPlacingWall = false
    end

    self.startDragX = self.body:getX()
    self.startDragY = self.body:getY()
  else
    self.isPlacingWall = true
  end

  self:placeMinion(self.targetWall)

  -- später if love.physics.getDistance(self.fixture, self.player.fixture) > maxDistance then
end

function cursor:draw()
  love.graphics.setColor(5,24,255)
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), 10+5, 10+5)
  love.graphics.setColor(255,0,0)
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), 10, 10)
  love.graphics.rectangle("fill", round(self.startDragX), round(self.startDragY), round(self.endDragX-self.startDragX), round(self.endDragY-self.startDragY))
  love.graphics.print(self.player.joystick:getAxes())
end

function cursor:beginContact(b, coll)
  if b.isWall then
    self.targetWall = b
  end
end

function cursor:endContact(b, coll)
  if self.targetWall == b then
    self.targetWall = nil
  end
end

function cursor:placeMinion(wall)
  if wall and self.player.joystick:isDown("a") and self.player.minions > 0 and wall.blocks > wall.minions and wall.player == self.player then
    wall.minions = wall.minions + 1
    self.player.minions = self.player.minions -1
  end
end

return cursor
