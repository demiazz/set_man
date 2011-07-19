class SetManCreate<%= table_name.camelize %> < ActiveRecord::Migration
  def self.up
    create_table :<%= table_name %> do |t|
      t.string :name
      t.text :value
      t.string :klass
    end

    add_index :<%= table_name %>, :name, :unique => true
  end

  def self.down
    drop_table :<%= table_name %>
  end
end
