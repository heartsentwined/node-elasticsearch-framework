# https://github.com/lorenwest/node-config/wiki/Sub-Module-Configuration
process.env.SUPPRESS_NO_CONFIG_WARNING = 'y'
config = require 'config'

elasticsearch = require 'elasticsearch'
async = require 'async'
_ = require 'lodash'

# https://github.com/lorenwest/node-config/wiki/Sub-Module-Configuration
config.util.setModuleDefaults 'elasticsearchFramework',
  host: 'localhost:9200'
  log: 'trace'

# the clone deep - https://github.com/elastic/elasticsearch-js/issues/33
client = new elasticsearch.Client _.cloneDeep config.get 'elasticsearchFramework'

client.indices.safeCreate = (name, cb) ->
  async.waterfall [
    (cb) ->
      client.indices.exists { index: name }, cb

    (exists, status, cb) ->
      return cb null, true, 204 if exists
      client.indices.create { index: name }, cb
  ], cb

client.indices.safeDelete = (name, cb) ->
  async.waterfall [
    (cb) ->
      client.indices.exists { index: name }, cb

    (exists, status, cb) ->
      return cb null, true, 204 unless exists
      client.indices.delete { index: name }, cb
  ], cb

module.exports = client
