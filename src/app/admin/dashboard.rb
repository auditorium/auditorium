ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  content :title => proc{ I18n.t("active_admin.dashboard") } do
    columns do
      column do
        panel "Recent Posts" do
          table_for Post.order('last_activity desc').limit(5) do 
            column 'Private?', :private do |post|
              if post.is_private 
                status_tag "Private", :info
              end 
            end
            column 'Answered?', :answer_to_id do |post| 
              if post.post_type.eql? 'question' 
                status_tag (post.answer_to_id.nil? ? "No" : "Yes"), (post.answer_to_id.nil? ? :error : :ok)
              end
            end
            column :subject do |post|
              link_to post.subject, [:admin, post]
            end
            column :body
            column :author
            column 'Type', :post_type
            column :last_activity
          end
          strong { link_to "View all posts", admin_posts_path }
        end
      end
    end

    columns do
      column do
        panel "Recent Feedback" do
          table_for Feedback.order('created_at desc').limit(10) do 
            column 'Read?', :read do |feedback|
              status_tag (feedback.read? ? "No" : "Yes"), (feedback.read? ? :error : :ok)
            end
            column :content do |feedback|
              link_to feedback.content, [:admin, feedback]
            end
            column :created_at
          end
        strong { link_to "View all feedbacks", admin_users_path }
        end
      end

      

      column do
        panel "Recent Users" do
          table_for User.order('created_at desc').limit(10) do 
            column 'Confirmed?', :confirmed do |user| 
              status_tag (user.confirmed? ? "Yes" : "No"), (user.confirmed? ? :ok : :error)
            end
            column :username do |user|
              link_to user.username, [:admin, user]
            end
            column :email
            column :first_name
            column :last_name
            
            column 'TU Dresden Email?', :tu_dresden do |user|
              status_tag ((user.email.match /tu-dresden.de$/) ? "Yes" : "No"), ((user.email.match /tu-dresden.de$/) ? :ok : :error)
            end 
            column :created_at
          end
          strong { link_to "View all users", admin_users_path }        

        end
      end
    end
  end 


  # section 'Recent Users',:priority => 1 do

  # end


end
