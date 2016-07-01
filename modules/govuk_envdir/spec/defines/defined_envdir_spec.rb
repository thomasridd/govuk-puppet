require 'rspec'
require_relative '../../../../spec_helper'
require 'rspec-puppet'

 describe 'govuk_envdir::env_file', :type => :define do
   let(:pre_cond) {'file { "/etc/foo/bar/" :
                      ensure => directory,
                    }'}

   let(:title) {'env_file'}
   let(:params) {{
      :owner    => 'ralph',
      :key      => 'yale',
      :value    => 'lock',
      :path     => '/etc/foo/bar',
   }}

   context  'Create Env_File' do
     it { is_expected.to compile.with_all_deps }
     it { is_expected.to contain_file('/etc/foo/bar/').with_ensure('directory') }
     it { is_expected.to contain_file('yale').with_path('/etc/foo/bar/yale').with_content('lock') }
     it { is_expected.to contain_file('yale').with_path('/etc/foo/bar/yale').with_owner('ralph') }
   end

 end
