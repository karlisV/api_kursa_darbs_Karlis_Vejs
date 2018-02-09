Then(/^I create these request collections:$/) do |collection_names|
  collection_names = collection_names.hashes
  collection_names.each do |collection|
    create_collection(collection['collection'])
  end
end

When(/^I create request "([^"]*)" for collection "([^"]*)"$/) do |request_name, collection_name|
  collection_id = fetch_collection_id(collection_name)
  case request_name
  when 'Positive login'
    url = 'http://apimation.com/login'
    body = '{"login": "$user", "password": "$pwd"}'
    method = 'POST'
    @positive_login_case = Requests.new(request_name, url, method, body)
    request_payload = @positive_login_case.create_request(collection_id)
  when 'Set activate project'
    url = 'https://www.apimation.com/projects/active/$project_id'
    body = ''
    method = 'PUT'
    @set_project_as_active_case = Requests.new(request_name, url, method, body)
    request_payload = @set_project_as_active_case.create_request(collection_id)
  end
  save_request_to_collection(request_payload)
end

When(/^I add these requests to test case "([^"]*)":$/) do |test_case_name, requests|
  # table is a Cucumber::MultilineArgument::DataTable
  steps = []
  requests = requests.hashes
  requests.each do |request|
    case request['request_name']
    when @positive_login_case.name
      step = @positive_login_case.create_step
    when @set_project_as_active_case.name
      step = @set_project_as_active_case.create_step
    end
    steps.push(step)
  end
  add_steps_to_test_case(steps, test_case_name)
end

Then(/^I check if test case "([^"]*)" is created$/) do |test_case_name|
  search_case_by_name(test_case_name)
end