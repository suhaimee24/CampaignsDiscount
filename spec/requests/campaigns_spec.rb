require 'rails_helper'

RSpec.describe "Campaigns", type: :request do
  describe "POST" do
    describe '#create' do
      it 'should return campaigns successfully (Fixed amount)' do
        post "/campaigns",  params: {
            items: [
              {
                name: "T-shirt",
                category: "clothing",
                price: 350,
                amount: 1,
              },
              {
                name: "Hat",
                category: "accessories",
                price: 250,
                amount: 1,
              },
            ],
            campaigns: [
              {
                category: "coupon",
                name: "Fixed amount",
                label: "50 THB",
                amount: 50,
              }
            ]
          }
        result = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(result["total_price"]).to eq(550)
      end

      it 'should return campaigns successfully (Percentage discount)' do
        post "/campaigns",  params: {
            items: [
              {
                name: "T-shirt",
                category: "clothing",
                price: 350,
                amount: 1,
              },
              {
                name: "Hat",
                category: "accessories",
                price: 250,
                amount: 1,
              },
            ],
            campaigns: [
              {
                category: "coupon",
                name: "Percentage discount",
                label: "10%",
                amount: "10%",
              }
            ]
          }
        result = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(result["total_price"]).to eq(540)
      end

      it 'should return campaigns successfully (Percentage discount by item category)' do
        post "/campaigns",  params: {
          items: [
            {
              name: "T-shirt",
              category: "clothing",
              price: 350,
              amount: 1,
            },
            {
              name: "Hoodie",
              category: "clothing",
              price: 700,
              amount: 1,
            },
            {
              name: "Watch",
              category: "accessories",
              price: 850,
              amount: 1,
            },
            {
              name: "Bag",
              category: "accessories",
              price: 640,
              amount: 1,
            },
          ],
          campaigns: [
            {
              category: "on_top",
              name: "Percentage discount by item category",
              label: "15% Off on Clothing",
              amount: "15%",
              items_category: "clothing"
            }
          ]
        }
        result = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(result["total_price"]).to eq(2382.5)
      end

      it 'should return campaigns successfully (Discount by points)' do
        post "/campaigns",  params: {
          items: [
            {
              name: "T-shirt",
              category: "clothing",
              price: 350,
              amount: 1,
            },
            {
              name: "Hat",
              category: "accessories",
              price: 250,
              amount: 1,
            },
            {
              name: "Belt",
              category: "accessories",
              price: 230,
              amount: 1,
            }
          ],
          campaigns: [
            {
              category: "on_top",
              name: "Discount by points",
              label: "Points",
            }
          ],
          points: 68
        }
        result = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(result["total_price"]).to eq(762)
      end

      it 'should return campaigns successfully (Discount by points point over 20% total price)' do
        post "/campaigns",  params: {
          items: [
            {
              name: "T-shirt",
              category: "clothing",
              price: 350,
              amount: 1,
            },
            {
              name: "Hat",
              category: "accessories",
              price: 250,
              amount: 1,
            },
            {
              name: "Belt",
              category: "accessories",
              price: 230,
              amount: 1,
            }
          ],
          campaigns: [
            {
              category: "on_top",
              name: "Discount by points",
              label: "Points",
            }
          ],
          points: 200
        }
        result = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(result["total_price"]).to eq(664)
      end

      it 'should return campaigns fails (Discount by points) when point empty ' do
        post "/campaigns",  params: {
          items: [
            {
              name: "T-shirt",
              category: "clothing",
              price: 350,
              amount: 1,
            },
            {
              name: "Hat",
              category: "accessories",
              price: 250,
              amount: 1,
            },
            {
              name: "Belt",
              category: "accessories",
              price: 230,
              amount: 1,
            }
          ],
          campaigns: [
            {
              category: "on_top",
              name: "Discount by points",
              label: "Points",
            }
          ],
        }
        result = JSON.parse(response.body)
        expect(response.status).to eq(400)
        expect(result["message"]).to eq("points is required.")
      end

      it 'should return campaigns successfully (Special campaigns)' do
        post "/campaigns",  params: {
          items: [
            {
              name: "T-shirt",
              category: "clothing",
              price: 350,
              amount: 1,
            },
            {
              name: "Hat",
              category: "accessories",
              price: 250,
              amount: 1,
            },
            {
              name: "Belt",
              category: "accessories",
              price: 230,
              amount: 1,
            }
          ],
          campaigns: [
            {
              category: "seasonal",
              name: "Special campaigns",
              label: "%d THB at every %d THB",
              every: 300,
              amount: 40
            }
          ],
          points: 200
        }
        result = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(result["total_price"]).to eq(750)
      end

      it 'should return campaigns fails (Special campaigns) when every empty' do
        post "/campaigns",  params: {
          items: [
            {
              name: "T-shirt",
              category: "clothing",
              price: 350,
              amount: 1,
            },
            {
              name: "Hat",
              category: "accessories",
              price: 250,
              amount: 1,
            },
            {
              name: "Belt",
              category: "accessories",
              price: 230,
              amount: 1,
            }
          ],
          campaigns: [
            {
              category: "seasonal",
              name: "Special campaigns",
              label: "%d THB at every %d THB",
              amount: 40
            }
          ],
        }
        result = JSON.parse(response.body)
        expect(response.status).to eq(400)
        expect(result["message"]).to eq('every is required.')
      end

      it 'should return campaigns successfully include 3 capaigns' do
        post "/campaigns",  params: {
          items: [
            {
              name: "T-shirt",
              category: "clothing",
              price: 350,
              amount: 1,
            },
            {
              name: "Hat",
              category: "accessories",
              price: 250,
              amount: 1,
            },
            {
              name: "Belt",
              category: "accessories",
              price: 230,
              amount: 1,
            }
          ],
          campaigns: [
            {
              category: "seasonal",
              name: "Special campaigns",
              label: "%d THB at every %d THB",
              every: 300,
              amount: 40
            },
            {
              category: "on_top",
              name: "Discount by points",
              label: "Points",
            },
            {
              category: "coupon",
              name: "Fixed amount",
              label: "50 THB",
              amount: 50,
            }
          ],
          points: 50
        }
        result = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(result["total_price"]).to eq(650)
      end

    end
  end
end
