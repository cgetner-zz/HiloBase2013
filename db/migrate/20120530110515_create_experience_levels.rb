class CreateExperienceLevels < ActiveRecord::Migration
  def change
    create_table :experience_levels do |t|
      t.string :name
      t.float :score

      t.timestamps
    end
    ExperienceLevel.create(:name => 'None', :score => 0.0)
    ExperienceLevel.create(:name => 'Hobby or Avocation', :score => 0.1)
    ExperienceLevel.create(:name => 'Mostly Academic', :score => 0.0)
    ExperienceLevel.create(:name => 'Professional (past)', :score => 0.3)
    ExperienceLevel.create(:name => 'Professional (current)', :score => 0.5)
  end
end
