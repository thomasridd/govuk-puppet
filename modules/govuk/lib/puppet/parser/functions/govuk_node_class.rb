module Puppet::Parser::Functions
  newfunction(:govuk_node_class, :type => :rvalue, :doc => <<EOS
Return the name to construct a `govuk::node::s_` class based on the variable
`$::trusted['certname']`. Requires `trusted_node_data` to be enabled. Takes
no arguments.

For `puppet agent` this fact will be the FQDN on the certificate signed by
the master. It cannot be spoofed to obtain the catalog/class of another node.

For `puppet apply` the fact will just be the machine's FQDN. It will always
be spoofable because there is no SSL involved.

It does so by taking the first part (the unqualified hostname), stripping
any numeric suffixes, and replacing hyphens (valid for DNS) with underscores
(valid for Puppet class names).
EOS
  ) do |args|

    raise(
      Puppet::ParseError,
      "govuk_node_class: Wrong number of arguments given #{args.size} for 0."
    ) unless args.size == 0

    # http://docs.puppetlabs.com/puppet/3/reference/lang_variables.html#trusted-node-data
    trusted_hash = lookupvar('::trusted')
    raise(
      Puppet::ParseError,
      "govuk_node_class: Unable to lookup $::trusted - is trusted_node_data enabled?"
    ) if trusted_hash.nil? or trusted_hash.empty?

    hostname = trusted_hash['certname']
    raise(
      Puppet::ParseError,
      "govuk_node_class: Unable to lookup $::trusted['certname']"
    ) if hostname.nil? or hostname.empty?

    node_class_fact = lookupvar('node_class')

    if node_class_fact.nil? or node_class_fact.empty?
      class_name = hostname.split('.').first.gsub(/-\d+$/, '')
      class_name.gsub!('-', '_')
    else
      class_name = node_class_fact
    end

    class_name
  end
end
