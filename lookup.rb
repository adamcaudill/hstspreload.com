require 'json'
require 'sqlite3'
require 'wannabe_bool'

class Lookup
  def self.get_status(domain)
    begin
      db = SQLite3::Database.open File.dirname(__FILE__) + '/data/preload_status.db'
      db.results_as_hash = true

      #strip a leading "www." if present
      if domain.start_with? 'www.'
        domain.slice! 'www.'
      end

      chrome = get_browser_status db, 'chrome', domain
      firefox = get_browser_status db, 'firefox', domain
      tor = get_browser_status db, 'tor', domain
    ensure
      db.close if db
    end

    res = {:domain => domain, :chrome =>  chrome, :firefox => firefox, :tor => tor}

    res.to_json
  end

  def self.get_browser_status(db, browser, domain)
    res = nil

    db.execute("select domain, status, include_subdomains, last_update from #{browser} where domain = :domain and status = 1",
               'domain' => domain) do |row|
      res = {:present => true, :include_subdomains => row['include_subdomains'].to_b, :last_updated => row['last_update']}
    end

    return res
  end

  private_class_method :get_browser_status
end
