require "./spec_helper"
require "../src/modules/functions/clear.cr"

class Comapre
  property visible_child_name = "page3"

  def visible_child_name=(@visible_child_name : String)
  end

  def visible_child_name? : String
    @visible_child_name
  end

  def reset
    @visible_child_name = "page3"
  end
end

class Verify < Comapre
end

COMPARE_STATUS = Comapre.new
VERIFY_STATUS  = Verify.new
describe "i18n" do
  it "clears all statuses" do
    Hashbrown.clear(0)

    (COMPARE_STATUS.visible_child_name == "page0" && VERIFY_STATUS.visible_child_name == "page0").should be_true
  end

  it "clears compare status" do
    COMPARE_STATUS.reset

    Hashbrown.clear(1)

    COMPARE_STATUS.visible_child_name.should eq("page0")
  end

  it "clears verify status" do
    VERIFY_STATUS.reset

    Hashbrown.clear(1)

    COMPARE_STATUS.visible_child_name.should eq("page0")
  end
end
