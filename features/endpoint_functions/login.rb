require 'rest-client'
require 'test-unit'

def login_positive
  login_payload = { login: @test_user.email,
                    password: @test_user.password }.to_json
  response = post('https://www.apimation.com/login',
                  headers: { 'ContentType' => 'application/json' },
                  cookies: {},
                  payload: login_payload)
  # check if 200 OK is received
  assert_equal(200, response.code, "Login failed! Response: #{response}")
  response_hash = JSON.parse(response)
  assert_equal(@test_user.email, response_hash['email'],
               'E-mail in the response is not correct')
  assert_not_equal(nil, response_hash['user_id'], 'User ID is empty')
  assert_equal(@test_user.email, response_hash['login'],
               'Login in the response is not correct')
  @test_user.set_session_cookie(response.cookies)
  @test_user.set_user_id(response_hash['user_id'])
end