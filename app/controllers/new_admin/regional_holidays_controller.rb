# frozen_string_literal: true

module NewAdmin
  class RegionalHolidaysController < NewAdminController
    load_and_authorize_resource

    before_action :set_regional_holiday, only: %i[show edit update destroy]
    before_action :load_cities_with_holidays, only: :index

    def index
      @regional_holidays = paginate_record(regional_holidays)
    end

    def show; end

    def new
      @regional_holiday = RegionalHoliday.new
    end

    def create
      @regional_holiday = RegionalHoliday.new(regional_holiday_params)

      if @regional_holiday.save
        redirect_on_success new_admin_regional_holidays_path, message_scope: "create"
      else
        render_on_failure :new
      end
    end

    def edit; end

    def update
      if @regional_holiday.update(regional_holiday_params)
        redirect_on_success new_admin_show_regional_holiday_path(id: @regional_holiday.id), message_scope: "update"
      else
        render_on_failure :edit
      end
    end

    def destroy
      if @regional_holiday.destroy
        redirect_on_success new_admin_regional_holidays_path, message_scope: "destroy"
      else
        render_on_failure :index
      end
    end

    private

    def regional_holidays
      RegionalHolidaysQuery.new(**filter_params).call
    end

    def redirect_on_success(url, message_scope:)
      flash[:notice] = I18n.t(:notice, scope: "flash.actions.#{message_scope}",
                                       resource_name: RegionalHoliday.model_name.human)
      redirect_to url
    end

    def render_on_failure(template)
      flash.now[:alert] = @regional_holiday.errors.full_messages.to_sentence
      render template, status: :unprocessable_entity
    end

    def filter_params
      params.permit(
        :regional_holiday_id,
        :month,
        city_ids: []
      ).to_h
    end

    def regional_holiday_params
      params.require(:regional_holiday).permit(:name, :day, :month, :city_ids)
    end

    def set_regional_holiday
      @regional_holiday = RegionalHoliday.find(params[:id])
    end

    def load_cities_with_holidays
      @cities_with_holidays = City.with_holidays
    end
  end
end
