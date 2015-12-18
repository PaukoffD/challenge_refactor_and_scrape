class CustomersController < InheritedResources::Base
  respond_to :html, :json

  private

    def customer_params
      params.require(:customer).permit(:name)
    end
end

