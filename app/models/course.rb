class Course < ApplicationRecord
  enum catalog:{
    'math':1,
    'phy':2,
    'bio':3,
    'cs':4,
    'cs3420':5,
    'cs2910':6,
    'cs2820':7,
    'cs2060':8,

  }

  enum status:{
    '旧':1,
    '新':2
  }
  
end
