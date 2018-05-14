#
# Cookbook:: sp_openvpn
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

# directory '/etc/openvpn' do
#   owner 'root'
#   group 'root'
#   mode '0755'
#   action :create
# end
#
# directory '/etc/openvpn/server.up.d' do
#   owner 'root'
#   group 'root'
#   mode '0755'
#   action :create
# end

# template '/etc/openvpn/server.up.d/ipv6.sh' do
#   source 'server.up.ipv6.sh.erb'
#   owner 'root'
#   group node['openvpn']['root_group']
#   mode  '0755'
#   notifies :restart, 'service[openvpn]'
# end

# template '/etc/openvpn/server.up.d/iptables.sh' do
#   source 'server.up.iptables.sh.erb'
#   owner 'root'
#   group node['openvpn']['root_group']
#   mode  '0755'
#   notifies :restart, 'service[openvpn]'
# end

node.override['firewall']['ubuntu_iptables'] = true
node.override['firewall']['allow_loopback'] = true
node.override['firewall']['allow_ssh'] = true
node.override['firewall']['allow_established'] = true

node.default['firewall']['iptables']['defaults'][:ruleset] = {
  '*filter' => 1,
  ':INPUT DROP' => 2,
  ':FORWARD DROP' => 3,
  ':OUTPUT ACCEPT_FILTER' => 4,
  'COMMIT_FILTER' => 100,
  '*nat' => 101,
  ':PREROUTING DROP' => 102,
  ':POSTROUTING DROP' => 103,
  ':OUTPUT ACCEPT_NAT' => 104,
  'COMMIT_NAT' => 200
}

include_recipe "firewall"

# firewall_rule "ssh" do
#   port     22
#   command  :allow
# end

# firewall_rule "local-in" do
#   raw "-A INPUT -i lo -j ACCEPT"
# end
#
# firewall_rule "local-out" do
#   raw "-A OUTPUT -o lo -j ACCEPT"
# end

firewall_rule "ipv4-nat" do
  # direction :post
  # source "10.8.0.0/16"
  # dest_interface "eth0"
  # command :masquerade
  raw "-A POSTROUTING -s 10.8.0.0/16 -o eth0 -j MASQUERADE"
  position 150
end

# firewall_rule "ipv6-nat" do
#   raw "-t nat -A POSTROUTING -s fd00::/112 -j SNAT --to #{node['cloud_v2']['public_ipv6']}"
#   protocol :ipv6
# end

# node.override['openvpn']['key']['org'] = 'Spol Corp.'
# node.override['openvpn']['key']['email'] = 'seb@spol.co'
#
# node.override["openvpn"]["push_options"] = {
#       "dhcp-option" => [
#         "DNS 8.8.8.8",
#         "DNS 1.1.1.1",
#         "DNS 2001:4860:4860::8888",
#         "DNS 2001:4860:4860::8844",
#       ],
#       "redirect-gateway" => "def1 bypass-dhcp",
#       "route-ipv6" => "::/0"
#     };
#
# node.override['openvpn']['config']['server-ipv6'] = 'fd00::/112'
# node.override['openvpn']['config']['proto'] = 'udp6'
# node.override['openvpn']['config']['dev'] = 'tun'
#
#
# node.default['openvpn']['config'].delete('local')
#
# include_recipe 'openvpn::server'
# include_recipe 'openvpn::users'

# service "ufw" do
#   supports :status => true, :restart => true, :reload => false
# end
#
# node.override['firewall']['rules'] = [{
#   'openvpn' => {
#     'port' => '1194',
#     'protocol' => 'udp',
#   }
# }]
#
# node.override['firewall']['configuration'] = {
#   'DEFAULT_FORWARD_POLICY' => 'ACCEPT',
# }
# # This should be the default in the ufw cookbook but the PR isn't merged yet.
# node.override['firewall']['configuration_file'] = "/etc/default/ufw"
#
# include_recipe 'ufw'
# include_recipe 'sp_openvpn::ufw_configure'
