require_relative '../../../../spec_helper'

describe 'statsd', :type => :class do
  context "graphite_hostname => graphite.example.com" do
    let(:params) {{
      :graphite_hostname => 'graphite.example.com',
    }}

    context 'when enabled (default)' do
      it { is_expected.to contain_package('statsd').with_ensure('latest') }
      it { is_expected.to contain_service('statsd').with_ensure('running') }

      it { is_expected.to contain_file('/etc/statsd.conf').with_content(/ graphiteHost: "graphite.example.com"$/) }
    end

    context 'when disabled' do
    let(:params) {{ :enable => false }}
      it { is_expected.to contain_package('statsd').with_ensure('absent') }
      it { is_expected.to contain_service('statsd').with_ensure('stopped') }

      it { is_expected.not_to contain_file('/etc/statsd.conf').with_content(/ graphiteHost: "graphite.example.com"$/) }
    end

  end
end
