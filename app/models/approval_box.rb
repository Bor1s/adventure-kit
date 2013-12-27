class ApprovalBox
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, type: String
  field :approved, type: Mongoid::Boolean, default: false

  belongs_to :user
end
