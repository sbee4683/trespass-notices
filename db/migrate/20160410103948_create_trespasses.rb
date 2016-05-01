class CreateTrespasses < ActiveRecord::Migration
  def change
    create_table :trespasses do |t|
      t.string :caseNum
      t.string :locationName
      t.string :locationAddr
      t.string :subjName
      t.date :subjDOB
      t.date :dateOfNotification
      t.date :dateOfExpiration
      t.boolean :archived
      t.integer :modifiedBy

      t.timestamps null: false
    end
  end
end
