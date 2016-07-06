// https://github.com/lorenwest/node-config/wiki/Sub-Module-Configuration
process.env.SUPPRESS_NO_CONFIG_WARNING = 'y'
var config = require('config')

var elasticsearch = require('elasticsearch')
var async = require('async')
var _ = require('lodash')

// https://github.com/lorenwest/node-config/wiki/Sub-Module-Configuration
config.util.setModuleDefaults('elasticsearchFramework', {
  host: 'localhost:9200',
  log: 'trace'
})

// the clone deep - https://github.com/elastic/elasticsearch-js/issues/33
var client = new elasticsearch.Client(_.cloneDeep(config.get('elasticsearchFramework')))

client.indices.safeCreate = function (name, cb) {
  async.waterfall([
    function (cb) { client.indices.exists({ index: name }, cb) },

    function (exists, status, cb) {
      if (exists) return cb(null, true, 204)
      client.indices.create({ index: name }, cb)
    }
  ], cb)
}

client.indices.safeDelete = function (name, cb) {
  async.waterfall([
    function (cb) { client.indices.exists({ index: name }, cb) },

    function (exists, status, cb) {
      if (!exists) return cb(null, true, 204)
      client.indices.delete({ index: name }, cb)
    }
  ], cb)
}

module.exports = client
