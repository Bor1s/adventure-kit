class GameWizardStep3Validator < ActiveModel::Validator
  def validate(document)
    if document.step3?
      #For handling error I use two different objects(it is dumb but simple way
      #to avoid greedy strong_params validation)
      #@events_attributes - keeps all proper data (in nested_attributes way) for events
      #@events_ui_ids - keeps dumb id that need to be used by JS FormData to send data properly
      #If any event has errors it will be send back to JS like {'12345': ['Error message']}
      #Here '12345' is UI key to show error 
      if document.events_attributes.present?
        document.events_ui_ids.each_with_index do |id, idx|
          document.errors[id] << 'Must not be blank!' if document.events_attributes[idx][:beginning_at].blank?
        end
      else
        document.errors[:events_attributes] << 'Must be present!'
      end
    end
  end
end

