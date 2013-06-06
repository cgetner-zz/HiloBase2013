class ModifyEducationLevel < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("TRUNCATE education_levels;")
    add_column :education_levels, :score, :float
    EducationLevel.create(:name => 'None', :score => 0.0)
    EducationLevel.create(:name => 'Self-Taught/On the Job', :score => 0.1)
    EducationLevel.create(:name => 'Coursework', :score => 0.2)
    EducationLevel.create(:name => 'Certification/License', :score => 0.3)
    EducationLevel.create(:name => 'Associates/Vocational Degree', :score => 0.5)
    EducationLevel.create(:name => 'Undergraduate Degree', :score => 0.8)
    EducationLevel.create(:name => 'Graduate Degree', :score => 1.3)
  end

  def down
  end
end
