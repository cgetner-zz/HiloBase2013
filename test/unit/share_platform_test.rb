# coding: UTF-8

require 'test_helper'

class SharePlatformTest < ActiveSupport::TestCase
  @share_platform = FactoryGirl.build(:share_platform)
  platform = @share_platform.name

  should "test share platform" do
    assert_equal "Twitter", platform
    assert_equal 2, SharePlatform.return_platform_hash(2)["id"]
    assert_not_equal "Twitter", SharePlatform.return_platform_hash(3)["name"]
  end

  should allow_value("Facebook").for(:name)
end