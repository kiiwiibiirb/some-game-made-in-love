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

	-- Slink's sprite [STILL IMAGE]
	slink = love.graphics.newImage('sprites/slink/slink.png')

	-- Slink's Sprite [ANIMATED]
	-- This will be added in at a later date. I have no clue how to get this working lmao
	--animation = newAnimation(love.graphics.newImage("sprites/slink/slink.png"), 88, 104, 1)

	-- Slink's speed
	-- 200 is waaaaaay too slow, 500 is speedy as fuck and I like it that way.
	-- May actually turn it up to 750!
	player.speed = 500

	-- Gravity and jumping.
	player.ground = player.y
	player.y_velocity = 0
	-- Lower number = higher you jump
	player.jump_height = -500
	-- Gravity at -500 is like a feather falling.
	-- Lower number = faster fall rate
	player.gravity = -750

end

function love.update(dt)
	if not joystick then return end

	-- Left and right on dpad = that direction of movement.

	-- NOTE: Slink can go off screen. This needs to be fixed! (Also, this is the movement for the animated sprite)
	-- This will be added in at a later date. I have no clue how to get this working lmao
	--[[
	if joystick:isGamepadDown('dpleft') then
		player.x = player.x - (player.speed * dt)
	elseif joystick:isGamepadDown('dpright') then
		player.x = player.x + (player.speed * dt)
	end
	--]]

	-- This is left and right movement but it only works with the static sprite... (Don't ask me how I have no clue why.)
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

	-- Updates Slink's Sprite
	-- This will be added in at a later date. I have no clue how to get this working lmao
	--[[
	animation.currentTime = animation.currentTime + dt
	if animation.currentTime >= animation.duration then
		animation.currentTime = animation.currentTime - animation.duration
	end
	--]]
end

function love.draw()
	-- Setting platform colour to purple because fuck you.
	love.graphics.setColor(128, 0, 128)
	love.graphics.rectangle('fill', platform.x, platform.y, platform.width, platform.height)

	-- This draws Slink. [STATIC SPRITE]
	love.graphics.setColor(255, 255, 255)
	love.graphics.draw(slink, player.x, player.y, 0, 1, 1, 0, 0)

	-- This draws Slink. [ANIMATED SPRITE]
	-- This will be added in at a later date. I have no clue how to get this working lmao
	--[[
	local spriteNum = math.floor(animation.currentTime / animation.duration * #animation.quads) + 1
	love.graphics.draw(animation.spriteSheet, animation.quads[spriteNum], player.y, 0, 0, 4)
	--]]


	-- Setting the text colour to green.
	love.graphics.setColor(0, 255, 0)

	-- This is an indicator to tell you what to press to quit.
	love.graphics.print('Press + to exit.', 0, 688)

	-- This tells the version of what the game is at.
	love.graphics.print('VERSION 0.0.1 ALPHA')
end

-- Animation function for Slink's animated sprite [NOT NEEDED FOR STATIC SPRITE](obviously)
-- This will be added in at a later date. I have no clue how to get this working lmao
--[[
function newAnimation(image, width, height, duration)
	local animation = {}
	animation.spriteSheet = image;
	animation.quads = {};

	for y = 0, image:getHeight() - height, height do
		for x = 0, image:getWidth() - width, width do
			table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
		end
	end

	animation.duration = duration or 1
	animation.currentTime = 0

	return animation
end
--]]

function love.gamepadpressed(joystick, button)
	-- Pressing the minus button will quit the game, sucks if you don't have that button lol
	if button == 'start' then
		love.event.quit()
	end
end
