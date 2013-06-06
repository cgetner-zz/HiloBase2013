class AddPromoCodeSentToGuestJobSeekers < ActiveRecord::Migration
  def change
    add_column :guest_job_seekers, :promo_code_sent, :boolean, :default => false
  end
end
