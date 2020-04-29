platform = {}
player = {}

function love.load()
	-- Get controller working in love.update
	local joysticks = love.joystick.getJoysticks()
	joystick = joysticks[1]

	-- Size of platform.
	platform.width = love.graphics.getWidth()
	platform.height = love.graphics.getHeight()

	-- Position of Platform.
	platform.x = 0
	platform.y = platform.height / 2

	-- Position of Slink
	player.x = love.graphics.getWidth() / 2
	player.y = love.graphics.getHeight() / 2

	-- Slink's sprite
	slink = love.graphics.newImage('slink.png')

	-- Slink's speed
	player.speed = 200

	-- Gravity and jumping.
	player.ground = player.y
	player.y_velocity = 0
	player.jump_height = -300
	player.gravity = -500
end

function love.update(dt)
	if not joystick then return end

	-- Left and right on dpad = that direction of movement.
	if joystick:isGamepadDown('dpleft') then
		if player.x > 0 then
			player.x = player.x - (player.speed * dt)
		end
	elseif joystick:isGamepadDown('dpright') then
		if player.x < (love.graphics.getWidth() - slink:getWidth()) then
			player.x = player.x + (player.speed * dt)
		end
	end

	-- Pressing "A" will make Slink jump.
	if joystick:isGamepadDown('a') then
		if player.y_velocity == 0 then
			player.y_velocity = player.jump_height
		end
	end

	-- Jump physics.
	if player.y_velocity ~= 0 then
		player.y = player.y + player.y_velocity * dt
		player.y_velocity = player.y_velocity - player.gravity * dt
	end

	-- Making sure you don't fall through the floor, dunce.
	if player.y > player.ground then
		player.y_velocity = 0
		player.y = player.ground
	end
end

function love.draw()
	-- Setting platform colour to purple because fuck you.
	love.graphics.setColor(128, 0, 128)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

	-- This draws Slink.
	love.graphics.draw(slink, player.x, player.y, 0, 1, 1, 0, 0)

	-- This is some FPS counter just to see how high it gets
	love.graphics,setColor(0, 255, 0) -- Colour is green because again, fuck you.
	love.graphics.print('FPS: ' .. love.timer.getFPS(), 0, 0)
end

function love.gamepadpressed(joystick, button)
	-- Pressing the minus button will quit the game, sucks if you don't have that button lol
	if button == 'start' then
		love.event.quit()
	end
end
