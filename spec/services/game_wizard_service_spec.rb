require 'rails_helper'

RSpec.describe GameWizardService, type: :service do
  it 'valid on step 1' do
    service = GameWizardService.new(title: 'title', description: 'desc', step: 1)
    expect(service.valid?).to eq true
  end
end
