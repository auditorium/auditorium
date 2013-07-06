class GroupsController < ApplicationController

	def index
		@groups = Group.order(:title)
	end
end
