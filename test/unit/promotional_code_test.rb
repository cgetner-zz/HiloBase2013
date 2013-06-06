# coding: UTF-8

require 'test_helper'

class PromotionalCodeTest < ActiveSupport::TestCase
  describe PromotionalCode do
    it { should belong_to :gift }
  end

  should allow_value(0.00).for(:amount)
  should allow_value(0.00).for(:consumed_amount)
end