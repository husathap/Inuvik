require 'gosu'
require './lib/scene'
require './lib/resource'
require './lib/dialog'

class FirstRoom < Room

	def initialize
		super
		
		@background = Gosu::Image.new($window, "./res/img/blackroom.png", true)
		
		@guy1_image = Gosu::Image.new($window, "./res/img/guy1.png", true)
		
		# Play a new song
		#$window.cur_song = Gosu::Song.new($window, "./res/song/___")
		#$window.cur_song.play(true)
		
		if $window.cur_song != nil
			$window.cur_song.stop
			$window.cur_song = nil
		end
		
		if $cur_song != nil
			$cur_song.stop
			$cur_song = nil
		end
		
		add_event(:left, 40, 280, Resource.loaded_images[:leftnav], lambda {
				require "./lib/rooms/second"
				goto(SecondRoom)
			})
			
		if not Resource.temp_vars.key?(:guy_spoken)
			add_event(:guy, 200, 250, @guy1_image, lambda {
					d = DialogBranch.new
					d.speak("Max: Welcome to my Spartan house. I am Max!")
					d.speak("Max: Oh no! I must be going!")
					d.func(lambda {
						Resource.temp_vars[:guy_spoken] = true
						refresh
					})
					d.start
				})
		end
	end
end

