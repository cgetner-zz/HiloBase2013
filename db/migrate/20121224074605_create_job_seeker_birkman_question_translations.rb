class CreateJobSeekerBirkmanQuestionTranslations < ActiveRecord::Migration
  def self.up
    BirkmanQuestion.create_translation_table!({
        :question => :string
    }, {
      :migrate_data => true
    })
  end

  def self.down
    BirkmanQuestion.drop_translation_table! :migrate_data => true
  end
end
