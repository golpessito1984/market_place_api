module Pagination
  def assert_json_response_is_paginated(json_hash)
    expect(json_hash.dig(:links, :first)).not_to be_nil
    expect(json_hash.dig(:links, :last)).not_to be_nil
    expect(json_hash.dig(:links, :prev)).not_to be_nil
    expect(json_hash.dig(:links, :next)).not_to be_nil
  end

  def self.hola
    puts "HOLA"
  end

end