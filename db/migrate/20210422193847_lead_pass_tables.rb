class LeadPassTables < ActiveRecord::Migration[5.2]
  def change
    create_table(:lead_passes) do |t|
      t.timestamps

      t.text(:first_name)
      t.text(:last_name)
      t.text(:company)
      t.text(:position)
      t.text(:phone)
      t.text(:email)
      t.text(:notes)
      t.text(:reference_instrument)
      t.text(:email_body)
    end
  end
end
