require "rails_helper"

RSpec.describe("Admin") do
  it "views admin page" do
    visit "/admins"

    expect(page).to(have_text("Admin"))
  end

  it "can navigate to the Alert Bar page" do
    visit "/admins"
    click_link("Alert Bar")

    expect(page).to(have_current_path("/admins/alert_bar"))
    expect(page).to(have_text("Alert Bar"))
  end
end
