
# An interface-like class that can be used to generate new
# scene.

# Additionally, also contains the fundamental scenes.

class Scene
	def button_down(id); end
	def button_up(id); end
	
	def initialize
		@next_scene = nil
	end
	
	def get_next_scene
		return @next_scene
	end
	
	def update
		return false
	end
	
	def draw
	end
end

class LoadScene < Scene
	def initialize
		super
		@background = Gosu::Image.new($window, "./res/img/loading.png", true)
		@done = false
	end
	
	def update
		return @done
	end
	
	def get_next_scene
		return TitleScene.new
	end
	
	def draw
		@background.draw(0, 0, 0)
	
		Resource.image_load_manifest.each do |key, value|
			Resource.loaded_images[key] = Gosu::Image.new($window, value, true)
			#puts "#{key} loaded."
		end
	
		@done = true
	end
end

class TitleScene < Scene

	def initialize
		super
		@new_game_button = Button.new(250, 380, "New Game", 40)
		@quit_button = Button.new(250, 420, "Quitters' Mode", 40)
		@background = Gosu::Image.new($window, "./res/img/title.png", true)
		
		# Clear music
		if $window.cur_song != nil
			$window.cur_song.stop
			$window.cur_song = nil
		end
		
		# Clear data
		Resource.temp_vars.clear
		Resource.save_vars.clear
		
		@next_scene = nil
	end

	def update
		@new_game_button.update
		@quit_button.update
		
		if @quit_button.clicked?
			exit
		elsif @new_game_button.clicked?
			require './lib/rooms/first'
			@next_scene = FirstRoom.new
			return true
		end
		
		return false
	end
	
	def get_next_scene
		return @next_scene
	end
	
	def button_up(id)
		@quit_button.button_up(id)
		@new_game_button.button_up(id)
	end
	
	def button_down(id)
		@quit_button.button_down(id)
		@new_game_button.button_down(id)
	end
	
	def draw
		@background.draw(0,0,0)
		@new_game_button.draw
		@quit_button.draw
	end
end

class Room < Scene

	class Event
		def initialize(button, function)
			@button = button
			@function = function
		end
		
		attr_accessor :button, :function
	end

	def initialize
		super
		@background = nil
		@events = {}
		@left = false	# Representing whether the player has left the room or not.
		
		@foreground_color = Gosu::Color.argb(255, 0, 0, 0)
		@menu_color = Gosu::Color.new(255, 63, 100, 127)
		
		@quit_button = Button.new(10, 550, "Quit", 50)
	end
	
	# The scene manipulation function.
	
	def goto(nextSceneClass)
		@next_scene = nextSceneClass.new
		@left = true
	end
	
	def refresh
		@next_scene = self.class.new
		@left = true
	end
	
	def add_event(name, x, y, image, func)
		@events[name] = Room::Event.new(Button.new(x, y, image), func)
	end
	
	def update
		
		if @foreground_color.alpha > 0
			@foreground_color.alpha -= 5
		end
		
		@quit_button.update
		
		if @quit_button.clicked?
			@next_scene = TitleScene.new
			@left = true
		end
		
		@events.each do |k, e|
			e.button.update
			
			if e.button.clicked?
				if e.function != nil
					e.function.call
				end
			end
		end
		
		return @left
	end
	
	def button_up(id)
		@quit_button.button_up(id)
		@events.each do |k, e|
			e.button.button_up(id)
		end
	end
	
	def button_down(id)
		@quit_button.button_down(id)
		@events.each do |k, e|
			e.button.button_down(id)
		end
	end
	
	def draw
		if @background != nil
			@background.draw(0, 0, 0)
		end
	
		@events.each do |k, e|
			e.button.draw
		end

		$window.draw_quad(0, 550, @menu_color, 800, 550, @menu_color, 0, 600, @menu_color, 800, 600, @menu_color)
		@quit_button.draw
		
		if @foreground_color.alpha > 0
			$window.draw_quad(0, 0, @foreground_color, 800, 0, @foreground_color, 0, 600, @foreground_color, 800, 600, @foreground_color)
		end
	end

end