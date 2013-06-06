# coding: UTF-8
# Important Note: This command has to run on each fresh machine or on a server.

namespace :birkman_workenv_questions do
    desc "Populate birkman workenv questions for Employer and JobSeekers"
    task(:data=> :environment) do
 
        def populate_workenv_questions
          ActiveRecord::Base.connection.tables.each do |table|
            ActiveRecord::Base.connection.execute("TRUNCATE workenv_questions")
          end
                ques_arr = [
                    #questions for JobSeeker
                    {:question=>"TO FIND APPROPRIATE VENUES, YOU...",:xscoring=>"NEG",:yscoring=>"NEG", :description_left => "brainstorm with the group.", :description_right => "determine options based upon budget and estimated guest list.", :for_emp => 0},

                    {:question=>"TO CHOOSE BETWEEN VENUES, YOU...",:xscoring=>"NEG",:yscoring=>"POS", :description_left => "discuss available venues and work to reach consensus.", :description_right => "book what seems to be the best option and inform everyone.", :for_emp => 0},

                    {:question=>"TO EXECUTE THE SURPRISE PLAN, YOU...",:xscoring=>"POS",:yscoring=>"POS", :description_left => "give people specific tasks to complete.", :description_right => "call people to find out how they would like to participate.", :for_emp => 0},

                    {:question=>"YOU'RE HANDED THE INVITE LIST, YOU",:xscoring=>"NEG",:yscoring=>"no", :description_left => "send out an invite ASAP and monitor the RSVPs.", :description_right => "have people over to create and send personal invitations.", :for_emp => 0},

                    {:question=>"TO GET SNACKS FOR 100 PEOPLE, YOU...",:xscoring=>"POS",:yscoring=>"NEG", :description_left => "plan a menu and ask guests to volunteer to cook specific dishes.", :description_right => "determine how best to spend the budget given the estimated number of people.", :for_emp => 0},

                    {:question=>"THE VENUE LACKS CHARACTER, YOU...",:xscoring=>"POS",:yscoring=>"no", :description_left => "create decorations and set-up the venue together.", :description_right => "come up with a budget and hire a company to decorate the venue.", :for_emp => 0},

                    {:question=>"TO PICK MUSIC FOR THE PARTY, YOU...",:xscoring=>"NEG",:yscoring=>"POS", :description_left => "find, negotiate with and hire the right DJ or do it yourself.", :description_right => "create a group playlist, share it online and let people vote on songs.", :for_emp => 0},

                    {:question=>"SO THAT THINGS GO ACCORDING TO PLAN, YOU...",:xscoring=>"POS",:yscoring=>"POS", :description_left => "call everyone to confirm details.", :description_right => "put together a detailed email and send it to everyone on the list.", :for_emp => 0},

                    {:question=>"WE FORGOT THE CAKE!!! YOU...",:xscoring=>"POS",:yscoring=>"NEG", :description_left => "get the group together and figure out a way to get a custom cake in two hours.", :description_right => "find the closest bakery and get a cake, even if it isn't a perfect cake for the occasion.", :for_emp => 0},

                    {:question=>"TO SEND PICS FROM THE PARTY, YOU...",:xscoring=>"NEG",:yscoring=>"NEG", :description_left => "quickly post pictures online so that they are available immediately.", :description_right => "take the time to create an online slideshow and send it out a week later.", :for_emp => 0},

                    ################ for employer
                    {:question=>"the use of facts and data for decision making?",:xscoring=>"NEG",:yscoring=>"NEG", :description_left => "brainstorm with the group.", :description_right => "determine options based upon budget and estimated guest list.", :for_emp => 1},

                    {:question=>"taking immediate action on concrete issues?",:xscoring=>"NEG",:yscoring=>"POS", :description_left => "discuss available venues and work to reach consensus.", :description_right => "book what seems to be the best option and inform everyone.", :for_emp => 1},

                    {:question=>"solutions focused customer's interest and experience?",:xscoring=>"POS",:yscoring=>"POS", :description_left => "give people specific tasks to complete.", :description_right => "call people to find out how they would like to participate.", :for_emp => 1},

                    {:question=>"completing tasks efficiently?",:xscoring=>"NEG",:yscoring=>"no", :description_left => "send out an invite ASAP and monitor the RSVPs.", :description_right => "have people over to create and send personal invitations.", :for_emp => 1},

                    {:question=>"freedom in managing work objectives?",:xscoring=>"POS",:yscoring=>"NEG", :description_left => "plan a menu and ask guests to volunteer to cook specific dishes.", :description_right => "determine how best to spend the budget given the estimated number of people.", :for_emp => 1},

                    {:question=>"the growth and development of employees?",:xscoring=>"POS",:yscoring=>"no", :description_left => "create decorations and set-up the venue together.", :description_right => "come up with a budget and hire a company to decorate the venue.", :for_emp => 1},

                    {:question=>"accountability to produce results?",:xscoring=>"NEG",:yscoring=>"POS", :description_left => "find, negotiate with and hire the right DJ or do it yourself.", :description_right => "create a group playlist, share it online and let people vote on songs.", :for_emp => 1},

                    {:question=>"being adaptable to changing work situations?",:xscoring=>"POS",:yscoring=>"POS", :description_left => "call everyone to confirm details.", :description_right => "put together a detailed email and send it to everyone on the list.", :for_emp => 1},

                    {:question=>"complex problem solving to achieve goals?",:xscoring=>"POS",:yscoring=>"NEG", :description_left => "get the group together and figure out a way to get a custom cake in two hours.", :description_right => "find the closest bakery and get a cake, even if it isn't a perfect cake for the occasion.", :for_emp => 1},

                    {:question=>"consistent workflow and standardized procedures?",:xscoring=>"NEG",:yscoring=>"NEG", :description_left => "quickly post pictures online so that they are available immediately.", :description_right => "take the time to create an online slideshow and send it out a week later.", :for_emp => 1}

                    ]

                  ques_arr.each_with_index{|ques,i|
                    ques.update({:order=> (i + 1)})
                    WorkenvQuestion.create(ques)
                  }
        end
       populate_workenv_questions
    
    end

end



=begin
namespace :birkman_workenv_questions do
    desc "Populate birkman workenv questions"
    task(:data=> :environment) do


        def populate_workenv_questions
          ActiveRecord::Base.connection.tables.each do |table|
            ActiveRecord::Base.connection.execute("TRUNCATE workenv_questions")
          end
                ques_arr = [
                    {:question=>"TO FIND APPROPRIATE VENUES, YOU...",:xscoring=>"NEG",:yscoring=>"NEG", :description_left => "brainstorm with the group.", :description_right => "determine options based upon budget and estimated guest list."},

                    {:question=>"TO CHOOSE BETWEEN VENUES, YOU...",:xscoring=>"NEG",:yscoring=>"POS", :description_left => "discuss available venues and work to reach consensus.", :description_right => "book what seems to be the best option and inform everyone."},

                    {:question=>"TO EXECUTE THE SURPRISE PLAN, YOU...",:xscoring=>"POS",:yscoring=>"POS", :description_left => "give people specific tasks to complete.", :description_right => "call people to find out how they would like to participate."},

                    {:question=>"YOU'RE HANDED THE INVITE LIST, YOU",:xscoring=>"NEG",:yscoring=>"no", :description_left => "send out an invite ASAP and monitor the RSVPs.", :description_right => "have people over to create and send personal invitations."},

                    {:question=>"TO GET SNACKS FOR 100 PEOPLE, YOU...",:xscoring=>"POS",:yscoring=>"NEG", :description_left => "plan a menu and ask guests to volunteer to cook specific dishes.", :description_right => "determine how best to spend the budget given the estimated number of people."},

                    {:question=>"THE VENUE LACKS CHARACTER, YOU...",:xscoring=>"POS",:yscoring=>"no", :description_left => "create decorations and set-up the venue together.", :description_right => "come up with a budget and hire a company to decorate the venue."},

                    {:question=>"TO PICK MUSIC FOR THE PARTY, YOU...",:xscoring=>"NEG",:yscoring=>"POS", :description_left => "find, negotiate with and hire the right DJ or do it yourself.", :description_right => "create a group playlist, share it online and let people vote on songs."},

                    {:question=>"SO THAT THINGS GO ACCORDING TO PLAN, YOU...",:xscoring=>"POS",:yscoring=>"POS", :description_left => "call everyone to confirm details.", :description_right => "put together a detailed email and send it to everyone on the list."},

                    {:question=>"WE FORGOT THE CAKE!!! YOU...",:xscoring=>"POS",:yscoring=>"NEG", :description_left => "get the group together and figure out a way to get a custom cake in two hours.", :description_right => "find the closest bakery and get a cake, even if it isn't a perfect cake for the occasion."},

                    {:question=>"TO SEND PICS FROM THE PARTY, YOU...",:xscoring=>"NEG",:yscoring=>"NEG", :description_left => "quickly post pictures online so that they are available immediately.", :description_right => "take the time to create an online slideshow and send it out a week later."}
                    ]

                  ques_arr.each_with_index{|ques,i|
                    ques.update({:order=> (i + 1)})
                    WorkenvQuestion.create(ques)
                  }
        end
       populate_workenv_questions

    end

end
=end