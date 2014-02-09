class SessionsController < ApplicationController
  def create
    user = request.env['signet.google.persistence_obj'].user
    session[:user_id] = user.id
    flash[:notice] = 'Signed In!'

    auth = Signet::Rails::Factory.create_from_env :google, request.env
    client = Google::APIClient.new
    client.authorization = auth
    service = client.discovered_api('oauth2', 'v2')
    result = client.execute(
      :api_method => service.userinfo.v2.me.get,
      :parameters => {},
      :headers => {'Content-Type' => 'application/json'}
    )
    data = JSON.parse(result.body)
    user.update_attributes  email: data['email'],
                            name: data['given_name'],
                            surname: data['family_name'],
                            avatar: data['picture']


    redirect_to root_url
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = 'Signed Out'
    redirect_to root_url
  end
end