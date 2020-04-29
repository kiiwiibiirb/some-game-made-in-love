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
	slink.x = love.graphics.getWidth() / 2
	slink.y = love.graphics.getHeight() / 2

	-- Slink's sprite
	slink = love.graphics.newImage('slink.png')

	-- Slink's speed
	slink.speed = 200

	-- Gravity and jumping.
	slink.ground = slink.y
	slink.y_velocity = 0
	slink.jump_height = -300
	slink.gravity = -500
end

function love.update(dt)
	if not joystick then return end

	-- Left and right on dpad = that direction of movement.
	if joystick:isGamepadDown('dpleft') then
		if slink.x > 0 then
			slink.x = slink.x - (slink.speed * dt)
		end
	elseif joystick:isGamepadDown('dpright') then
		if slink.x < (love.graphics.getWidth() - slink:getWidth()) then
			slink.x = slink.x + (slink.speed * dt)
		end
	end

	-- Pressing "A" will make Slink jump.
	if joystick:isGamepadDown('a') then
		if slink.y_velocity == 0 then
			slink.y_velocity = slink.jump_height
		end
	end

	-- Jump physics.
	if slink.y_velocity ~= 0 then
		slink.y = slink.y + slink.y_velocity * dt
		slink.y_velocity = slink.y_velocity - slink.gravity * dt
	end

	-- Making sure you don't fall through the floor, dunce.
	if slink.y > slink.ground then
		slink.y_velocity = 0
		slink.y = slink.ground
	end
end

function love.draw()
	-- Setting platform colour to purple because fuck you.
	love.graphics.setColor(128, 0, 128)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

	-- This draws Slink.
	love.graphics.draw(slink, slink.x, slink.y, 0, 1, 1, 0, 32)
end

function love.gamepadpressed(joystick, button)
	-- Pressing the minus button will quit the game, sucks if you don't have that button lol
	if button == 'select' then
		love.event.quit()
	end
end
