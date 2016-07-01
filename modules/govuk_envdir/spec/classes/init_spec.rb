require_relative '../../../../spec_helper'
describe 'govuk_envdir' do

  context 'with defaults for all parameters' do
    it { should contain_class('govuk_envdir') }
  end
end
