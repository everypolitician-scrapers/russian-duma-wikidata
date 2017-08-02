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

# Find all P39s of the 7th Term
query = <<EOS
  SELECT DISTINCT ?item
  WHERE
  {
    BIND(wd:Q17276321 AS ?membership)
    BIND(wd:Q26708541 AS ?term)

    ?item p:P39 ?position_statement .
    ?position_statement ps:P39 ?membership .
    ?position_statement pq:P2937 ?term .
  }
EOS
p39s = EveryPolitician::Wikidata.sparql(query)

EveryPolitician::Wikidata.scrape_wikidata(ids: p39s, names: { ru: ru_6 | ru_7 | by_category })

