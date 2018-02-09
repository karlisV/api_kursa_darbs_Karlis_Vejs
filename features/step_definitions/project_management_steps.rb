When(/^I "(create|select)" (?:a|an existing) project$/) do |action|
  case action
  when 'create'
    project = create_project
  when 'select'
    all_projects = fetch_all_projects
    # create a new project if there are no projects
    all_projects = create_project if all_projects.empty?
    project = all_projects[0]
  end
  @project = Project.new(project['id'], project['name'])
  set_project_as_active(@project.id)
end

And(/^I create environment "([^"]*)"$/) do |environment|
  created_env = create_env(environment)
  @environment = Environment.new(created_env['id'], created_env['name'])
end

And(/^I create global variables for created environment:$/) do |global_variables|
  # table is a table.hashes.keys # => [:key, :value]
  global_variables_hash = global_variables.hashes
  global_variables_hash.each do |hash|
    case hash['key']
    when '$user'
      hash.store('value', @test_user.email)
    when '$pwd'
      hash.store('value', @test_user.password)
    when '$project_id'
      hash.store('value', @project.id)
    end
  end
  create_global_vars(global_variables_hash)
end