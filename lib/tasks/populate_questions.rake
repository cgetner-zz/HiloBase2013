# coding: UTF-8
# Important Note: This command has to run on each fresh machine or on a server.

namespace :populate_questions do
    desc "Populate birkman questions"
    task(:data=> :environment) do

 
        def populate_role_questions
                ques_arr = [
                    {:question=>"Physical movement?",:xscoring=>"no",:yscoring=>"POS"},

                    {:question=>"Making operations/systems more effective and/or efficient?",:xscoring=>"NEG",:yscoring=>"no"},

                    {:question=>"Dealing with processes and procedures?",:xscoring=>"NEG",:yscoring=>"NEG"},

                    {:question=>"Dealing with concrete tasks?",:xscoring=>"NEG",:yscoring=>"POS"},

                    {:question=>"Dealing with groups of people?",:xscoring=>"POS",:yscoring=>"POS"},

                    {:question=>"Dealing with plans and strategies?",:xscoring=>"POS",:yscoring=>"NEG"},

                    {:question=>"Synthesizing data?",:xscoring=>"NEG",:yscoring=>"NEG"},

                    {:question=>"Dealing with people external to the organization?",:xscoring=>"POS",:yscoring=>"POS"},

                    {:question=>"Creating new concepts and ideas?",:xscoring=>"POS",:yscoring=>"NEG"},

                    {:question=>"Resolving conflict between people?",:xscoring=>"POS",:yscoring=>"POS"},

                    {:question=>"Resolving problems associated with operations/systems?",:xscoring=>"NEG",:yscoring=>"POS"},

                    {:question=>"Discovering and identifying problems associated with operations/systems?",:xscoring=>"NEG",:yscoring=>"NEG"},

                    {:question=>"Conveying and selling concepts and ideas to others?",:xscoring=>"POS",:yscoring=>"POS"},

                    {:question=>"Working with peers across departments?",:xscoring=>"no",:yscoring=>"POS"},

                    {:question=>"Working with abstract ideas and theories?",:xscoring=>"POS",:yscoring=>"NEG"}
                    
                    ]

                  ques_arr.each_with_index{|ques,i|
                    ques.update({:order=> (i + 1)})
                    RoleQuestion.create(ques)
                  }
        end
       populate_role_questions()
    
    end

end