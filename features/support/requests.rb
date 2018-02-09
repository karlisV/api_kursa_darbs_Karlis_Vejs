class Requests
  attr_accessor :name, :url, :method, :body

  def initialize(name, url, method, body)
    @name = name
    @url = url
    @method = method
    @body = body
  end

  def create_request(collection_id)
    { collection_id: collection_id,
      name: @name,
      request: { method: @method,
                 type: 'raw',
                 url: @url,
                 body: @body } }.to_json
  end

  def create_step
    { step_name: @name,
      url: @url,
      body: @body,
      type: 'raw',
      method: @method }
  end
end
