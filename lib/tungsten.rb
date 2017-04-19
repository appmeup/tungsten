require "tungsten/version"
require 'sshkit'
require 'sshkit/dsl'
include SSHKit::DSL

module Tungsten
  class << self
    def initialize
      puts "Tungsten"
    end
  end
end
