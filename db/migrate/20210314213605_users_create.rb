class UsersCreate < ActiveRecord::Migration[5.2]
  def change
    create_table(:users) do |t|
      t.timestamps

      t.text(:email, null: false)
      t.text(:country_code, null: false)
      t.text(:role, null: false)
    end

    add_index(:users, :email, unique: true)
  end
end
