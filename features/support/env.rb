Before() do
  @test_user = User.new('karlis.test1@yopmail.com', 'parole123')
  @session_id = set_session_id
end

After() do
  environment_ids = fetch_all_env_ids
  collection_ids = fetch_all_collection_ids
  delete_all_collections(collection_ids)
  delete_all_env_ids(environment_ids)
end