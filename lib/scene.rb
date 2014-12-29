
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
			puts "#{key} loaded."
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
			
			@to_remove = false
		end
		
		attr_accessor :button, :function, :to_remove
	end

	def initialize
		super
		@background = nil
		@events = {}
		@left = false	# Representing whether the player has left the room or not.
	end
	
	# The scene manipulation function.
	
	def goto(nextSceneClass)
		@next_scene = nextSceneClass.new
		@left = true
	end
	
	'''def add_event(name, event)
		@events[name] = event
	end
	
	def remove_event(name)
		@events[name].to_remove = true
	end
	
	def change_button(name, new_button)
		@events[name].button = new_button
	end
	
	def goto(next_scene)
		@next_scene = next_scene
		@left = true
	end'''
	
	# TEST
	#
	# room.add_event(:gaga, Button.new('gaga', 100, 100), lambda { |room|
	#	room.background = taylor_swift
	#	return true })
	
	def update
		del_list = []
		
		@events.each do |k, e|
			e.button.update
			
			if e.button.clicked?
				if e.function != nil
					e.function.call
				end
			end
				
			if e.to_remove
				del_list.push(k)
			end
		end
			
		del_list.each do |k|
			@events.delete(k)
		end
		
		return @left
	end
	
	def button_up(id)
		@events.each do |k, e|
			e.button.button_up(id)
		end
	end
	
	def button_down(id)
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
	end

end