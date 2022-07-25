def use_auth_header_for(user_id)
  auth_header = { Authorization: "Bearer #{Jwt::Generate.new(user_id: user_id).token}" }
  request.headers.merge!(auth_header)
end

def current_jwt
  request.headers['Authorization'].slice('Bearer ')
end