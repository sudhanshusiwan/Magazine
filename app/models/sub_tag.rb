class SubTag < ActiveRecord::Base
  belongs_to :tag
  has_and_belongs_to_many :articles, :uniq => true

  validates :sub_tag_string, :tag, presence: true
  validates :sub_tag_string, uniqueness: true
end