require 'rest-client'
require 'test-unit'

def fetch_all_projects
  response = get('https://www.apimation.com/projects',
                 headers: {},
                 cookies: @test_user.session_cookie)
  # check if 200 OK is received
  assert_equal(200, response.code,
               "Could not get projects! Response: #{response}")
  response_hash = JSON.parse(response)
  response_hash
end

def create_project
  new_project_payload = { name: "test_project_#{@session_id}",
                          type: 'basic' }.to_json
  response = post('https://www.apimation.com/projects',
                  headers: { 'ContentType' => 'application/json' },
                  cookies: @test_user.session_cookie,
                  payload: new_project_payload)
  # check if 200 OK is received
  assert_equal(200, response.code,
               "Project was not created! Response: #{response}")
  response_hash = JSON.parse(response)
  assert_equal("test_project_#{@session_id}", response_hash['name'],
               'Wrong project name')
  assert_not_equal(nil, response_hash['id'], 'Project ID is empty')
  assert_equal('basic', response_hash['type'],
               'Wrong project type')
  response_hash
end

def fetch_created_project_id
  response = get('https://www.apimation.com/projects',
                 headers: {},
                 cookies: @test_user.session_cookie)
  # check if 200 OK is received
  assert_equal(200, response.code,
               "Could not get projects! Response: #{response}")
  response_hash = JSON.parse(response)
  # set flag and project id
  project_id = nil
  project_found = false
  # search for a project
  response_hash.each do |project|
    next unless project['name'].to_s == "test_project_#{@session_id}"
    project_id = project['id'].to_s
    project_found = true
  end
  assert_equal(true, project_found, 'Project ID was not found')
  project_id
end

def set_project_as_active(project_id)
  response = put("https://www.apimation.com/projects/active/#{project_id}",
                 headers: { 'ContentType' => 'application/json' },
                 cookies: @test_user.session_cookie)
  # check if response is correct
  assert_equal(204, response.code,
               "Project was not set as active! Response: #{response}")
end

def create_env(env_name)
  new_env_payload = { name: env_name }.to_json
  response = post('https://www.apimation.com/environments',
                  headers: { 'ContentType' => 'application/json' },
                  cookies: @test_user.session_cookie,
                  payload: new_env_payload)
  # check if 200 OK is received
  assert_equal(200, response.code,
               "Environment was not created! Response: #{response}")
  response_hash = JSON.parse(response)
  assert_equal(env_name, response_hash['name'],
               'Wrong environment name')
  assert_not_equal(nil, response_hash['id'], 'Environment ID is empty')
  response_hash
end

def fetch_all_env_ids
  response = get('https://www.apimation.com/environments',
                 headers: {},
                 cookies: @test_user.session_cookie)
  # check if 200 OK is received
  assert_equal(200, response.code,
               "Could not get environments! Response: #{response}")
  response_hash = JSON.parse(response)
  environment_ids = []
  response_hash.each do |environment|
    environment_ids.push(environment['id']) unless environment['id'].empty?
  end
  environment_ids
end

def create_global_vars(global_variables)
  global_var_payload = { global_vars: global_variables }.to_json
  response = put("https://www.apimation.com/environments/#{@environment.id}",
                 headers: {},
                 cookies: @test_user.session_cookie,
                 payload: global_var_payload)
  # check if response is correct
  assert_equal(204, response.code,
               "Could not create global variables! Response: #{response}")
end

def delete_all_env_ids(env_id_list)
  env_id_list.each do |environment|
    response = delete("https://www.apimation.com/environments/#{environment}",
                      headers: {},
                      cookies: @test_user.session_cookie)
    # check if response is correct
    assert_equal(204, response.code,
                 "Could not delete environment! Response: #{response}")
  end
end