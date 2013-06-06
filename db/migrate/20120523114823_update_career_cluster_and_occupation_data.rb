class UpdateCareerClusterAndOccupationData < ActiveRecord::Migration
  def up
	execute <<-SQL
      ALTER TABLE career_cluster
        ADD FULLTEXT(career_cluster, pathway, descripton)
    SQL
	execute <<-SQL
      ALTER TABLE occupation_data
        ADD FULLTEXT(title, description)
    SQL
  end

  def down
	execute <<-SQL
      ALTER TABLE career_cluster
        DROP FULLTEXT(career_cluster, pathway, descripton)
    SQL
	execute <<-SQL
      ALTER TABLE occupation_data
        DROP FULLTEXT(title, description)
    SQL
  end
end
