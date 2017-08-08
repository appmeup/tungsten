require_relative 'test_helper'
require 'tungsten/cli'

class TestCli < Minitest::Test
  describe 'CLI#parse' do
    let(:cli){ Tungsten::CLI.new }

    describe 'without flags' do
      it "should not return error" do
        cli.parse(['tungsten', '-C', 'test/config.rb'])
        assert !cli.options[:config_file].nil?
      end
    end
  end
end
