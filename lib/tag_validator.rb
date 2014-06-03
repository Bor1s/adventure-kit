class TagValidator < ActiveModel::Validator
  def validate(document)
    if document.title.match /\s+/
      document.errors[:title] << 'Название не должно содержать пробелов!'
    end
  end
end
