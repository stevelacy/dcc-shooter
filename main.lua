function love.load()


	-- Image files loaded as static
	bgImg = love.graphics.newImage('textures/range.png')
	bgImgW, bgImgH = bgImg:getWidth(), bgImg:getHeight()

	scopeImg = love.graphics.newImage('textures/scope.png')
	scopeImgW,scopeImgH = scopeImg:getWidth(), scopeImg:getHeight()

	muzzleImg = love.graphics.newImage('textures/mflash.png')
	muzzleImgW,muzzleImgH = muzzleImg:getWidth(), muzzleImg:getHeight()

	bulletImg = love.graphics.newImage('textures/bullet.png')
	bulletImgW, bulletImgH = bulletImg:getWidth(), bulletImg:getHeight()

	pistolImg = love.graphics.newImage('textures/pistol_h.png')
	pistolImgW, pistolImgH = pistolImg:getWidth(), pistolImg:getHeight()

	targetImg = love.graphics.newImage('textures/target.png')
	targetImgW, targetImgH = targetImg:getWidth(), targetImg:getHeight()


	-- audio files:

	soundPistol = love.audio.newSource('audio/pistol.mp3')
	soundReload = love.audio.newSource('audio/reload.mp3')
	soundClang = love.audio.newSource('audio/clang.mp3')

	-- T is a table with the shot placement
	T = {}

	--variables preset
	toggleZoom = 0
	gunShoot = 0
	totalShots = 0
	reload = 0
	targetHit = 0

	-- The static mouse coordinate
	staticX = 0
	staticY = 1

	-- Target's x and y coordinates
	targetX = 650
	targetY = 350

	-- pistol's move animation on start and reload
	move = 400


end




function love.draw()  -- done 60 fps

-- preset all colors and textures as full color
love.graphics.setColor(255, 255, 255 , 255)
	

	if reload == 1 then   -- if letter r was clicked
		move = 400
		love.graphics.draw(pistolImg, mouseX - (pistolImgW*.4) , mouseY - (moveY - 30), 0, 1, 1)
		print('reloading')
		reload = 0
		totalShots = 0
		love.audio.play(soundReload)
	end	


	if	toggleZoom == 0 then  -- preset all textures and clear settings
		love.graphics.draw(bgImg, 0, 0, 0, .75 , .75)
		love.graphics.draw(targetImg, targetX, targetY+50, 0, .3, .3)
		move = 400
		love.mouse.setVisible(true)
		love.graphics.print('Right Click to start or reset', 600, 550)

	else
		love.mouse.setVisible(false)
		love.graphics.draw(bgImg, -bgImgW *.1, -bgImgH*.1, 0, .9 , .9)  -- zoom in the background
		love.graphics.draw(targetImg, targetX, targetY, 0, .5, .5) -- zoom in the target


		for k,v in pairs(T) do  -- for each x, y in the table T show the bullet icon
			love.graphics.setColor(255,255,255,255) 
			love.graphics.draw(bulletImg, v.x - (bulletImgW * .5), v.y - (bulletImgH * .5))
		end	

		

	love.graphics.setColor(255, 255, 255 , 255)

		if gunShoot == 1 and totalShots < 7 then  -- if mouse left button was clicked and total shots are less then 7
					love.graphics.draw(muzzleImg, mouseX - (muzzleImgW*.25) , mouseY - (muzzleImgH*.25), 0, .5, .5)
					love.audio.play(soundPistol)
					totalShots = totalShots + 1
					print(totalShots)
					gunShoot = 0

					if targetHit == 1 then -- if the target was hit play the sound
						love.audio.play(soundClang)
						targetHit = 0
					end


			elseif totalShots >= 7 then  -- if the mag is empty
				gunShoot = 0
			end -- end gunShoot



		love.graphics.draw(pistolImg, mouseX - (pistolImgW*.4) -3 , mouseY + (moveY - 30), 0, 1, 1) -- draw the gun img above other textures

	end	-- end toggleZoom


	
	love.graphics.setColor(255, 255, 0, 255) -- color for FPS and ammo
	love.graphics.print('Ammo:' .. (7 - totalShots), 50, 650)
	love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10) -- print the FPS

 
end



function gunMark(x,y) -- insert the bullet coordinate into the table T
	if totalShots < 7 then
		table.insert(T, {x = x, y = y})	
	end	
end	



function love.update(dt) -- delta time, this is the 'live' time

	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()

	move = move - (500 *dt) -- the gun move animation
	if move > 0 then
		moveY = move
	else
		moveY = 1	
	end	


end



function love.keypressed(key, code)

	if key == 'escape' then -- exit on escape click
		love.event.push('quit')
	end

	if key == 'r' then -- reload the mag
		reload = 1
	end

end



function love.mousepressed(x, y, button)

	if button == 'r' and toggleZoom == 0 then  -- if button is right mouse and toggle is 0
		toggleZoom = 1 -- toggle the zoom to true

	elseif button == 'l' and toggleZoom == 1 then  -- if left mouse was clicked, shoot and mark the bullets
		gunShoot = 1
		gunMark(x,y)
		staticX = x
		staticY = y

	  if x >= targetX and x < targetX + (targetImgW*.5)  -- if the target was hit
			and y >= targetY and y < targetY + (targetImgH*.5) then
					targetHit = 1
		end	  

	else	 -- clear all vars set by gunShoot, etc

		toggleZoom = 0	
		gunShoot = 0
		gunShootA = 0
		alpha = 0

		T = {}
	end

 

end

function love.quit()
	print('bye :)')
end
