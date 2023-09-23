module SiteAlertConcern
  extend ActiveSupport::Concern

  included do
    helper_method :site_alert?
    helper_method :site_alert
  end

  def site_alert?
    !!site_alert
  end

  def site_alert
    @site_alert ||= AlertBar.active
  end
end
