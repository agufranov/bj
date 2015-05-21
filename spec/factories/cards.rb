FactoryGirl.define do
  factory :card do
    suit { Card::SUIT.sample }
  end
end
