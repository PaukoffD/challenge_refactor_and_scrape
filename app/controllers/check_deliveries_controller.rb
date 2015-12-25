class CheckDeliveriesController < ApplicationController

  def new
    @check_delivery = CheckDelivery.new
  end

  def create
    @check_delivery = CheckDelivery.new check_delivery_params
    @result = @check_delivery.delivery_company.pull @check_delivery.query if @check_delivery.valid?
    logger.debug "CheckDeliveriesController@#{}#create #{@result.inspect}" if logger.debug?
    if @check_delivery.valid? and @result.is_a? String
      render action: 'show'
    else
      @result.each do |code, (value, extra)|
        # NOTE: only one item is returned always
        extra = case extra
        when StandardError
          extra.message
        when nil
          nil
        else
          extra.class.to_s.split(':').last
        end
        flash[:alert] = t "check_deliveries.create.messages.#{code}",
            value: value, extra: extra
      end if @result
      logger.debug "CheckDeliveriesController@#{}#create #{@check_delivery.errors.inspect}" if logger.debug?
      render action: 'new'
    end
  end

  private

  def check_delivery_params
    params.require(:check_delivery).permit(:delivery_company_id, :query)
  end
end

