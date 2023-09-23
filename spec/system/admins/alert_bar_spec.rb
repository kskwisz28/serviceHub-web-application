require "rails_helper"

RSpec.describe("Admin Alerts") do
  it "can create and delete an alert" do
    visit "/admins/alert_bar"
    fill_in("Description", with: "My alert")
    click_button("Save")

    expect(page).to(have_current_path("/admins/alert_bar"))
    expect(page).to(have_text("Alert bar created"))
    expect(page).to(have_text("My alert"))

    click_link("delete")
    expect(page).to(have_text("Alert bar deleted"))
    expect(page).to_not(have_text("My alert"))
  end

  it "renders the link" do
    visit "/admins/alert_bar"
    fill_in("Description", with: "New alert")
    fill_in("Button text", with: "Some link text")
    fill_in("Url", with: "https://www.example.com/")
    click_button("Save")

    visit "/instruments"

    expect(page).to(have_text("New alert"))
    expect(page).to(have_text("Some link text"))
    expect(page).to(have_link("Some link text", href: "https://www.example.com/"))

    visit "/admins/alert_bar"
    click_link("delete")
  end

  it "sanitizes malicious payloads", js: true do
    visit "/admins/alert_bar"
    fill_in("Description", with: "Malicious alert")
    fill_in("Button text", with: "This will do bad things")
    fill_in("Url", with: "javascript:alert('foo')")
    click_button("Save")

    visit "/instruments"

    expect do
      accept_alert do
        within(".alert-bar.header") do
          find("a").click
        end
      end
    end.to(raise_error(Capybara::ModalNotFound))
    expect(page).to(have_text("Malicious alert"))
    expect(page).to(have_text("This will do bad things"))
    expect(page).to(have_link("This will do bad things", href: nil))
    visit "/admins/alert_bar"
    click_link("delete")
  end
end
