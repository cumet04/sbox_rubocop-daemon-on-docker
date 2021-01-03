require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has timestamp' do
    expect(User.create.created_at).to be_present
  end
end
