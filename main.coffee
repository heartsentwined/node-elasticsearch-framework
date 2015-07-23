# https://github.com/lorenwest/node-config/wiki/Sub-Module-Configuration
process.env.SUPPRESS_NO_CONFIG_WARNING = 'y'
config = require 'config'

elasticsearch = require 'elasticsearch'
_ = require 'lodash'

# https://github.com/lorenwest/node-config/wiki/Sub-Module-Configuration
config.util.setModuleDefaults 'elasticsearchFramework',
  host: 'localhost:9200'
  log: 'trace'

# the clone deep - https://github.com/elastic/elasticsearch-js/issues/33
client = new elasticsearch.Client _.cloneDeep config.get 'elasticsearchFramework'

module.exports = client
