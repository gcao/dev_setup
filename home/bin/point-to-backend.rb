#!/usr/bin/env ruby

HOSTS_BEGIN = "# REMOTE HDAP BEGIN"
HOSTS_END   = "# REMOTE HDAP END"

class Environment < Struct.new(
                                :name,
                                :description,
                                :confluence_page,
                                :domain,
                                :hdap_server,
                                :postgres_server,
                                :_rlayman1_password
                              )
  def initialize *args
    super *args

    if postgres_server == 'same'
      self.postgres_server = hdap_server
    end
  end

  def self.find name
    ENVIRONMENTS.find {|env| env.name == name } or raise "Environment not found: #{name}"
  end

  def self.current
    if `grep 'Pointing to ' /etc/hosts` =~ /^\s*# Pointing to (\w+)\s*$/
      find $1
    end
  end

  def pointToMe
    puts "Pointing to #{name}"

    # http://stackoverflow.com/a/27776022
    cmd = "sed '/#{HOSTS_BEGIN}/,/#{HOSTS_END}/d' /etc/hosts"
    puts cmd

    s = `#{cmd}` + <<-HOSTS.gsub(/^\s+/, '')
      #{HOSTS_BEGIN}
      # Pointing to #{name}
      #{hdap_server}	hdap-server	hdap-server.vocal-dev.com
      #{postgres_server}	hdap-postgres	hdap-postgres.vocal-dev.com
      #{HOSTS_END}
    HOSTS

    open('/etc/hosts', 'w') do |f|
      f.write(s)
    end

    `sudo /usr/sbin/apachectl restart`
  end
end

DEFAULT = TURKEY = Environment.new(
  'turkey',
  'DEV: Turkey',
  '',
  'my.turkey.vocal-dev.com',
  '10.71.21.190',
  'same',
  'Vocal123',
)

BADGER = Environment.new(
  'badger',
  'DEV: Badger',
  '',
  'my.badger.vocal-dev.com',
  '10.71.20.134',
  'same',
  'Vocal123',
)

PANTHER = Environment.new(
  'panther',
  'DEV: Panther',
  '',
  'my.panther.vocal-dev.com',
  '10.71.20.226',
  'same',
  'Vocal123',
)

QA6 = Environment.new(
  'qa6',
  'QA6 / PreProd (must connect to Virginia VPN)',
  'https://vocalocity-confluence-tmp.snap.vonagenetworks.net:8446/pages/viewpage.action?pageId=60654927',
  'my1.vocal-qa.com',
  '10.62.240.114',
  '10.62.243.231',
  'vocal123',
)

QA7 = Environment.new(
  'qa7',
  'QA7 / FAT1 (must connect to Virginia VPN)',
  'https://vocalocity-confluence-tmp.snap.vonagenetworks.net:8446/pages/viewpage.action?pageId=38535172',
  'my2.vocal-qa.com',
  '10.63.232.231',
  '10.62.235.235',
  'Vocal123',
)

QA8 = Environment.new(
  'qa8',
  'QA8 / FAT2 (must connect to Oregon VPN)',
  'https://vocalocity-confluence-tmp.snap.vonagenetworks.net:8446/pages/viewpage.action?pageId=55345183',
  'my.qa8.vocal-qa.com',
  '10.63.224.50',
  '10.63.228.188',
  'vocal123',
)

ENVIRONMENTS = [TURKEY, BADGER, PANTHER, QA7, QA8, QA6]

if $0 == __FILE__
  if ARGV.length == 0
    require 'pp'
    pp ENVIRONMENTS

    current = Environment.current
    if current
      puts "Pointing to #{current.name}"
    else
      puts "Not pointing to any environment"
    end

    #DEFAULT.pointToMe
  else
    Environment.find(ARGV[0]).pointToMe
  end
end

