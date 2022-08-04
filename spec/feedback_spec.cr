require "./spec_helper"
require "../src/collision/functions/feedback.cr"

describe "icon" do
  it "returns the correct symbolic icon for feedback based on whether or not the task was successful" do
    icons = [Collision.icon(true), Collision.icon]

    icons.should eq(["test-pass-symbolic", "cross-large-symbolic"])
  end

  it "returns the correct class to add and remove for feedback based on whether or not the task was successful" do
    icons = [Collision.class(true), Collision.class]

    icons.should eq([{add: "success", remove: "error"}, {add: "error", remove: "success"}])
  end
end
