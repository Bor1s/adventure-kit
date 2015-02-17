require 'rails_helper'

RSpec.describe GameWizardService, type: :service do
  it 'valid on step 1' do
    step = 1
    cache_key = nil
    attributes = {title: 'title', description: 'desc'}
    service = GameWizardService.new(cache_key, step, attributes)
    expect(service.valid?).to eq true
  end
end
