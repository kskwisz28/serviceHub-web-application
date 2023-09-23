class FeedbackEmailMessages < ActiveRecord::Migration[5.2]
  def change
    create_table(:feedback_email_messages) do |t|
      t.timestamps

      t.text(:subject_line)
      t.text(:body)
      t.text(:sender_email)
    end
  end
end
