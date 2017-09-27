#
# Cookbook Name:: chef_commons
# Provider:: ssl_certs
#

action :create do
  fqdn = new_resource.fqdn

  certs = nil

  unless fqdn.nil?
    begin
      cert_data_bag_item_name = fqdn.gsub(/\.+/, '_')
      certs = data_bag_item("certs", cert_data_bag_item_name, new_resource.secret)
    rescue 
      Chef::Log.warn "Did not find data bag item 'certs' '#{cert_data_bag_item_name}', this could be okay, we will proceed to look for a wildcard cert instead."
    end
  end

  if certs.nil?
    begin
      certs = data_bag_item("certs", "wildcard", new_resource.secret)
    rescue => error
      Chef::Log.warn "Did not find data bag item 'certs' 'wildcard', this could be okay, we will proceed to make a self-singed cert instead."
    end
  end

  trigger_resources = []

  unless certs.nil?
    unless certs[:ssl_cert_chain_file].nil?
      trigger_resources << file(new_resource.ssl_cert_chain_file) do
        action :create
        content certs[:ssl_cert_chain_file].join("\n")
      end
    end

    trigger_resources << file(new_resource.ssl_cert_file) do
      content certs[:ssl_cert_file].join("\n")
    end

    trigger_resources << file(new_resource.ssl_cert_key_file) do
      content certs[:ssl_cert_key_file].join("\n")
    end
  else
    trigger_resources << execute("create-private-key") do
      command "openssl genrsa > #{node[:apache][:ssl_cert_key_file]}"
      not_if "test -f #{node[:apache][:ssl_cert_key_file]}"
    end

    trigger_resources << execute("create-certficate") do
      command "openssl req -new -x509 -key #{node[:apache][:ssl_cert_key_file]} -out #{node[:apache][:ssl_cert_file]} -days 365 <<EOF
US
Earth
Core
Motherscape
DevOps
#{fqdn}
jay.flowers@gmail.com
EOF"
      only_if {IO.popen("openssl x509 -text -in #{node[:apache][:ssl_cert_file]}").grep(/#{fqdn}/).size == 0}
    end
  end

  new_resource.updated_by_last_action(true) if trigger_resources.any? { |ssl_key_resource| ssl_key_resource.updated_by_last_action? }
end