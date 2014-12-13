local sensor = {}
sensor.mt = { __index = sensor }

function sensor.new(body,shape)
  local new = {}
  setmetatable(new, sensor.mt)

  new.body = body
  new.shape = shape
  new.fixture = love.physics.newFixture(body, shape) --attach shape to body
  new.fixture:setSensor(true)

  table.insert(allObjects,new)
  fixtureObjects[new.fixture] = new

  new.inSensor = {}

  return new
end

function sensor:beginContact(b,coll)
  self.inSensor[b] = true
end

function sensor:endContact(b,coll)
  self.inSensor[b] = nil 
end

return sensor
