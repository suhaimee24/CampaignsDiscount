class ApplicationController < ActionController::Base
  
  def render_ok(json = {})
    render status: :ok, json:
  end

  def render_bad_request(json = {})
    render status: :bad_request, json:
  end
end
