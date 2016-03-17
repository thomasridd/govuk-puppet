# -*- mode: ruby -*-
# vi: set ft=ruby :

require_relative 'load_nodes'

min_required_vagrant_version = '1.3.0'

# Construct box name and URL from distro and version.
def get_box(dist, version, provider)
  dist    ||= "trusty"
  version ||= "20141112"

  if provider == "vmware_fusion"
    name  = "govuk_dev_#{dist}64_vmware_fusion_#{version}"
  else
    name  = "govuk_dev_#{dist}64_#{version}"
  end
  url   = "http://gds-boxes.s3.amazonaws.com/#{name}.box"

  return name, url
end

if Vagrant::VERSION < min_required_vagrant_version
  $stderr.puts "ERROR: Puppet now requires Vagrant version >=#{min_required_vagrant_version}. Please upgrade.\n"
  exit 1
end

nodes = load_nodes()
Vagrant.configure("2") do |config|
  # Enable vagrant-cachier if available.
  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.auto_detect = true
  end

  config.ssh.shell = 'bash'

  synced_folder = {
    source: '..',
    destination: '/var/govuk',
    nfs: ENV['VAGRANT_GOVUK_NFS'] == "no" ? false : true,
  }

  if ENV['VAGRANT_GOVUK_AWS'] == 'true'
    synced_folder = {
      source: '.',
      destination: '/var/govuk/govuk-puppet',
    }
  end

  nodes.each do |node_name, node_opts|
    config.vm.define node_name do |c|
      box_name, box_url = get_box(
        node_opts["box_dist"],
        node_opts["box_version"],
        "virtualbox"
      )
      c.vm.box = box_name
      c.vm.box_url = box_url
      c.vm.hostname = "#{node_name}.dev.gov.uk"
      c.vm.network :private_network, {
        :ip => node_opts["ip"],
        :netmask => "255.000.000.000"
      }

      modifyvm_args = ['modifyvm', :id]

      # Mitigate boot hangs.
      modifyvm_args << "--rtcuseutc" << "on"

      # Isolate guests from host networking.
      modifyvm_args << "--natdnsproxy1" << "on"
      modifyvm_args << "--natdnshostresolver1" << "on"

      if node_opts.has_key?("memory")
        modifyvm_args << "--memory" << node_opts["memory"]
      end

      c.vm.provider(:virtualbox) { |vb| vb.customize(modifyvm_args) }

      c.vm.provider(:vmware_fusion) do |vf, override|
        if node_opts.has_key?("memory")
          vf.vmx["memsize"] = node_opts["memory"]
        end
        vf.vmx["displayName"] = node_name
        override.vm.box, override.vm.box_url = get_box(
          node_opts["box_dist"],
          node_opts["box_version"],
          "vmware_fusion"
        )
      end

      c.vm.provider(:aws) do |aws, override|
        override.vm.box = 'dummy'
        override.vm.box_url = 'https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box'

        aws.access_key_id = ENV['AWS_ACCESS_KEY_ID']
        aws.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
        aws.ami = 'ami-4456ec37'
        aws.region = 'eu-west-1'
        aws.instance_type = 't2.small'
        aws.security_groups = ['alexmuller_allow_ssh']
        aws.keypair_name = 'alexmuller_test_vagrant'

        aws.tags = {
          'Name' => node_name,
          'Owner' => ENV['USER'],
        }

        override.ssh.username = 'ubuntu'
        override.ssh.private_key_path = "~/.ssh/alexmuller_test_vagrant.pem"
      end

      if synced_folder[:nfs]
        c.vm.synced_folder synced_folder[:source], synced_folder[:destination], :nfs => true
      else
        c.vm.synced_folder synced_folder[:source], synced_folder[:destination]
      end

      # These can't be NFS because OSX won't export overlapping paths.
      c.vm.synced_folder "gpg", "/etc/puppet/gpg", :owner => 'puppet', :group => 'puppet'
      # Additional shared folders for Puppet Master nodes.
      if node_name =~ /^puppetmaster/
        c.vm.synced_folder ".", "/usr/share/puppet/production/current"
      end

      # run a script to partition extra disks for lvm if they exist.
      c.vm.provision :shell, :inline => "/var/govuk/govuk-puppet/tools/partition-disks"

      if ENV['VAGRANT_GOVUK_AWS'] == 'true'
        facter_dir = '/etc/facter/facts.d'
        node_class = node_name.split('.').first.gsub(/-\d+$/, '')
        c.vm.provision :shell, :inline => "mkdir -p #{facter_dir} && echo 'node_class=#{node_class}' > #{facter_dir}/node_class.txt"
        c.vm.provision :shell, :inline => "gem install --no-ri --no-rdoc hiera-eyaml-gpg gpgme"
      end

      c.vm.provision :shell, :inline => "ENVIRONMENT=vagrant /var/govuk/govuk-puppet/tools/puppet-apply #{ENV['VAGRANT_GOVUK_PUPPET_OPTIONS']}"
    end
  end
end
