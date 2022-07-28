require 'fsp_harvester'
require_relative 'spec_helper'
CiteAs = String
  
describe CiteAs do
  context "When testing the FSP Harvester cite-as functions" do
    it 'should find cite-as https://w3id.org/a2a-fair-metrics/03-http-citeas-only/' do
      guid = 'https://w3id.org/a2a-fair-metrics/03-http-citeas-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end

    it 'should find cite-as https://w3id.org/a2a-fair-metrics/18-html-citeas-only/' do
      guid = 'https://w3id.org/a2a-fair-metrics/18-html-citeas-only/'

      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end

    it 'should not find non-PURL citeas https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/' do
      guid = 'https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/'

      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be false
    end
    it 'should not find PURL citeas https://w3id.org/a2a-fair-metrics/01-http-describedby-only/' do
      guid = 'https://w3id.org/a2a-fair-metrics/01-http-describedby-only/'

      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be false
    end

    
    it "should find PURL citeas in full html" do
      guid = 'https://w3id.org/a2a-fair-metrics/02-html-full/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end

    it "should NOT find PURL citeas in full html" do
      guid = 'https://s11.no/2022/a2a-fair-metrics/02-html-full/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be false
    end

    it "should find PURL citeas in json linkset" do
      guid = 'https://w3id.org/a2a-fair-metrics/07-http-describedby-citeas-linkset-json/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end
    it "should NOT find non-PURL citeas in json linkset" do
      guid = 'https://s11.no/2022/a2a-fair-metrics/07-http-describedby-citeas-linkset-json/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be false
    end

    it "should find PURL citeas in text linkset" do
      guid = 'https://w3id.org/a2a-fair-metrics/08-http-describedby-citeas-linkset-txt/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end
    it "should NOT find non-PURL citeas in text linkset" do
      guid = 'https://s11.no/2022/a2a-fair-metrics/08-http-describedby-citeas-linkset-txt/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be false
    end

    it "should find PURL citeas only in json linkset" do
      guid = 'https://w3id.org/a2a-fair-metrics/27-http-linkset-json-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end
    it "should NOT find non-PURL citeas only in json linkset" do
      guid = 'https://s11.no/2022/a2a-fair-metrics/27-http-linkset-json-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be false
    end

    it "should find PURL citeas only in text linkset" do
      guid = 'https://w3id.org/a2a-fair-metrics/28-http-linkset-txt-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end
    it "should NOT find non-PURL citeas only in text linkset" do
      guid = 'https://s11.no/2022/a2a-fair-metrics/28-http-linkset-txt-only/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be false
    end

    it "should find PURL citeas when there are three relationships in one rel clause in the HTTP headers" do
      guid = 'https://w3id.org/a2a-fair-metrics/17-http-citeas-multiple-rels/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end

    it "should find PURL citeas when there are three relationships in one rel clause in the HTML headers" do
      guid = 'https://w3id.org/a2a-fair-metrics/19-html-citeas-multiple-rels/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end

    it 'should add a warning 004 for a URL which has multiple, conflicting cite-as links' do
      guid = 'https://w3id.org/a2a-fair-metrics/19-html-citeas-multiple-rels/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      warnings = extract_warning_ids(warnings: metadata.warnings)
      expect(warnings.include? '004').to be true
    end

    it 'should add a warning 004 for when citeas differs between hTML and HTTP links' do
      guid = 'https://w3id.org/a2a-fair-metrics/21-http-html-citeas-differ/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      warnings = extract_warning_ids(warnings: metadata.warnings)
      expect(warnings.include? '004').to be true
    end

    it "should find PURL citeas which has described-by and cite-as in mixed HTTP and HTML headers" do
      guid = 'https://w3id.org/a2a-fair-metrics/22-http-html-citeas-describedby-mixed/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end

    it "should find PURL citeas which has citeas-describedby-item-license-type-author in HTTP headers" do
      guid = 'https://w3id.org/a2a-fair-metrics/23-http-citeas-describedby-item-license-type-author/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end

    it "should find PURL citeas even with a 204 no content, but in HTTP headers" do
      guid = 'https://w3id.org/a2a-fair-metrics/24-http-citeas-204-no-content/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end

    it "should find PURL citeas even with a 410 gone, but in HTTP headers" do
      guid = 'https://w3id.org/a2a-fair-metrics/25-http-citeas-author-410-gone/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      expect(hrefs.include? guid).to be true
    end

    it "should find PURL citeas even with a 203 non-authoritative, in HTTP headers" do
      guid = 'https://w3id.org/a2a-fair-metrics/26-http-citeas-203-non-authorative/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      $stderr.puts hrefs
      expect(hrefs.include? guid).to be true
    end


    it "should find find nothing, but not crash, when encoutering a 500-range error" do
      guid = 'https://s11.no/2022/a2a-fair-metrics/29-http-500-server-error/'
      links, metadata = FspHarvester::Utils.resolve_guid(guid: guid)
      hrefs = extract_citeas_hrefs(links: links)
      $stderr.puts hrefs
      expect(hrefs.include? guid).to be false
    end
  end
end
