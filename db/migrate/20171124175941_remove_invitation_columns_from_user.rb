class RemoveInvitationColumnsFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_columns :users, :invitation_created_at, :invitation_sent_at, :invitation_accepted_at,
      :invitation_limit, :invited_by_type, :invitation_token, :invited_by_id
  end
end
