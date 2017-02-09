class Tag < ActiveRecord::Base
  has_many :sub_tags
  has_and_belongs_to_many :articles, :uniq => true

  validates :tag_string, presence: true
  validates :tag_string, uniqueness: true
end