$LOAD_PATH << '.'

require 'gosu'

require 'lib/resource'
require 'lib/ui'


require 'lib/scene'
require 'lib/dialog'


class Game < Gosu::Window

	attr_accessor :cur_dialog, :cur_scene

	def initialize
		super 800, 600, false
		self.caption = "Gosu Tutorial Game"
		
		$window = self

		@cur_scene = LoadScene.new
		@cur_dialog = nil
	end

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
	
	def needs_cursor?
		true
	end
	
	def button_down(id)
		if @cur_dialog != nil
			@cur_dialog.button_down(id)
		else
			if @cur_scene != nil
				@cur_scene.button_down(id)
			end
		end
	end
	
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