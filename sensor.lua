local sensor = {}
sensor.mt = { __index = sensor }

function sensor.new(body,shape,filter)
  local new = {}
  setmetatable(new, sensor.mt)

  new.body = body
  new.shape = shape
  new.fixture = love.physics.newFixture(body, shape) --attach shape to body
  new.fixture:setSensor(true)

  table.insert(allObjects,new)
  fixtureObjects[new.fixture] = new

  new.inSensor = {}

  new.filter = filter or function() return true end

  return new
end

function sensor:beginContact(b,coll)
  if self.filter(b) then
    self.inSensor[b] = true
  end
end

function sensor:endContact(b,coll)
  self.inSensor[b] = nil 
end

function sensor:getDamaged()
  print("Sensor attacked")
end

return sensor
