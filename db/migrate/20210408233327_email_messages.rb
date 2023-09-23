class EmailMessages < ActiveRecord::Migration[5.2]
  def change
    create_table(:email_messages) do |t|
      t.timestamps

      t.text(:email_body)
      t.text(:literature_asset_urls, array: true, default: [])
      t.text(:customer_email)
      t.text(:status)
      t.references(:user, null: false)
    end
  end
end
