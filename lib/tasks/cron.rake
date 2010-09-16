task :cron => :environment do
  ts = Time.now
  puts "Delivering..."
  puts Notification.group_and_deliver_delayed!.join("\n")
  puts "Finished in #{Time.now - ts} seconds."
end