FactoryGirl.define do 
  factory :comment do 
    body "This is the comment body."
    post
    user
  end  
end