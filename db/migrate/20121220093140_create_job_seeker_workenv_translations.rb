class CreateJobSeekerWorkenvTranslations < ActiveRecord::Migration
  def self.up
    WorkenvQuestion.create_translation_table!({
        :question => :string,
        :description_left => :text,
        :description_right => :text
    }, {
      :migrate_data => true
    })
  end

  def self.down
    WorkenvQuestion.drop_translation_table! :migrate_data => true
  end
end
