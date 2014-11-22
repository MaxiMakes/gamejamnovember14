local player = require 'player'
local control = require ("controlpoint")

function love.load()
  love.physics.setMeter(64) --the height of a meter our worlds will be 64px
  world = love.physics.newWorld(0, 0, true) --create a world for the bodies to exist in with 
  world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  --creating player
  player.new("player1", 100, 100)
  player.load()

  objects = {} -- table to hold all our physical objects

  --let's create a ball
  objects.ball = {}
  objects.ball.body = love.physics.newBody(world, 650/2, 650/2, "dynamic") --place the body in the center of the world and make it dynamic, so it can move around
  objects.ball.shape = love.physics.newCircleShape( 20) --the ball's shape has a radius of 20
  objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1) -- Attach fixture to body and give it a density of 1.
  --objects.ball.fixture:setRestitution(0.9) --let the ball bounce

  love.graphics.setBackgroundColor(104, 136, 248) --set the background color to a nice blue
  love.window.setMode(650, 650) --set the window dimensions to 650 by 650 with no fullscreen, vsync on, 

  -- test the control points 
  controlPoints = {}
  table.insert(controlPoints, control.new(650/2,650/2,10,10))
end

function love.update(dt)
  world:update(dt) --this puts the world into motion

  for i,v in ipairs(controlPoints) do
    v:update(dt)
  end
end

function love.draw()
  player.draw()
  love.graphics.print('Hello World!', 400, 300)
  love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

  for i,v in ipairs(controlPoints) do
    v:draw()
  end
end

function love.keypressed(key)
  if key == "escape" then
    love.event.quit()
  elseif(key == ' ') then
    player.move("player1", 500, 500)
  end
end

function beginContact(a, b, coll)
  for i,v in ipairs(controlPoints) do
    if a == v.fixture then
      v.beginContact(v, b, coll)
    elseif b == v.fixture then
      v.beginContact(v, a, coll)
    end
  end
end

function endContact(a, b, coll)
   for i,v in ipairs(controlPoints) do
    if a == v.fixture then
      v.endContact(v, b, coll)
    elseif b == v.fixture then
      v.endContact(v, a, coll)
    end
  end
end

function preSolve(a, b, coll)
   
end

function postSolve(a, b, coll, normalimpulse1, tangentimpulse1, normalimpulse2, tangentimpulse2)
   
end
