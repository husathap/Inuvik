# Button file!

class Button

	def initialize(x, y, text_or_image, size=30)
		@x = x
		@y = y
		
		@color = Gosu::Color.argb(255, 255, 255, 255)
		@over_color = Gosu::Color.argb(255, 255, 255, 0)
		
		if text_or_image.is_a? String
			@text_image = Gosu::Image.from_text($window, text_or_image, "Arial", size)
		else
			@text_image = text_or_image
			@color = Gosu::Color.argb(255, 255, 255, 255)
			@over_color = Gosu::Color.argb(255, 255, 255, 0)
		end if
		
		@cur_color = @color

		@downed = false
		@clicked = false
	end
	
	attr_accessor :x, :y

	
	# Update function is only used to update the overlay color.
	def update
	
		if $window.mouse_x >= @x and $window.mouse_x <= @x + @text_image.width and \
		   $window.mouse_y >= @y and $window.mouse_y <= @y + @text_image.height
			@cur_color = @over_color
		else
			@cur_color = @color
		end
	end
	
	# Check if the key is down on the button or not.
	def button_down(id)
		case id
		when Gosu::MsLeft
			@downed = $window.mouse_x >= @x and $window.mouse_x <= @x + @text_image.width and \
				      $window.mouse_y >= @y and $window.mouse_y <= @y + @text_image.height
		end
	end
	
	# Check if the button is clicked or not.
	def button_up(id)
		case id
		when Gosu::MsLeft
			if @downed and $window.mouse_x >= @x and $window.mouse_x <= @x + @text_image.width and \
			   $window.mouse_y >= @y and $window.mouse_y <= @y + @text_image.height
				@clicked = true
				@downed = false
			end
		end
	end
	
	# Get whether the button is clicked upon or not.
	def clicked?
		if @clicked
			@clicked = false
			return true
		else
			return false
		end
	end
	
	# Draw the button.
	def draw
		@text_image.draw(@x, @y, 0, 1, 1, color=@cur_color)
	end
end