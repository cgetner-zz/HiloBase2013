class AddDegrees < ActiveRecord::Migration
  def up
    ActiveRecord::Base.connection.execute("truncate degrees")
    Degree.create!(:name=>'None')
    Degree.create!(:name=>'High School/GED')
    Degree.create!(:name=>'Associates/Vocational')
    Degree.create!(:name=>'Bachelors')
    Degree.create!(:name=>'Masters')
    Degree.create!(:name=>'Doctorate')
    Degree.create!(:name=>'Professional')
  end

  def down
  end
end
