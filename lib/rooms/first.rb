require 'gosu'
require './lib/scene'
require './lib/resource'

class FirstRoom < Room

	def initialize
		super
		
		@background = Gosu::Image.new($window, "./res/img/blackroom.png", true)
		
		@events[:left] = Room::Event.new(Button.new(100, 100, Resource.loaded_images[:leftnav]), lambda {
							self.goto(SecondRoom)
						})
						
		'''@events[:left] = Room::Event.new(Button.new(100, 100, Gosu::Image.new($window, "./res/img/leftnav.png", true)), lambda {
							self.goto(SecondRoom)
						})'''
						
		'''@events[:left] = Room::Event.new(Button.new(100, 100, "LEFT!"), lambda {
							goto(SecondRoom)
						})'''
	end
end

class SecondRoom < Room

	def initialize
		super
		
		@background = Gosu::Image.new($window, "./res/img/orangeroom.png", true)
	end
end