# coding: UTF-8

class InsertWorkenvQuestions < ActiveRecord::Migration
  def self.up
    execute "TRUNCATE table workenv_questions"
    
    work_env = WorkenvQuestion.new(:order=>1,:question=>"TO FIND APPROPRIATE VENUES, YOU...",:xscoring=>"NEG",:yscoring=>"NEG",:description_left=>"Get together with friends and discuss previously visited venues.",:description_right=>"Determine venue options based upon budget and estimated guest list.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>2,:question=>"TO CHOOSE BETWEEN VENUES, YOU...",:xscoring=>"NEG",:yscoring=>"POS",:description_left=>"Thoroughly consider all the available options.",:description_right=>"Select any of the top three options and book quickly.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>3,:question=>"TO PLAN THE SURPRISE, YOU...",:xscoring=>"POS",:yscoring=>"POS",:description_left=>"Create a detailed schedule of events.",:description_right=>"Call people to find out how they would like to participate.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>4,:question=>"YOU'RE HANDED THE INVITE LIST, YOU...",:xscoring=>"NEG",:yscoring=>"no",:description_left=>"Have people over to create and send the invitations.",:description_right=>"Send out an invite ASAP and monitor the RSVPs.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>5,:question=>"TO GET SNACKS FOR 100 PEOPLE, YOU...",:xscoring=>"POS",:yscoring=>"NEG",:description_left=>"Hire a caterer and ask for their recommendations.",:description_right=>"Take time to craft a menu specifically for the party.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>6,:question=>"THE VENUE LACKS DECORATIONS, YOU...",:xscoring=>"POS",:yscoring=>"no",:description_left=>"Create a budget and hire a professional to decorate the venue.",:description_right=>"Create decorations and set-up the venue together with friends.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>7,:question=>"TO PICK MUSIC FOR THE PARTY, YOU...",:xscoring=>"NEG",:yscoring=>"POS",:description_left=>"Make a mix or playlist of favorite songs.",:description_right=>"Find and hire a DJ or do it yourself.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>8,:question=>"SO THAT THINGS GO ACCORDING TO PLAN, YOU...",:xscoring=>"POS",:yscoring=>"POS",:description_left=>"Distribute the schedule of events.",:description_right=>"Call individuals to discuss their roles.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>9,:question=>"WE STILL NEED A CAKE! YOU...",:xscoring=>"POS",:yscoring=>"NEG",:description_left=>"Find a bakery nearby and get a cake.",:description_right=>"Review top bakeries in town.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>10,:question=>"TO SHARE PICS FROM THE PARTY, YOU...",:xscoring=>"NEG",:yscoring=>"NEG",:description_left=>"Post all photos online for friends and family.",:description_right=>"Organize a chronological slideshow of the best photos and email it out.",:for_emp=>0)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>11,:question=>"... the use of facts and data for decision making?",:xscoring=>"NEG",:yscoring=>"NEG",:description_left=>"brainstorm with the group.",:description_right=>"determine options based upon budget and estimated guest list.",:for_emp=>1)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>12,:question=>"... taking immediate action on concrete issues?",:xscoring=>"NEG",:yscoring=>"POS",:description_left=>"discuss available venues and work to reach consensus.",:description_right=>"book what seems to be the best option and inform everyone.",:for_emp=>1)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>13,:question=>"... solutions focused on customer's interest and experience?",:xscoring=>"POS",:yscoring=>"POS",:description_left=>"give people specific tasks to complete.",:description_right=>"call people to find out how they would like to participate.",:for_emp=>1)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>14,:question=>"... completing tasks efficiently?",:xscoring=>"NEG",:yscoring=>"no",:description_left=>"send out an invite ASAP and monitor the RSVPs.",:description_right=>"have people over to create and send personal invitations.",:for_emp=>1)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>15,:question=>"... freedom in managing work objectives?",:xscoring=>"POS",:yscoring=>"NEG",:description_left=>"plan a menu and ask guests to volunteer to cook specific dishes.",:description_right=>"determine how best to spend the budget given the estimated number of people.",:for_emp=>1)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>16,:question=>"... the growth and development of employees?",:xscoring=>"POS",:yscoring=>"no",:description_left=>"create decorations and set-up the venue together.",:description_right=>"come up with a budget and hire a company to decorate the venue.",:for_emp=>1)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>17,:question=>"... accountability to produce results?",:xscoring=>"NEG",:yscoring=>"POS",:description_left=>"find, negotiate with and hire the right DJ or do it yourself.",:description_right=>"create a group playlist, share it online and let people vote on songs.",:for_emp=>1)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>18,:question=>"... being adaptable to changing work situations?",:xscoring=>"POS",:yscoring=>"POS",:description_left=>"call everyone to confirm details.",:description_right=>"put together a detailed email and send it to everyone on the list.",:for_emp=>1)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>19,:question=>"... complex problem solving to achieve goals?",:xscoring=>"POS",:yscoring=>"NEG",:description_left=>"get the group together and figure out a way to get a custom cake in two hours.",:description_right=>"find the closest bakery and get a cake, even if it isn't a perfect cake for the occasion.",:for_emp=>1)
    work_env.save
    work_env = WorkenvQuestion.new(:order=>20,:question=>"... consistent workflow and standardized procedures?",:xscoring=>"NEG",:yscoring=>"NEG",:description_left=>"quickly post pictures online so that they are available immediately.",:description_right=>"take the time to create an online slideshow and send it out a week later.",:for_emp=>1)
    work_env.save    
   end

  def self.down
  end
end
