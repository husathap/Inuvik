# These shall be the only global variables in the system!

module Resource

	# Edit this list to get more pre_loaded images in the game.
	@image_load_manifest = {
		:leftnav => "./res/img/leftnav.png",
		:rightnav => "./res/img/rightnav.png"
	}
	
	# The loaded images are stored here.
	@loaded_images = {}
	
	# In-game variables.
	@temp_vars = {}
	@save_vars = {}

	module_function

	def image_load_manifest; @image_load_manifest; end
	
	def loaded_images; @loaded_images; end
	def loaded_images= v; @loaded_images = v; end
	
	def temp_vars; @temp_vars; end			# Temporary variables that won't be saved.
	def temp_vars= v; @temp_vars = v; end
	
	def save_vars; @save_vars; end			# Permanent variables that will be saved.
	def save_vars= v; @save_vars = v; end
end