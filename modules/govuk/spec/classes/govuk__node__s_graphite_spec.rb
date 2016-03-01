require_relative '../../../../spec_helper'

describe 'govuk::node::s_graphite', :type => :class do
  let(:node) { 'graphite-1.management.somethingsomething' }
  let(:pre_condition) { '$concat_basedir = "/tmp"' }

  context 'when standalone statsd enabled (default)' do
    it 'includes the appropriate storage schema' do
      is_expected.to contain_file('/opt/graphite/conf/storage-aggregation.conf').
        with_content(/pattern = \^stats\.\*/)
    end
  end

  context 'when stanadlone statsd disabled' do
    let(:params) {{ standalone_statsd: false }}

    it 'uses the default storage schema' do
      is_expected.to contain_file('/opt/graphite/conf/storage-aggregation.conf').
        without_content(/pattern = \^stats\.\*/)
    end
  end
end
