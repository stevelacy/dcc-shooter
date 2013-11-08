function love.conf(c)

	c.title = '#DCC13 Lua game'
	c.author = 'S.Lacy = slacy.me'
	c.github = ' https://github.com/stevelacy/dcc-shooter'
	c.screen.height = 800
	c.screen.width = 1422

	c.modules.audio = true
	c.modules.sound = true

	c.modules.mouse = true
	c.modules.keyboard = true

	c.modules.graphics = true
	c.modules.event = true
	c.modules.timer = true
	
	c.modules.thread = true
	c.modules.physics = true

end	