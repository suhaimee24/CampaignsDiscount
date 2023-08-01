require 'rails_helper'

RSpec.describe "Campaigns", type: :request do
  describe "POST" do
    describe '#create' do
      it 'should return campaigns successfully' do
        post "/campaigns"
        result = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(result['test']).to eq('test')
      end
    end
  end
end
