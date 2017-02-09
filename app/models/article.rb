class Article < ActiveRecord::Base
  belongs_to :owner, class_name: 'User'
  has_and_belongs_to_many :tags, :uniq => true
  has_and_belongs_to_many :sub_tags, :uniq => true

  validates :name, :description, :owner, :presence => true

  # This method returns the comma separated strings with list of tags and subtags in article
  def get_tags_and_subtags_hash
    {
      tags: self.tags.pluck(:tag_string).join(', '),
      sub_tags: self.sub_tags.pluck(:sub_tag_string).join(', ')
    }
  end

  # this method checks if search string is present then return the result according to search parameter
  # Otherwise return all records
  # Here I am eager loading owner of articles, this is for avoiding n+1 query, while checking for owner
  # I am also ordering articles by created_at in descending order
  def self.search(search)
    if search.present?
      # if search parameter present then first downcase it, because we should return results irrespective of case of string
      # After that split all words in search term to array, because a search term can half be present in tag or description
      # and half can be present in subtag or title, or anywhere, so check for all possible places for each word
      # Now, join tags and subtags table with articles and check for array of strings to be like article.name, article.description
      # tag.tag_string and sub_tag.subtag_string all in downcase and if anyone matches return the record
      search.downcase!
      search_array = search.strip.split(' ')
      myarray_with_percetage_signs = search_array.map {|val| "%#{val}%" }

      joins(:tags, :sub_tags).includes(:owner).where('lower(articles.name) ILIKE ANY ( array[?] ) OR lower(articles.description) ILIKE ANY ( array[?] ) OR lower(tags.tag_string) ILIKE ANY ( array[?] ) OR lower(sub_tags.sub_tag_string) ILIKE ANY ( array[?] )', myarray_with_percetage_signs, myarray_with_percetage_signs, myarray_with_percetage_signs, myarray_with_percetage_signs ).order('articles.created_at DESC')
    else
      self.includes(:owner).all.order('created_at DESC')
    end
  end

  # this method update articles by taking article parameters, updated tag_ids and sub_tag_ids
  def update_with_tags(article_params, tag_ids, sub_tag_ids)
    # Load all tags from tag ids and load subtags of it to avoid n+1 query while fetching subtags for individual tags
    tags = Tag.where(id: tag_ids).includes(:sub_tags)

    # load article tags and subtags
    article_tags = self.tags
    article_sub_tags = self.sub_tags

    # new tags will be tags mapped to article on edit page - tags already associated with article
    new_tags = tags - article_tags

    # deleted tags will be tags already associated with article - tags mapped to article on edit page
    deleted_tags = article_tags - tags

    if tags.present? && sub_tag_ids.present?
      article_sub_tag_ids = article_sub_tags.map(&:id)

      # Convert subtag_ids to integer array, because we need to compare it with integer to load subtags under tags
      sub_tag_ids = sub_tag_ids.map(&:to_i) rescue []

      # Note: Here I am only subtags which are present under the tags, and here I need to select because
      # frontend functionality for filtering subtags according to tag is not complete
      # And I need to reject tags which are already associated with article
      new_sub_tags = tags.flat_map{ |tag| tag.sub_tags.select { |sub_tag| sub_tag_ids.include?(sub_tag.id) } }
      new_sub_tags.reject! { |sub_tag| article_sub_tag_ids.include?(sub_tag.id) }
    end

    sub_tags = SubTag.where(id: sub_tag_ids)

    deleted_sub_tags = []
    # put all subtags in deleted tags in deleted_sub_tags list
    deleted_sub_tags += deleted_tags.map(&:sub_tags) if deleted_tags.present?

    # add sub_tags already associated with article - sub_tags mapped to article on edit page to deleted subtags list
    deleted_sub_tags += article_sub_tags - sub_tags if sub_tag_ids.present?

    transaction do
      self.update_attributes!(article_params)

      self.tags << new_tags if new_tags.present?
      # here using delete to just remove association from article to tag not actual tag record
      self.tags.delete(deleted_tags) if deleted_tags.present?

      self.sub_tags << new_sub_tags if new_sub_tags.present?
      # here using delete to just remove association from article to sub_tag not actual sub_tag record
      self.sub_tags.delete(deleted_sub_tags) if deleted_sub_tags.present?
    end
  end
end