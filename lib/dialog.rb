$LOAD_PATH << '.'

class DialogNode
	def button_down(id); end
	def button_up(id); end

	def update
		return true
	end

	def draw; end
end

class Speak < DialogNode

	def initialize(text)
		@text = text
		@text_image = nil
		@mouse_down = false
		@clicked = false
		
		@color = Gosu::Color.new(0, 255, 255, 255)
		@text_color = Gosu::Color.new(0, 63, 100, 127)
	end
	
	def button_down(id)
		@mouse_down = true
	end
	
	def button_up(id)
		if @mouse_down
			@clicked = true
		end
	end
	
	def update
		if @color.alpha < 255
			@color.alpha += 10
			@text_color.alpha += 10
		elsif @color.alpha > 255
			@color.alpha = 255
		end
		
		return @clicked
	end
	
	def draw
		if @text_image == nil
			@text_image = Gosu::Image.from_text($window, @text, "Arial", 25, 5, 680, :left) 
		end
	
		$window.draw_quad(0, 0, @color, 800, 0, @color, 0, @text_image.height + 20, @color, 800, @text_image.height + 20, @color)
		@text_image.draw(10, 10, 0, 1, 1, color=@text_color)
	end
end

class Alert < DialogNode

	def initialize(text)
		@text = text
		@text_image = nil
		@mouse_down = false
		@clicked = false
		
		@color = Gosu::Color.new(0, 63, 100, 127)
		@text_color = Gosu::Color.new(0, 255, 255, 255)
	end
	
	def button_down(id)
		@mouse_down = true
	end
	
	def button_up(id)
		if @mouse_down
			@clicked = true
		end
	end
	
	def update
		if @color.alpha < 255
			@color.alpha += 10
			@text_color.alpha += 10
		elsif @color.alpha > 255
			@color.alpha = 255
		end
		
		return @clicked
	end
	
	def draw
		if @text_image == nil
			@text_image = Gosu::Image.from_text($window, @text, "Arial", 25, 5, 500, :left) 
		end
	
		$window.draw_quad(0, 0, @color, 800, 0, @color, 0, @text_image.height + 20, @color, 800, @text_image.height + 20, @color)
		@text_image.draw(10, 10, 0, 1, 1, color=@text_color)
	end
end

class Background < DialogNode

	def initialize(image, dialog_branch)
		@dia_b = dialog_branch
	
		if image == nil
			@dia_b.bg_image = nil
			@dia_b.show_scene
		elsif image.is_a? String
			@dia_b.bg_image = Gosu::Image.new($window, image, true)
			@dia_b.hide_scene
		elsif image.is_a? Gosu::Image
			@dia_b.bg_image = image
			@dia_b.hide_scene
		end
		
		@dia_b.bg_color = Gosu::Color.new(0, 255, 255, 255)
	end
	
	def update
		if @dia_b.bg_image == nil
			return true
		end
	
		if @dia_b.bg_color.alpha < 255
			@dia_b.bg_color.alpha += 10
		elsif @dia_b.bg_color.alpha > 255
			@dia_b.bg_color.alpha = 255
		end
		return @dia_b.bg_color.alpha == 255
	end
end

class Decision < DialogNode
	def initialize(var_name, temp, choices)
		@var_name = var_name
		@temp = temp
		
		@buttons = []
		@buttons_text = []

		buttons_height = 0
		
		i = 0
		choices.each do |c|
			b = Button.new(100, i * 31, c)
			@buttons.push(b)
			i += 1
			buttons_height = i * 31
		end
		
		@buttons.each do |b|
			b.y = 300 - buttons_height / 2 + b.y
		end
		
		@box_y1 = @buttons[0].y - 10
		@box_y2 = @buttons[0].y + buttons_height + 10
		@box_color = Gosu::Color.new(255, 63, 100, 127)
	end
	
	def update

		i = 0
		@buttons.each do |b|
			b.update
			
			if b.clicked?
				if @temp
					Resource.temp_vars[@var_name] = i
				else
					Resource.save_vars[@var_name] = i
				end
				return true
			end
			
			i += 1
		end
		
		return false
	end
	
	def button_up(id)
		@buttons.each do |b|
			b.button_up(id)
		end
	end
	
	def button_down(id)
		@buttons.each do |b|
			b.button_down(id)
		end
	end
	
	def draw
		
		$window.draw_quad(0, @box_y1, @box_color, 800, @box_y1, @box_color, 0, @box_y2, @box_color, 800, @box_y2, @box_color)
		@buttons.each do |b|
			b.draw
		end
	end
end

class TextInput < DialogNode
	
	def initialize(var_name, temp, question)
		@var_name = var_name
		@temp = temp
	
		@question = question
		@question_image = Gosu::Image.from_text($window, question, "Arial", 35, 1, 600, :left)
		
		@text_area = Gosu::TextInput.new
		
		@text_area_image = Gosu::Image.from_text($window, "", "Arial", 28)
		@ok_button = Button.new(100, 0, "Done")
		
		$window.text_input = @text_area
		
		combined_heights = @question_image.height + @text_area_image.height + 60
		
		@question_image_y = 300 - (combined_heights + @question_image.height) / 2
		@text_area_image_y = 300 - (combined_heights) / 2  + 30
		@ok_button.y = 300 - (combined_heights) / 2 + @text_area_image.height + @ok_button.y + 50
		
		@box_y1 = @question_image_y - 10
		@box_y2 = @question_image_y + combined_heights + 10
		@box_color = Gosu::Color.new(255, 63, 100, 127)
		@text_area_color = Gosu::Color.new(255, 255, 255, 255)
	end
	
	def update
		@ok_button.update
		
		if @text_area.text.size > 15
			@text_area.text = @text_area.text[0..14]
		end
		
		@text_area_image = Gosu::Image.from_text($window, "" + @text_area.text, "Arial", 25)
		
		if @ok_button.clicked? or @enter_pressed
			$window.text_input = nil
			
			if @temp
				Resource.temp_vars[@var_name] = @text_area.text.strip
			else
				Resource.save_vars[@var_name] = @text_area.text.strip
			end
			
			return true
		end
		
		return false
	end
	
	def button_up(id)
		@ok_button.button_up(id)
	end
	
	def button_down(id)
		@ok_button.button_down(id)
	end
	
	def draw
		$window.draw_quad(0, @box_y1, @box_color, 800, @box_y1, @box_color, 0, @box_y2, @box_color, 800, @box_y2, @box_color)
		@question_image.draw(100, @question_image_y, 1)
		$window.draw_quad(100, @text_area_image_y - 2, @text_area_color, 500, @text_area_image_y - 2, @text_area_color, 100,
			@text_area_image_y + 32, @text_area_color, 500, @text_area_image_y + 32, @text_area_color)
		@text_area_image.draw(110, @text_area_image_y, 0, 1, 1, color=@box_color)
		@ok_button.draw
	end
end

class DialogBranch
	@@mouse_x = 0
	@@mouse_y = 0
	
	def mouse_x= v; @@mouse_x = v; end
	def mouse_y= v; @@mouse_y = v; end
	
	def button_down(id)
		if @index < @dialogs.size
			@dialogs[@index].button_down(id)
		end
	end
	
	def button_up(id)
		if @index < @dialogs.size
			@dialogs[@index].button_up(id)
		end
	end

	def initialize
		@dialogs = []
		@index = 0
		@next_branch = Proc.new { nil }
		@finished = false
		
		@bg_image = nil
		@bg_color = Gosu::Color.new(0, 255, 255, 255)
		@no_bg_color = Gosu::Color.new(0, 0, 0, 0)
		
		@hide_scene = false
	end
	
	attr_accessor :bg_image, :bg_color
	'''def bg_image; @bg_image; end
	def bg_image= v; @bg_image = v; end
	def bg_color; @bg_color;end
	def bg_color= v; @bg_color = v; end'''
	
	def hide_scene;
		@hide_scene = true 
	end
	
	def show_scene;
		@hide_scene = false 
	end
	
	def hide_scene?; @hide_scene; end
	
	def add(node)
		@dialogs.push(node)
	end
	
	def set_next_branch(branch_proc)
		@next_branch = branch_proc
	end
	
	def get_next_branch
		return @next_branch.call
	end
	
	def update
		if @index < @dialogs.size
			if @dialogs[@index].update
				@index += 1
			end
			return false
		end
		
		return true
	end
	
	def draw
		if @bg_image != nil
			@bg_image.draw(0, 0, 0, 1, 1, @bg_color)
		end
	
		if @index < @dialogs.size
			@dialogs[@index].draw
		end
	end
end

def get_d
	d = DialogBranch.new
	e = DialogBranch.new

	d.add(Background.new("./res/img/inuvik.png", d))
	d.add(TextInput.new("name", true, "Your name please!"))
	d.add(Decision.new("mudkip", true, ["Bring me mudkips!", "NO!!", "HI!"]))
	d.add(Alert.new("This is a new alert!"))
	d.add(Speak.new("HI! I am Cat."))
	d.add(Speak.new("Do you like me?"))
	d.add(Speak.new("..."))
	d.add(Speak.new("But I don't like you at all!"))

	#e.add(Background.new("./res/img/inuvik2.png", e))
	e.add(Background.new(nil, e))
	e.add(Speak.new("HI! I am Doge."))
	e.add(Speak.new("Do you like Doge?"))
	e.add(Speak.new("!!!"))
	e.add(Speak.new("But I don't like Doge at all!"))
	d.add(Alert.new("KTHXBAI!"))

	d.set_next_branch(Proc.new { e })
	return d
end