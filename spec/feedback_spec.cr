require "./spec_helper"
require "../src/collision/functions/feedback.cr"

describe "icon" do
  it "returns the correct symbolic icon for feedback based on whether or not the task was successful" do
    icons = [Collision.icon(true), Collision.icon]

    icons.should eq(["test-pass-symbolic", "cross-large-symbolic"])
  end
end
