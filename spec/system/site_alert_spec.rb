require "rails_helper"

RSpec.describe("Site wide alerts") do
  before do
    FactoryBot.create(:alert_bar, description: "Test alert bar", active: true)
  end

  it "views site alert" do
    visit "/instruments"
    expect(page).to(have_text("Test alert bar"))
  end
end
