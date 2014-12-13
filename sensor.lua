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

  return new
end

function sensor:beginContact(b,coll)
end

function sensor:endContact(b,coll)
end

return sensor
