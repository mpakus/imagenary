if @user.nil?
  json.status do
    json.code  403
    json.error 'Invalid email or password'
  end
else
  json.user do
    json.(@user, :name, :email, :token)
  end
  json.status do
    json.code  200
    json.msg 'OK'
  end
end