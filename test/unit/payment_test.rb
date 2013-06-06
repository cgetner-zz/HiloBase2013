# coding: UTF-8

require 'test_helper'

class PaymentTest < ActiveSupport::TestCase
  should belong_to :job_seeker
  should belong_to :employer

  should validate_presence_of :amount_charged
  should validate_presence_of :billing_address_one
  should validate_presence_of :billing_city
  should validate_presence_of :billing_state
  should validate_presence_of :billing_zip
  should validate_presence_of :billing_country
  ##TODO: Validation in case of special characters and empty strings and length should be applied on all fields
  should validate_presence_of :card_num
  should ensure_length_of(:card_num).is_equal_to(16)
  should allow_value(5583850586861660).for(:card_num)
  should_not allow_value("").for(:card_num)
  should_not allow_value(3453453535).for(:card_num)
  should_not allow_value(345345353556757657768686).for(:card_num)

  should validate_presence_of :cvv
  should ensure_length_of(:cvv).is_at_least(3).is_at_most(4)
  should allow_value(165).for(:cvv)
  should_not allow_value("").for(:cvv)
  should allow_value(4545).for(:cvv)
  should_not allow_value(45464).for(:cvv)
  should_not allow_value(45).for(:cvv)
  should_not allow_value("#**").for(:cvv)

  should validate_presence_of :card_type
  should allow_value("Mastercard").for(:card_type)
  should_not allow_value("").for(:card_type)
  should_not allow_value(34535).for(:card_type)

  should validate_presence_of :holder_name
  should allow_value("Peter").for(:holder_name)
  should_not allow_value(45645476).for(:holder_name)

  should validate_presence_of :expiry_date
end