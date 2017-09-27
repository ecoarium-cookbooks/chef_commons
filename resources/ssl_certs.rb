#
# Cookbook Name:: chef_commons
# Resource:: ssl_certs
#

actions :create

attribute :fqdn, kind_of: String, :name_attribute => true
attribute :secret, kind_of: String
attribute :ssl_cert_file, kind_of: String
attribute :ssl_cert_key_file, kind_of: String
attribute :ssl_cert_chain_file, kind_of: String

attribute :country, kind_of: String
attribute :state, kind_of: String
attribute :city, kind_of: String
attribute :department, kind_of: String
attribute :organization, kind_of: String
attribute :contact_email, kind_of: String

def initialize(name, run_context=nil)
  super
  @action = :create

  @ssl_cert_file = node[:apache][:ssl_cert_file]
  @ssl_cert_key_file = node[:apache][:ssl_cert_key_file]
  @ssl_cert_chain_file = node[:apache][:ssl_cert_chain_file]

  @country = node[:chef_commons][:ssl_certs][:country]
  @state = node[:chef_commons][:ssl_certs][:state]
  @city = node[:chef_commons][:ssl_certs][:city]
  @department = node[:chef_commons][:ssl_certs][:department]
  @organization = node[:chef_commons][:ssl_certs][:organization]
  @contact_email = node[:chef_commons][:ssl_certs][:contact_email]
end