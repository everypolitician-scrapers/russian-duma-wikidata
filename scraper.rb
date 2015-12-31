#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'
require 'nokogiri'
require 'pry'
require 'open-uri/cached'
OpenURI::Cache.cache_path = '.cache'


def noko_for(url)
  Nokogiri::HTML(open(URI.escape(URI.unescape(url))).read) 
end

def wikinames_from(url)
  noko = noko_for(url)
  sd = 'Список депутатов'
  names = noko.xpath('//h2/span[.="Список депутатов"]//following::table[1]//td[1]//a[not(@class="new")]/@title').map(&:text).uniq
  raise "No names found in #{url}" if names.count.zero?
  return names
end

ru_names = wikinames_from('https://ru.wikipedia.org/wiki/%D0%93%D0%BE%D1%81%D1%83%D0%B4%D0%B0%D1%80%D1%81%D1%82%D0%B2%D0%B5%D0%BD%D0%BD%D0%B0%D1%8F_%D0%B4%D1%83%D0%BC%D0%B0_%D0%A4%D0%B5%D0%B4%D0%B5%D1%80%D0%B0%D0%BB%D1%8C%D0%BD%D0%BE%D0%B3%D0%BE_%D1%81%D0%BE%D0%B1%D1%80%D0%B0%D0%BD%D0%B8%D1%8F_%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D0%B9%D1%81%D0%BA%D0%BE%D0%B9_%D0%A4%D0%B5%D0%B4%D0%B5%D1%80%D0%B0%D1%86%D0%B8%D0%B8_VI_%D1%81%D0%BE%D0%B7%D1%8B%D0%B2%D0%B0')

EveryPolitician::Wikidata.scrape_wikidata(names: { ru: ru_names })
warn EveryPolitician::Wikidata.notify_rebuilder

