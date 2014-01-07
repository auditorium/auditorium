namespace :users do
  desc "Update last activity when nil"
  task :divide => :environment do
    User.all.each do |u|
      u.experimental_group = false
      u.save
    end
    a1 = User.all.sort {|x,y| x.activity_index <=> y.activity_index }.keep_if {|x| x.activity_index >= 5 }
    a2 = User.all.sort {|x,y| x.activity_index <=> y.activity_index }.keep_if {|x| x.activity_index < 5 }

    a1 = a1.shuffle
    a2 = a2.shuffle

    control_group = a1.take(a1.size * 0.5)
    control_group += a2.take(a2.size * 0.5)

    control_group.each do |u| 
      u.experimental_group = true
      u.save
    end

    c = User.where(experimental_group: false)
    e = User.where(experimental_group: true)

    puts "CONTROL GROUP (#{c.size}): #{c.inject(0) { |sum, u| sum + u.activity_index }}, EXPERIMENTAL GROUP (#{e.size}: #{e.inject(0) { |sum, u| sum + u.activity_index }}"


  end
end