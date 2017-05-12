# ------------------------------------------------------------------------------
# Copyright (c) 2016, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ------------------------------------------------------------------------------

# Manages WSO2 Data Analytics Server deployment
class wso2das (
  # wso2das specific configuration data
  $analytics_datasources  = $wso2das::params::analytics_datasources,
  $metrics_datasources    = $wso2das::params::metrics_datasources,
  $spark                  = $wso2das::params::spark,
  $is_datasource          = $wso2das::params::is_datasource,
  $single_node_deployment = $wso2das::params::single_node_deployment,
  $ha_deployment          = $wso2das::params::ha_deployment,
  $portal                 = $wso2das::params::portal,

  $remove_file_list       = $wso2am_runtime::params::remove_file_list,
  $packages               = $wso2das::params::packages,
  $template_list          = $wso2das::params::template_list,
  $file_list              = $wso2das::params::file_list,
  $patch_list             = $wso2das::params::patch_list,
  $cert_list              = $wso2das::params::cert_list,
  $system_file_list       = $wso2das::params::system_file_list,
  $directory_list         = $wso2das::params::directory_list,
  $hosts_mapping          = $wso2das::params::hosts_mapping,
  $java_home              = $wso2das::params::java_home,
  $java_prefs_system_root = $wso2das::params::java_prefs_system_root,
  $java_prefs_user_root   = $wso2das::params::java_prefs_user_root,
  $vm_type                = $wso2das::params::vm_type,
  $wso2_user              = $wso2das::params::wso2_user,
  $wso2_group             = $wso2das::params::wso2_group,
  $product_name           = $wso2das::params::product_name,
  $product_version        = $wso2das::params::product_version,
  $platform_version       = $wso2das::params::platform_version,
  $carbon_home_symlink    = $wso2das::params::carbon_home_symlink,
  $remote_file_url        = $wso2das::params::remote_file_url,
  $maintenance_mode       = $wso2das::params::maintenance_mode,
  $install_mode           = $wso2das::params::install_mode,
  $install_dir            = $wso2das::params::install_dir,
  $pack_dir               = $wso2das::params::pack_dir,
  $pack_filename          = $wso2das::params::pack_filename,
  $pack_extracted_dir     = $wso2das::params::pack_extracted_dir,
  $patches_dir            = $wso2das::params::patches_dir,
  $service_name           = $wso2das::params::service_name,
  $service_template       = $wso2das::params::service_template,
  $ipaddress              = $wso2das::params::ipaddress,
  $enable_secure_vault    = $wso2das::params::enable_secure_vault,
  $secure_vault_configs   = $wso2das::params::secure_vault_configs,
  $key_stores             = $wso2das::params::key_stores,
  $carbon_home            = $wso2das::params::carbon_home,
  $pack_file_abs_path     = $wso2das::params::pack_file_abs_path,

  # Templated configuration parameters
  $master_datasources     = $wso2das::params::master_datasources,
  $registry_mounts        = $wso2das::params::registry_mounts,
  $hostname               = $wso2das::params::hostname,
  $mgt_hostname           = $wso2das::params::mgt_hostname,
  $worker_node            = $wso2das::params::worker_node,
  $usermgt_datasource     = $wso2das::params::usermgt_datasource,
  $local_reg_datasource   = $wso2das::params::local_reg_datasource,
  $clustering             = $wso2das::params::clustering,
  $dep_sync               = $wso2das::params::dep_sync,
  $ports                  = $wso2das::params::ports,
  $jvm                    = $wso2das::params::jvm,
  $fqdn                   = $wso2das::params::fqdn,
  $sso_authentication     = $wso2das::params::sso_authentication,
  $user_management        = $wso2das::params::user_management
) inherits wso2das::params {


  validate_hash($analytics_datasources)
  validate_hash($metrics_datasources)
  validate_hash($spark)
  validate_string($is_datasource)
  validate_hash($single_node_deployment)
  validate_hash($ha_deployment)
  validate_hash($portal)

  validate_hash($master_datasources)
  if $registry_mounts != undef {
    validate_hash($registry_mounts)
  }
  validate_string($hostname)
  validate_string($mgt_hostname)
  validate_bool($worker_node)
  validate_string($usermgt_datasource)
  validate_string($local_reg_datasource)
  validate_hash($clustering)
  validate_hash($dep_sync)
  validate_hash($ports)
  validate_hash($jvm)
  validate_string($fqdn)
  validate_hash($sso_authentication)
  validate_hash($user_management)

  class { '::wso2base':
    packages               => $packages,
    template_list          => $template_list,
    file_list              => $file_list,
    patch_list             => $patch_list,
    cert_list              => $cert_list,
    system_file_list       => $system_file_list,
    directory_list         => $directory_list,
    hosts_mapping          => $hosts_mapping,
    java_home              => $java_home,
    java_prefs_system_root => $java_prefs_system_root,
    java_prefs_user_root   => $java_prefs_user_root,
    vm_type                => $vm_type,
    wso2_user              => $wso2_user,
    wso2_group             => $wso2_group,
    product_name           => $product_name,
    product_version        => $product_version,
    platform_version       => $platform_version,
    carbon_home_symlink    => $carbon_home_symlink,
    remote_file_url        => $remote_file_url,
    maintenance_mode       => $maintenance_mode,
    install_mode           => $install_mode,
    install_dir            => $install_dir,
    pack_dir               => $pack_dir,
    pack_filename          => $pack_filename,
    pack_extracted_dir     => $pack_extracted_dir,
    patches_dir            => $patches_dir,
    service_name           => $service_name,
    service_template       => $service_template,
    ipaddress              => $ipaddress,
    enable_secure_vault    => $enable_secure_vault,
    secure_vault_configs   => $secure_vault_configs,
    key_stores             => $key_stores,
    carbon_home            => $carbon_home,
    remove_file_list       => $remove_file_list,
    pack_file_abs_path     => $pack_file_abs_path
  }

  contain wso2base
  contain wso2base::system
  contain wso2base::clean
  contain wso2base::install
  contain wso2base::configure
  contain wso2base::service

  Class['::wso2base'] -> Class['::wso2base::system']
  -> Class['::wso2base::clean'] -> Class['::wso2base::install']
  -> Class['::wso2base::configure'] ~> Class['::wso2base::service']
}
