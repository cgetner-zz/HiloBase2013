# coding: UTF-8
# Important Note: This command has to run on each fresh machine or on a fresh server

namespace :populates_states do
    desc "Populate states"
    task(:data=> :environment) do

 
        def populate_states
                states_arr = [
					{:name=>"Alabama"},
					{:name=>"Alaska"},
					{:name=>"Arizona"},
                    {:name=>"Arkansas"},
					{:name=>"California"},
					{:name=>"Colorado"},
					{:name=>"Connecticut"},
					{:name=>"Delaware"},
					{:name=>"Florida"},
					{:name=>"Georgia"},
					{:name=>"Hawaii"},
					{:name=>"Idaho"},
					{:name=>"Illinois"},
					{:name=>"Indiana"},
					{:name=>"Iowa"},
					{:name=>"Kansas"},
					{:name=>"Kentucky"},
					{:name=>"Louisiana"},
					{:name=>"Maine"},
					{:name=>"Maryland"},
					{:name=>"Massachusetts"},
					{:name=>"Michigan"},
					{:name=>"Minnesota"},
					{:name=>"Mississippi"},
					{:name=>"Missouri"},
					{:name=>"Montana"},
					{:name=>"Nebraska"},
					{:name=>"Nevada"},
					{:name=>"New Hampshire"},
					{:name=>"New Jersey"},
					{:name=>"New Mexico"},
					{:name=>"New York"},
					{:name=>"North Carolina"},
					{:name=>"North Dakota"},
					{:name=>"Ohio"},
					{:name=>"Oklahoma"},
					{:name=>"Oregon"},
					{:name=>"Pennsylvania"},
					{:name=>"Rhode Island"},
					{:name=>"South Carolina"},
					{:name=>"South Dakota"},
					{:name=>"Tennessee"},
					{:name=>"Texas"},
					{:name=>"Utah"},
					{:name=>"Vermont"},
					{:name=>"Virginia"},
					{:name=>"Washington"},
					{:name=>"West Virginia"},
					{:name=>"Wisconsin"},
					{:name=>"Wyoming"}
                    ]

                  states_arr.each_with_index{|state,i|                    
                    State.create(state)
                  }
        end
       populate_states()
    
    end

end