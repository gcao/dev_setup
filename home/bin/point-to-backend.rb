#!/usr/bin/env ruby

HOSTS_BEGIN = "# REMOTE HDAP BEGIN"
HOSTS_END   = "# REMOTE HDAP END"

class Environment < Struct.new(:name, :description, :confluence_page, :domain, :hdap_server, :postgres_server, :_rlayman1_password)
  def initialize *args
    super *args

    if postgres_server == 'same'
      self.postgres_server = hdap_server
    end
  end

  def self.find name
    ENVIRONMENTS.find {|env| env.name == name } or raise "Environment not found: #{name}"
  end

  def pointToMe
    puts "Pointing to #{name}"

    # http://stackoverflow.com/a/27776022
    cmd = "sed '/#{HOSTS_BEGIN}/,/#{HOSTS_END}/d' /etc/hosts"
    puts cmd

    s = `#{cmd}` + <<-HOSTS.gsub(/^\s+/, '')
      #{HOSTS_BEGIN}
      # Pointing to #{name}
      #{hdap_server} hdap-server hdap-server.vocal-dev.com
      #{postgres_server} hdap-postgres hdap-postgres.vocal-dev.com
      #{HOSTS_END}
    HOSTS

    open('/etc/hosts', 'w') do |f|
      f.write(s)
    end
  end
end

DEFAULT = BADGER = Environment.new(
  'badger',
  'DEV:Badger',
  '',
  'my.badger.vocal-dev.com',
  '10.71.20.20',
  'same',
  'Vocal123',
)

QA8 = Environment.new(
  'qa8',
  'QA8/FAT2',
  'https://vocalocity-confluence-tmp.snap.vonagenetworks.net:8446/pages/viewpage.action?pageId=55345183',
  'my.qa8.vocal-qa.com',
  '10.63.224.50',
  '10.63.228.188',
  'vocal123',
)

QA6 = Environment.new(
  'qa6',
  'QA6/PreProd',
  'https://vocalocity-confluence-tmp.snap.vonagenetworks.net:8446/pages/viewpage.action?pageId=60654927',
  'my.vocal-qa.com',
  '10.63.224.50',
  '10.63.228.188',
  'vocal123',
)

ENVIRONMENTS = [BADGER, QA8, QA6]

if $0 == __FILE__
  if ARGV.length == 0
    require 'pp'
    pp ENVIRONMENTS
    DEFAULT.pointToMe
  else
    Environment.find(ARGV[0]).pointToMe
  end
end

