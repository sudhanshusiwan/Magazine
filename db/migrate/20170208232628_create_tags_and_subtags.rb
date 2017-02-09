class CreateTagsAndSubtags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      # limit of 100 because tag should not be bigger than that, and indexing on big strings is not good
      t.string :tag_string,              null: false, limit: 100

      t.timestamps null: false
    end

    # Tag string should be unique
    add_index :tags, :tag_string, unique: true

    create_table :sub_tags do |t|
      # limit of 100 because tag should not be bigger than that, and indexing on big strings is not good
      t.string  :sub_tag_string,          null: false, limit: 100
      t.integer :tag_id,                  null: false

      t.timestamps null: false
    end

    # index sub_tag on tag_id and sub_tag_string
    add_index :sub_tags, :tag_id
    add_index :sub_tags, :sub_tag_string, unique: true

    # join table for article and tags
    create_table :articles_tags do |t|
      t.integer :article_id
      t.integer :tag_id

      t.timestamps null: false
    end

    # there should not be any duplicate association record in join table, so uniqueness constraint on tag_id and article_id
    add_index :articles_tags, [:article_id, :tag_id], unique: true

    # Join table for articles and subtags
    create_table :articles_sub_tags do |t|
      t.integer :article_id
      t.integer :sub_tag_id

      t.timestamps null: false
    end

    # there should not be any duplicate association record in join table, so uniqueness constraint on sub_tag_id and article_id
    add_index :articles_sub_tags, [:article_id, :sub_tag_id], unique: true
  end
end
