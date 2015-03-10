class GameWizardStep1Validator < ActiveModel::Validator
  def validate(document)
    if document.step1?
      if Game.where(title: document.title).exists? && document.cache_key.starts_with?('new_')
        document.errors[:title] << I18n.t('games.errors.title_taken')
      end
    end
  end
end

