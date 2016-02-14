class ChangeColumnMatches < ActiveRecord::Migration
  def change
    rename_column :matches, :my_id, :user_id
    add_index :matches, :user_id
  end
end
