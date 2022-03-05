require "./spec_helper"
require "../src/modules/functions/feedback.cr"

describe "icon" do
  it "returns the correct symbolic icon for feedback based on whether or not the task was successful" do
    icons = [Hashbrown.icon(true), Hashbrown.icon]

    icons.should eq(["test-pass-symbolic", "cross-large-symbolic"])
  end
end
