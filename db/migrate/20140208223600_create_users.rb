class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :uid
      t.string :email
      t.string :name
      t.string :surname
      t.string :avatar

      t.timestamps
    end
  end
end
