require 'fsp_harvester'
require_relative 'spec_helper'

Item = String

describe Item do
  context 'When testing the item metric' do

    it 'should find item in full' do
      guid = 'https://w3id.org/a2a-fair-metrics/02-html-full/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_item_hrefs(links: links)
      expect(hrefs.length == 1).to be true
    end

    it 'should find item types' do
      guid = 'https://w3id.org/a2a-fair-metrics/02-html-full/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      types = extract_item_types(links: links)
      expect(types.length == 1).to be true
    end

    it 'should find item in full' do
      guid = 'https://w3id.org/a2a-fair-metrics/03-http-citeas-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_item_hrefs(links: links)
      expect(hrefs.length == 0).to be true
    end

    it 'should warn 014 when item does not resolve' do
      guid = 'https://w3id.org/a2a-fair-metrics/12-http-item-does-not-resolve/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      warnings = extract_warning_ids(warnings: metadata.warnings)
      expect(warnings.include? '014').to be true
    end

    it 'should find item in linkset json' do
      guid = 'https://s11.no/2022/a2a-fair-metrics/07-http-describedby-citeas-linkset-json/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_item_hrefs(links: links)
      expect(hrefs.length == 1).to be true
    end

    it 'should find items in linkset json' do
      guid = 'https://s11.no/2022/a2a-fair-metrics/07-http-describedby-citeas-linkset-json/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_item_hrefs(links: links)
      expect(hrefs.length == 1).to be true
    end


    it 'should find items in linkset text format' do
      guid = 'https://w3id.org/a2a-fair-metrics/28-http-linkset-txt-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_item_hrefs(links: links)
      expect(hrefs.length == 1).to be true
    end


    it 'should find items in linkset text format' do
      guid = 'https://s11.no/2022/a2a-fair-metrics/29-http-500-server-error/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_item_hrefs(links: links)
      expect(hrefs.length == 0).to be true
    end



  end
end
