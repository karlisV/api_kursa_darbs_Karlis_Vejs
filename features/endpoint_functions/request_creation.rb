def create_collection(collection_name)
  new_collection_payload = { name: collection_name,
                             description: '' }.to_json
  response = post('https://www.apimation.com/collections',
                  headers: { 'ContentType' => 'application/json' },
                  cookies: @test_user.session_cookie,
                  payload: new_collection_payload)
  # check if 200 OK is received
  assert_equal(200, response.code, "Collection was not created! Response: #{response}")
  response_hash = JSON.parse(response)
  assert_equal(collection_name, response_hash['name'], 'Wrong collection name')
  assert_not_equal(nil, response_hash['id'], 'Collection ID is empty')
end

def fetch_collection_id(collection_name)
  response = get('https://www.apimation.com/collections',
                 headers: {},
                 cookies: @test_user.session_cookie)
  # check if 200 OK is received
  assert_equal(200, response.code, "Failed to get collections! Response: #{response}")
  response_hash = JSON.parse(response)
  collection_id = nil
  collection_found = false
  # search for a project
  response_hash.each do |collection|
    next unless collection['name'].to_s == collection_name
    collection_id = collection['id'].to_s
    collection_found = true
  end
  assert_equal(true, collection_found, 'Collection ID was not found')
  collection_id
end

def fetch_all_collection_ids
  response = get('https://www.apimation.com/collections',
                 headers: {},
                 cookies: @test_user.session_cookie)
  # check if 200 OK is received
  assert_equal(200, response.code, "Failed to get collections! Response: #{response}")
  response_hash = JSON.parse(response)
  collection_ids = []
  response_hash.each do |collection|
    collection_ids.push(collection['id']) unless collection['id'].empty?
  end
  collection_ids
end

def delete_all_collections(collection_ids)
  collection_ids.each do |collection|
    response = delete("https://www.apimation.com/collections/#{collection}",
                      headers: {},
                      cookies: @test_user.session_cookie)
    # check if response is correct
    assert_equal(204, response.code, "Could not delete collection! Response: #{response}")
  end
end

def add_steps_to_test_case(steps, name)
  new_test_case_payload = { name: name,
                            description: name,
                            request: { requests: steps,
                                       assertWarn: 1 } }.to_json
  response = post('https://www.apimation.com/cases',
                  headers: {},
                  cookies: @test_user.session_cookie,
                  payload: new_test_case_payload)
  assert_equal(200, response.code,
               "Case was not created! Response: #{response}")
end

def save_request_to_collection(request_payload)
  response = post('https://www.apimation.com/steps',
                  headers: { 'ContentType' => 'application/json' },
                  cookies: @test_user.session_cookie,
                  payload: request_payload)
  assert_equal(200, response.code,
               "Requests was not saed! Response: #{response}")
end

def fetch_all_case_ids
  response = get('https://www.apimation.com/cases',
                 headers: {},
                 cookies: @test_user.session_cookie)
  # check if 200 OK is received
  assert_equal(200, response.code,
               "Failed to get collections! Response: #{response}")
  response_hash = JSON.parse(response)
  test_case_ids = []
  response_hash.each do |test_case|
    test_case_ids.push(test_case['case_id'])
  end
  test_case_ids
end

def delete_all_test_cases(test_case_ids)
  test_case_ids.each do |test_case|
    response = delete("https://www.apimation.com/cases/#{test_case}",
                      headers: {},
                      cookies: @test_user.session_cookie)
    # check if response is correct
    assert_equal(204, response.code,
                 "Could not delete test cases! Response: #{response}")
  end
end

def search_case_by_name(test_case_name)
  response = get('https://www.apimation.com/cases',
                 headers: {},
                 cookies: @test_user.session_cookie)
  # check if 200 OK is received
  assert_equal(200, response.code,
               "Failed to get test cases! Response: #{response}")
  response_hash = JSON.parse(response)
  test_case_found = false
  response_hash.each do |test_case|
    test_case_found = true if test_case['case_name'].to_s == test_case_name.to_s
  end
  assert_equal(true, test_case_found, 'Test case was not found')
end