class LeadPassAddExtraColumns < ActiveRecord::Migration[5.2]
  def change
    add_column(:lead_passes, :training, :boolean)
    add_column(:lead_passes, :consulting_services, :boolean)
    add_column(:lead_passes, :qualifications, :boolean)
    add_column(:lead_passes, :instrument_service_plans, :boolean)
    add_column(:lead_passes, :region, :text)
    add_column(:lead_passes, :country, :text)
    add_column(:lead_passes, :zip, :text)
    add_column(:lead_passes, :user_id, :bigint)
  end
end
