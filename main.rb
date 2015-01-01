$LOAD_PATH << '.'

require 'gosu'
require 'lib/resource'
require 'lib/ui'
require 'lib/scene'
require 'lib/dialog'

# The main class of the game.
class Game < Gosu::Window

	# The fundamental attributes:
	# - cur_dialog: The current dialog/cutscene in the game. It interrupts the scene.
	# - cur_scene: The current scene in the game.
	# - cur_song: The current background music.
	attr_accessor :cur_dialog, :cur_scene, :cur_song

	def initialize
		super(800, 600, false)	# Make so that the game's dimension is 800 x 600.
		self.caption = "Inuvik"
		
		# Change these lines at your own risk.
		$window = self
		@cur_scene = LoadScene.new
		@cur_dialog = nil
		@cur_song = nil
	end

	# The main game loop.
	def update
		
		if @cur_dialog != nil
			if @cur_dialog.update
				@cur_dialog = @cur_dialog.get_next_branch
			end
		else
			if @cur_scene != nil
				if @cur_scene.update
					@cur_scene = @cur_scene.get_next_scene
				end
			end
		end
	end

	def draw
		if @cur_dialog != nil
			if not @cur_dialog.hide_scene?
				if @cur_scene != nil 
					@cur_scene.draw
				end
			end
		
			@cur_dialog.draw
		else
			if @cur_scene != nil 
				@cur_scene.draw
			end
		end
	end
	
	# This function is to allow the cursor to appear on the screen.
	def needs_cursor?
		true
	end
	
	# Gosu's implement of button requires us to propagate button down event
	# to every component of the game.
	def button_down(id)
		if @cur_dialog != nil
			@cur_dialog.button_down(id)
		else
			if @cur_scene != nil
				@cur_scene.button_down(id)
			end
		end
	end
	
	# As well as button up.
	def button_up(id)
		if @cur_dialog != nil
			@cur_dialog.button_up(id)
		else
			if @cur_scene != nil
				@cur_scene.button_up(id)
			end
		end
	end
end

Game.new.show