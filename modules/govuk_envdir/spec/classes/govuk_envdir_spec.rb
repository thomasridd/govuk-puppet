require 'rspec'
require_relative '../../../../spec_helper'
require 'rspec-puppet'

describe 'govuk_envdir', :type => :class do
  let(:params) {{
      :env_root    => '/etc/foo',
      :env_d       => 'bar',
  }}

  context  'Create directory structure' do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_file('/etc/foo/bar/').with_ensure('directory') }
  end

end