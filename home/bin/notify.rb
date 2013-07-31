#!/usr/bin/env ruby

while line = gets
  if line =~ /FATAL/
    `/Users/gcao/.rvm/gems/ruby-1.9.3-p448@r24/bin/terminal-notifier -group FATAL -message "#{line}"`
  end
end

