class CreateIcsTypes < ActiveRecord::Migration
  def change
    create_table :ics_types do |t|
      t.string :type

      t.timestamps
    end

    IcsType.create(:type=>"Retail Career Seeker")
    IcsType.create(:type=>"Sponsored Career Seeker")
    IcsType.create(:type=>"Subscribed Career Seeker")
    IcsType.create(:type=>"General Career Seeker")
  end
end
