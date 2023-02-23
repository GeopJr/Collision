require "./spec_helper"
require "../src/collision/functions/feedback.cr"

describe Collision::Functions::Feedback do
  it "returns the correct symbolic icon for feedback based on whether or not the task was successful" do
    icons = [Collision::Functions::Feedback.icon(true), Collision::Functions::Feedback.icon]

    icons.should eq(["test-pass-symbolic", "cross-large-symbolic"])
  end

  it "returns the correct class to add and remove for feedback based on whether or not the task was successful" do
    icons = [Collision::Functions::Feedback.class(true), Collision::Functions::Feedback.class]

    icons.should eq([{add: "success", remove: "error"}, {add: "error", remove: "success"}])
  end
end
