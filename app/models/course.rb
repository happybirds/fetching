class Course < ApplicationRecord
  enum catalog:{
    'math':1,
    'phy':2,
    'bio':3,
    'cs':4
  }

  enum status:{
    '旧':1,
    '新':2
  }
  
end
