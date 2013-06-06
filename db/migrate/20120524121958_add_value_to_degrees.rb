class AddValueToDegrees < ActiveRecord::Migration
  def change
    add_column :degrees, :value, :integer

    d = Degree.find_by_name('None')
    d.value = 0
    d.save

    d = Degree.find_by_name('High School/GED')
    d.value = 1
    d.save

    d = Degree.find_by_name('Associates/Vocational')
    d.value = 2
    d.save

    d = Degree.find_by_name('Bachelors')
    d.value = 3
    d.save

    d = Degree.find_by_name('Masters')
    d.value = 4
    d.save

    d = Degree.find_by_name('Doctorate')
    d.value = 5
    d.save

    d = Degree.find_by_name('Professional')
    d.value = 5
    d.save

  end
end
