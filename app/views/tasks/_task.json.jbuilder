json.extract! task, :id, :name, :description, :start_at, :end_at, :user_id, :category_id, :created_at, :updated_at
json.url task_url(task, format: :json)
