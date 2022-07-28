require 'fsp_harvester'
require_relative 'spec_helper'
DescribedBy = String

describe DescribedBy do
  context 'When testing the describedby metric' do
    it 'should find  describedby in full' do
      guid = 'https://w3id.org/a2a-fair-metrics/02-html-full/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_describedby_hrefs(links: links)
      expect(hrefs.length > 0).to be true
    end

    it 'should not find describedby in http citeas only' do
      guid = 'https://w3id.org/a2a-fair-metrics/03-http-citeas-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_describedby_hrefs(links: links)
      expect(hrefs.length == 0).to be true
    end
    it 'should not find describedby in http citeas only and send 004 warning' do
      guid = 'https://w3id.org/a2a-fair-metrics/03-http-citeas-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      warnings = extract_warning_ids(warnings: metadata.warnings)
      expect(warnings.include? '004').to be true
    end

    it 'should not find describedby in html citeas only' do
      guid = 'https://w3id.org/a2a-fair-metrics/18-html-citeas-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_describedby_hrefs(links: links)
      expect(hrefs.length == 0).to be true
    end
    it 'should not find describedby in html citeas only and send 004 warning' do
      guid = 'https://w3id.org/a2a-fair-metrics/18-html-citeas-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      warnings = extract_warning_ids(warnings: metadata.warnings)
      expect(warnings.include? '004').to be true
    end

    it 'should not find type and send a 005 warning' do
      guid = 'https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      warnings = extract_warning_ids(warnings: metadata.warnings)
      expect(warnings.include? '005').to be true
    end

    it 'should accept an IRI as a describedby' do
      guid = 'https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_describedby_hrefs(links: links)
      #expect(hrefs).to be true
      expect(hrefs.length == 1).to be true
    end

    it 'should accept warn that the return content-type of the describedby link is incorrectly reported' do
      guid = 'https://w3id.org/a2a-fair-metrics/11-http-described-iri-wrong-type/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      warnings = extract_warning_ids(warnings: metadata.warnings)
      expect(warnings.include? '009').to be true
    end

    it 'should find the describedby link in a json linkset' do
      guid = 'https://s11.no/2022/a2a-fair-metrics/07-http-describedby-citeas-linkset-json/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_describedby_hrefs(links: links)
      expect(hrefs.length == 1).to be true
    end

    it 'should find the describedby link only in a json linkset' do
      guid = 'https://w3id.org/a2a-fair-metrics/27-http-linkset-json-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_describedby_hrefs(links: links)
      expect(hrefs.length == 1).to be true
    end

    it 'should find the describedby link in a text linkset' do
      guid = 'https://w3id.org/a2a-fair-metrics/28-http-linkset-txt-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_describedby_hrefs(links: links)
      expect(hrefs.length == 1).to be true
    end

    it 'should find the describedby link in a mix of HTTP and HTML headers' do
      guid = 'https://w3id.org/a2a-fair-metrics/22-http-html-citeas-describedby-mixed/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_describedby_hrefs(links: links)
      expect(hrefs.length == 1).to be true
    end

    it 'should find the describedby link in a mix of HTTP http-citeas-describedby-item-license-type-author' do
      guid = 'https://w3id.org/a2a-fair-metrics/23-http-citeas-describedby-item-license-type-author/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_describedby_hrefs(links: links)
      expect(hrefs.length == 1).to be true
    end
    
    it 'should find the profiles on both describedby links' do
      guid = 'https://w3id.org/a2a-fair-metrics/31-http-describedby-profile/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      profiles = extract_describedby_profiles(links: links)
      expect(profiles.length == 2).to be true
    end

  end
end
