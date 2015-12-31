#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

ru_names = EveryPolitician::Wikidata.wikipedia_xpath( 
  url: 'https://ru.wikipedia.org/wiki/Государственная_дума_Федерального_собрания_Российской_Федерации_VI_созыва',
  xpath: '//h2/span[.="Список депутатов"]//following::table[1]//td[1]//a[not(@class="new")]/@title',
)

EveryPolitician::Wikidata.scrape_wikidata(names: { ru: ru_names })
warn EveryPolitician::Wikidata.notify_rebuilder

