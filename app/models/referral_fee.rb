# coding: UTF-8

class ReferralFee < ActiveRecord::Base
  attr_accessible :id, :job_seeker_id, :job_id, :share_platform_id, :credit_amount, :discount_amount, :referral_fee_flag, :company_id
  audited
  def self.referral_fee_data(referral_from, referral_to, company_id)
    ReferralFee.select("referral_fees.*, share_platforms.name as share_name").joins("join share_platforms on referral_fees.share_platform_id = share_platforms.id").where("referral_fees.company_id = #{company_id} and referral_fees.created_at >= '#{referral_from}' AND referral_fees.created_at <= '#{referral_to}' + INTERVAL 1 DAY").order("created_at DESC").all
  end
end
