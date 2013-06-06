class CreateJobSeekerBirkmanJobInterestTranslations < ActiveRecord::Migration
  def self.up
    BirkmanJobInterest.create_translation_table!({
        :statement => :string
    }, {
      :migrate_data => true
    })
  end

  def self.down
    BirkmanJobInterest.drop_translation_table! :migrate_data => true
  end
end
