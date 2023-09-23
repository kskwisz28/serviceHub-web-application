module Admins
  class AlertBarsController < AdminsController
    helper_method :alert_bar

    def create
      @alert_bar = AlertBar.create(alert_bar_params.merge(active: true))

      if alert_bar.valid?
        redirect_to(admins_alert_bar_path, notice: "Alert bar created")
      else
        render(:show, status: :unprocessable_entity)
      end
    end

    def destroy
      alert_bar&.archive!
      redirect_to(admins_alert_bar_path, notice: "Alert bar deleted")
    end

    private

    def alert_bar
      @alert_bar ||= AlertBar.active
    end

    def alert_bar_params
      params.require(:alert_bar).permit(
        :description,
        :button_text,
        :url,
      )
    end
  end
end
