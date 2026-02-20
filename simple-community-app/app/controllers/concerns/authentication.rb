module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :set_current_request_details
    before_action :load_session_from_cookie
    before_action :authenticate
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :authenticate, **options
    end
  end

  private

  def set_current_request_details
    Current.user_agent = request.user_agent
    Current.ip_address = request.remote_ip
  end

  def load_session_from_cookie
    if session_record = Session.find_by(id: cookies.signed[:session_id])
      Current.session = session_record
    end
  end

  def authenticate
    unless Current.session
      redirect_to new_session_path, alert: "로그인이 필요합니다"
    end
  end

  def start_new_session_for(user)
    session_record = user.sessions.create!(
      ip_address: request.remote_ip,
      user_agent: request.user_agent
    )
    cookies.signed.permanent[:session_id] = { value: session_record.id, httponly: true }
    Current.session = session_record
  end

  def terminate_session
    Current.session&.destroy
    cookies.delete(:session_id)
    Current.session = nil
  end
end
