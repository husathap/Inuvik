require 'gosu'
require './lib/scene'
require './lib/resource'
require './lib/dialog'

class SecondRoom < Room

	def initialize
		super
		
		# Pre-Entrance Dialog definition
		
		d = DialogBranch.new
		
		d.alert("Welcome to Sally's room!")
		d.start
		
		# Play a new song
		#$window.cur_song = Gosu::Song.new($window, "./res/song/___")
		#$window.cur_song.play(true)
		
		# Set up the background
		@background = Gosu::Image.new($window, "./res/img/orangeroom.png", true)
		
		# Load temporary resource.
		@girl1_image = Gosu::Image.new($window, "./res/img/girl1.png", true)
		
		# Adding events.
		add_event(:right, 720, 280, Resource.loaded_images[:rightnav], lambda {
				require './lib/rooms/first'
				goto(FirstRoom)
			})
			
		add_event(:girl, 500, 250, @girl1_image, lambda {
					d = DialogBranch.new
					
					if not Resource.temp_vars.key?(:guy_spoken)
						d.speak("Sally: Hi! My name is Sally. I am Max's more mature sister.")
						d.play_song("./res/song/boss.ogg")
						d.speak("Sally: My scatterbrained brother should be somewhere else right now, but he forgets.")
						d.speak("Sally: Could you remind him?")
						d.alert("Uh oh! You should remind Max!")
						d.stop_song
					else
						d.speak("Sally: I see. My brother's gone. Thanks for reminding him.")
					end
					d.start
				})
	end
end