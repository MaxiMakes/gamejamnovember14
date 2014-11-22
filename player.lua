local player = {}
--config
player.radius = 16
player.density = 1


function player.load()
  gr = love.graphics
  player.image = love.image.newImageData("player.png")

end

function player.update(dt)


end

function player.new(px , py, pname)
  player[pname] = {}
  player[pname].name = pname
  player[pname].shape = love.physics.newCircleShape(player.radius)
  player[pname].body = love.physics.newBody(world, px, py, "dynamic")
  player[pname].fix = love.physics.newFixture(player[pname]body, player[pname]shape, player.density)

end

function player.(name, x ,y)
  player[name].body.applyForce(x, y)
  
end


function player.draw()
  for i, v in ipars(player.name)
      gr.draw(player.image, player[v].body.getX, player[v].body.getY)
  end
end
