ActiveAdmin.register Post do
	scope :not_answered

	index do
		column :id
		column :author
		column "Type", :post_type
		column :subject
		column :body
		column :last_activity
		column "Origin", :parent do |post|
			strong { link_to post.origin.id, post.origin }
		end
		default_actions
	end
end
