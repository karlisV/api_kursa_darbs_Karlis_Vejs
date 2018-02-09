class Project
  attr_accessor :id, :name

  def initialize(project_id, project_name)
    @id = project_id
    @name = project_name
  end
end