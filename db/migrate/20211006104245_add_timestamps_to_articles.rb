class AddTimestampsToArticles < ActiveRecord::Migration[6.1]
  def change
    # Method   :Table,    :attribute,  :type
    add_column :articles, :created_at, :datetime
    add_column :articles, :updated_at, :datetime
  end
end
