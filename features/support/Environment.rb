class Environment
  attr_accessor :id, :name

  def initialize(env_id, env_name)
    @id = env_id
    @name = env_name
  end
end