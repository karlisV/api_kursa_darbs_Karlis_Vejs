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
    request_payload = create_request(collection_id, request_name, 'POST', url, body)
  when 'Set activate project'
    url = 'https://www.apimation.com/projects/active/$project_id'
    body = ''
    request_payload = create_request(collection_id, request_name, 'PUT', url, body)
  end
  save_request_to_collection(request_payload)
end

And(/^I delete all collections$/) do
  collection_ids = fetch_all_collection_ids
  delete_all_collections(collection_ids)
end