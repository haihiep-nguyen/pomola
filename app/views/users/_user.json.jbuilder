json.extract! user, :id, :username, :name, :encrypted_password, :reset_password_token, :photo, :brand, :slug, :dob, :address, :is_deteled, :is_active, :created_at, :updated_at
json.url user_url(user, format: :json)
