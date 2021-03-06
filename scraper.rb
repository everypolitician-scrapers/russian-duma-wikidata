#!/bin/env ruby
# encoding: utf-8

require 'wikidata/fetcher'

ru_6 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ru.wikipedia.org/wiki/Государственная_дума_Федерального_собрания_Российской_Федерации_VI_созыва',
  xpath: '//h2/span[.="Список депутатов"]//following::table[1]//td[1]//a[not(@class="new")]/@title',
)

# This will also pick up lots of things that aren't the people, but
# that's OK; they'll get filtered out later anyway.
ru_7 = EveryPolitician::Wikidata.wikipedia_xpath(
  url: 'https://ru.wikipedia.org/wiki/Список_депутатов_Государственной_думы_Российской_Федерации_VII_созыва',
  after: '//h3/span[.="Депутаты, избранные по партийным спискам"]',
  before: '//h2/span[.="См. также"]',
  xpath: '//a[not(@class="new")]/@title',
)

by_category = WikiData::Category.new('Категория:Депутаты Государственной думы Российской Федерации VII созыва', 'ru').member_titles |
              WikiData::Category.new('Категория:Депутаты Государственной думы Российской Федерации VI созыва', 'ru').member_titles

# Find all P39s of the 6th or 7th Duma
query = <<EOS
  SELECT DISTINCT ?item WHERE {
    ?item p:P39 [ ps:P39 wd:Q17276321 ; pq:P2937 ?term ] .
    ?term p:P31/pq:P1545 ?ordinal FILTER (xsd:integer(?ordinal) >= 6)
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { ru: ru_6 | ru_7 | by_category }, batch_size: 250)

