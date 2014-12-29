class GameWizardStep2Validator < ActiveModel::Validator
  def validate(document)
    if document.step2?
      if document.online_game?
        document.errors[:online_info] << 'Online info error!' unless document.online_info.present?
      else
        document.errors[:address] << 'Address error!' unless document.address.present?
      end
    end
  end
end

