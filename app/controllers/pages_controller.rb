class PagesController < ApplicationController
  def home
    render "home.html.erb"
  end

  def register
    redirect_to "https://www.fitbit.com/oauth2/authorize?response_type=code&client_id=#{ENV['FITBIT_CLIENT_ID']}&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Ffitbit_callback&scope=activity%20heartrate%20location%20nutrition%20profile%20settings%20sleep%20social%20weight&expires_in=604800"
  end

  def fitbit_callback
    @response = Unirest.post(
      "https://api.fitbit.com/oauth2/token?client_id=ENV['FITBIT_CLIENT_ID']&grant_type=authorization_code&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Ffitbit_callback&expires_in=28800&code=#{params[:code]}",
      headers: { 
        "Accept" => "application/x-www-form-urlencoded",
        "Authorization" => "Basic MjI4SEw3OmEyMWRlZjBmZTIyZTMyMmJmNDc4Yjk1YWYwOWIzZDhl"
      }
    ).body
    session[:access_token] = @response['access_token']
    session[:refresh_token] = @response['refresh_token']
    redirect_to "/data"
  end

  def data
    @profile = Unirest.get(
      "https://api.fitbit.com/1/user/-/profile.json",
      headers: {
        "Authorization" => "Bearer #{session[:access_token]}"
      }
    ).body
  end
end
