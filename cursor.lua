local wall = require 'wall'

local cursor = {}
cursor.mt = { __index = cursor }

local function placeWall(x,y,dx,dy)
  if math.abs(round(dx)) > 0 and math.abs(round(dy)) > 0 then
    return wall.new(x,y,dx,dy)
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

  return newCursor
end

function cursor:update(dt)
  local j = self.player.joystick
  local _,_,dx,dy = j:getAxes() 
  self.body:applyForce(dx*dt*10000,dy*dt*10000)


  self.endDragY = self.body:getY()
  self.endDragX = self.body:getX()

  if not j:isDown(8) then
    if isPlacingWall then
      local w = placeWall(self.startDragX, self.startDragY, self.endDragX - self.startDragX, self.endDragY - self.startDragY, self.player)
      if w then
        table.insert(walls,w)
      end

      isPlacingWall = false
    end

    self.startDragX = self.body:getX()
    self.startDragY = self.body:getY()
  else
    isPlacingWall = true
  end

  -- späta if love.physics.getDistance(self.fixture, self.player.fixture) > maxDistance then
end

function cursor:draw()
  love.graphics.circle("fill", self.body:getX(), self.body:getY(), 10, 10) 
  love.graphics.rectangle("fill", round(self.startDragX), round(self.startDragY), round(self.endDragX-self.startDragX), round(self.endDragY-self.startDragY))
  love.graphics.print(self.player.joystick:getAxes())
end

return cursor
