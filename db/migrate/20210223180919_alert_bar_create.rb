class AlertBarCreate < ActiveRecord::Migration[5.2]
  def change
    create_table(:alert_bars) do |t|
      t.timestamps

      t.text(:description, null: false)
      t.text(:button_text)
      t.text(:url)
      t.boolean(:active, default: false, null: false)
    end

    add_index(:alert_bars, :active, unique: true, where: "active = 't'")
  end
end
