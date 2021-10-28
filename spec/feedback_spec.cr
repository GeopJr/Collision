require "./spec_helper"
require "../src/modules/functions/icon_name.cr"

describe "icon" do
  it "returns the correct symbolic icon for feedback based on whether or not the task was successful" do
    icons = [Hashbrown.icon(true), Hashbrown.icon]

    icons.should eq(["emblem-ok-symbolic", "window-close-symbolic"])
  end
end
