local player = {}
--config
player.radius = 16
player.density = 1
player.playernames = {}

function player.load()
  gr = love.graphics
  player.image = love.graphics.newImage("player.png")

end

function player.update(dt)


end

function player.new(pname, px , py)
  player[pname] = {}
  table.insert(player.playernames, pname)
  player[pname].name = pname
  player[pname].shape = love.physics.newCircleShape(player.radius)
  player[pname].body = love.physics.newBody(world, px, py, "dynamic")
  player[pname].fix = love.physics.newFixture(player[pname].body, player[pname].shape, player.density)
  player[pname].body:setLinearDamping(5)
end

function player.move(name, x ,y)
  player[name].body:applyForce(x, y)

end


function player.draw()
  for i, v in ipairs(player.playernames) do
      love.graphics.draw(player.image, player[v].body:getX(), player[v].body:getY())
  end
end

return player
