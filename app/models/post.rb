class Post < ActiveRecord::Base
  def all_tags=(names)
    self.tags = names.split(",").map do |name|
        Tag.where(name: name.strip).first_or_create!
    end
  end
  
  def all_tags
    self.tags.map(&:name).join(", ")
  end
  def self.tagged_with(name)
    Tag.find_by_name!(name).posts
  end
  acts_as_votable
  has_many :taggings
  has_many :tags, through: :taggings
  belongs_to :user
  validates_length_of :caption, :in => 3..800 ,:allow_blank => true, :message => " must be 3 to 800 characters"
  validates :user_id, presence: true
  validates :image, presence: true
  has_attached_file :image, styles: { :medium => "640x" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  has_many :comments, dependent: :destroy
end
