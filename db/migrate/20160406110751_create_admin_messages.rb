class CreateAdminMessages < ActiveRecord::Migration
  def change
    create_table :admin_messages do |t|
      t.string :msg
      t.string :msgType

      t.timestamps null: false
    end
  end
end
