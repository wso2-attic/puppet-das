#----------------------------------------------------------------------------
#  Copyright (c) 2016 WSO2, Inc. http://www.wso2.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#----------------------------------------------------------------------------

class wso2das::params {

  if($::use_hieradata == 'true')
  {
    $template_list            = hiera_array('wso2::template_list')
    $post_install_resources   = hiera('wso2::post_install_resources', { } )
    $post_configure_resources = hiera('wso2::post_configure_resources', { } )
    $post_start_resources     = hiera('wso2::post_start_resources', { } )
    $directory_list           = hiera_array('wso2::directory_list')
    $spark                    = hiera('wso2::spark', { } )
    $single_node_deployment   = hiera('wso2::single_node_deployment', { } )
    $ha_deployment            = hiera('wso2::ha_deployment', { } )
    $analytics_datasources    = hiera('wso2::analytics_datasources', { } )
    $metrics_datasources      = hiera('wso2::metrics_datasources', { } )
    $sso_authentication       = hiera('wso2::sso_authentication', { } )
  }
  else
  {
    $base_template_list = $wso2base::params::template_list
    $das_template_list          = [
      'repository/conf/datasources/analytics-datasources.xml',
      'repository/conf/jndi.properties',
      'repository/conf/analytics/spark/spark-defaults.conf',
      'repository/conf/event-processor.xml'
    ]
    $template_list = concat($base_template_list,$das_template_list)

    $base_directory_list = $wso2base::params::directory_list
    $das_directory_list =[
      'dbscripts/identity'
    ]
    $directory_list = concat($base_directory_list,$das_directory_list)

    $post_install_resources             = undef
    $post_configure_resources           = undef
    $post_start_resources               = undef
    $is_datasource                      = 'wso2_carbon_db'
    $platform_version                   = '4.4.0'
    $patch_list                         = []

    $spark ={
      master       => local,
      master_count => 1,
      hostname     => "${::ipaddress}"
    }

    $single_node_deployment ={
      enabled => true
    }

    $ha_deployment ={
      enabled          => false,
      presenter_enabled=> false,
      worker_enabled   => true,
      eventSync        =>{
        hostName => "${::ipaddress}",
        port     => 11224
      },
      management       =>{
        hostName=> "${::ipaddress}",
        port    => 10005
      },
      presentation     =>{
        hostName=> "${::ipaddress}",
        port    => 11000
      }
    }

    # analytics datasources
    $analytics_datasources ={
      wso2_analytics_fs_db                   =>{
        name                          => "WSO2_ANALYTICS_FS_DB",
        description                   => "The datasource used for analytics file system",
        driver_class_name             => "org.h2.Driver",
        url                           => "jdbc:h2:repository/database/ANALYTICS_FS_DB;AUTO_SERVER=TRUE;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000",
        username                      => "wso2carbon",
        password                      => "wso2carbon",
        max_active                    => "50",
        max_wait                      => "60000",
        test_on_borrow                => true,
        default_auto_commit           => false,
        validation_query              => "SELECT 1",
        validation_interval           => "30000",
        default_auto_commit           => false,
        initial_size                  => 0,
        test_while_idle               => true,
        min_evictable_idle_time_millis=> 4000
      },

      wso2_analytics_event_store_db          =>{
        name                          => "WSO2_ANALYTICS_EVENT_STORE_DB",
        description                   => "The datasource used for analytics record store",
        driver_class_name             => "org.h2.Driver",
        url                           => "jdbc:h2:repository/database/ANALYTICS_EVENT_STORE;AUTO_SERVER=TRUE;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000",
        username                      => "wso2carbon",
        password                      => "wso2carbon",
        max_active                    => "50",
        max_wait                      => "60000",
        test_on_borrow                => true,
        default_auto_commit           => false,
        validation_query              => "SELECT 1",
        validation_interval           => "30000",
        default_auto_commit           => false,
        initial_size                  => 0,
        test_while_idle               => true,
        min_evictable_idle_time_millis=> 4000
      },

      wso2_analytics_processed_data_store_db =>{
        name                          => "WSO2_ANALYTICS_PROCESSED_DATA_STORE_DB",
        description                   => "The datasource used for analytics record store",
        driver_class_name             => "org.h2.Driver",
        url                           => "jdbc:h2:repository/database/ANALYTICS_PROCESSED_DATA_STORE;AUTO_SERVER=TRUE;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=60000",
        username                      => "wso2carbon",
        password                      => "wso2carbon",
        max_active                    => "50",
        max_wait                      => "60000",
        test_on_borrow                => true,
        default_auto_commit           => false,
        validation_query              => "SELECT 1",
        validation_interval           => "30000",
        default_auto_commit           => false,
        initial_size                  => 0,
        test_while_idle               => true,
        min_evictable_idle_time_millis=> 4000
      }
    }

    # metrics datasources
    $metrics_datasources ={
      wso2_metrics_db =>{
        name                          => "WSO2_METRICS_DB",
        description                   => "The default datasource used for WSO2 Carbon Metrics",
        driver_class_name             => "org.h2.Driver",
        url                           => "jdbc:h2:repository/database/WSO2METRICS_DB;DB_CLOSE_ON_EXIT=FALSE;AUTO_SERVER=TRUE",
        username                      => "wso2carbon",
        password                      => "wso2carbon",
        jndi_config                   => "jdbc/WSO2MetricsDB",
        datasource                    => "WSO2MetricsDB",
        max_active                    => "50",
        max_wait                      => "60000",
        test_on_borrow                => true,
        default_auto_commit           => false,
        validation_query              => "SELECT 1",
        validation_interval           => "30000"
      }
    }

    # SSO Configuration
    $sso_authentication={
      enabled             => false,
      login_page          => "/carbon/admin/login.jsp",
      service_provider_id => "wso2das",
      sso_service_url     => "https://is.dev.wso2.org:9443/samlsso",
      consumer_service_url=> "https://das.dev.wso2.org:9443/acs"
    }
  }
}
