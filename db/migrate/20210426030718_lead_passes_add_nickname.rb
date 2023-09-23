class LeadPassesAddNickname < ActiveRecord::Migration[5.2]
  def change
    add_column(:lead_passes, :instrument_nickname, :text)
    add_column(:lead_passes, :serial_number, :text)
  end
end
