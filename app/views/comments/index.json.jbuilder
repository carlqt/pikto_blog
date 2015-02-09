json.array!(@comments) do |comment|
  json.extract! comment, :id, :message, :status, :blog_id
  json.url comment_url(comment, format: :json)
end
