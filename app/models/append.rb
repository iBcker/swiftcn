class Append < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :topic

end
