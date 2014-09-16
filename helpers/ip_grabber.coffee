Os = require "os"

exports.local = ->
  interfaces = Os.networkInterfaces()
  addresses = []

  for k of interfaces
    for k2 of interfaces[k]
      address = interfaces[k][k2]
      if address.family is "IPv4" and not address.internal
        addresses.push address.address

  addresses[0]