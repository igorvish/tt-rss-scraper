require 'rss'

namespace :rss_feeds do

  #
  # Таск получения и сохранения rss-фида с lenta.ru.
  # Если передать frequency, то будет работать с соответствующим интервалом, 
  # игнорируя возможные исключения.
  # Если вызвать с demonize, то процесс будет демонизирован.
  # Без аргументов таск просто отработает (удобно ставить в крон). 
  #
  desc "Grub feeds from lenta-ru, eg: `rake rss_feeds:grub[5.minutes,false]`"
  task :grub, [:frequency, :demonize] => :environment do |t, args|
    Rails.logger = Logger.new(Rails.root.join('log', "#{t.name.parameterize}.log"))

    # Интервал обновления
    if args.frequency.present?
      frequency = args.frequency.split('.')
      frequency = frequency[0].to_i.send(frequency[1])
    end

    # Демонизация процесса (kill `cat tmp/pids/rss_feeds-grub.pid`)
    if args.demonize == 'true'
      Process.daemon(true, true)
      FileUtils.mkdir_p(Rails.root.join('tmp', 'pids'))
      File.open(Rails.root.join('tmp', 'pids', "#{t.name.parameterize}.pid"), 'w') { |f| f << Process.pid }
      Signal.trap('TERM') { abort }
      Rails.logger.info "#{t.name} started as daemon..."
    end

    begin
      loop do
        
        # Получаем фид

        url = 'https://lenta.ru/rss/news'
        rss = RSS::Parser.parse(url, false)

        # Сохраняем записи, если есть новые

        before_count = RssFeed.count
        if !RssFeed.where(guid: rss.items.first.guid.content).exists?
          updated_at = Time.current
          inserts = rss.items.map do |item|
            ActiveRecord::Base.send(:sanitize_sql, ["(?, ?, ?, ?, ?, ?, ?, ?, ?)",
              item.guid.content,
              item.title,
              item.link,
              item.description,
              item.pubDate,
              item.enclosure.present? ? item.enclosure.as_json.slice('url', 'length', 'type').to_json : nil,
              item.category.content,
              updated_at,
              updated_at,
            ])
          end
          sql = "
            INSERT INTO #{RssFeed.table_name} (
              guid,
              title,
              link,
              description,
              published_at,
              enclosure,
              category,
              created_at,
              updated_at
            )
            VALUES #{inserts.join(',')}
            -- ON CONFLICT (guid) DO NOTHING;
            ON CONFLICT (guid) DO UPDATE SET
              enclosure = excluded.enclosure,
              updated_at = excluded.updated_at;
          "
          ActiveRecord::Base.connection.execute(sql)
        end
        after_count = RssFeed.count

        # Повторяем в цикле, если указано

        abort unless args.frequency.present?
        Rails.logger.debug "Iteration done, #{after_count - before_count} new entries"
        sleep frequency
      end
    rescue SystemExit, Interrupt
      abort
    rescue StandardError => e
      # В случае ошибки - sleep/2 или выброс исключения
      Rails.logger.error(e.inspect + "\n" + e.backtrace.join("\n"))
      sleep(frequency/2) and retry if args.frequency.present?
      raise e
    end
  end

end
