# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class mongodb_legacy::python {
  package { 'pymongo':
    ensure   => '2.6.3',
    provider => 'pip';
  }
}
