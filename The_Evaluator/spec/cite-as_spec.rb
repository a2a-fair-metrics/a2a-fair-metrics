require 'open3'

CiteAs = String

describe CiteAs do
  context 'When testing the cite-as metric' do
    it 'should fail to find random strings (test of the rspec test) for https://w3id.org/a2a-fair-metrics/03-http-citeas-only/' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/03-http-citeas-only/"')
      expect(result.match(/SUCCCCESS/).class.to_s).to eq 'NilClass'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/03-http-citeas-only/' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/03-http-citeas-only/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/18-html-citeas-only/' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/18-html-citeas-only/"')
      #expect(result.to_s).to eq 'MatchData'
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return FAILURE for https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/"')
      expect(result.match(/FAILURE/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://s11.no/2022/a2a-fair-metrics/02-html-full/' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://s11.no/2022/a2a-fair-metrics/02-html-full/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://s11.no/2022/a2a-fair-metrics/07-http-describedby-citeas-linkset-json/ which has cite-as in a json linkset' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://s11.no/2022/a2a-fair-metrics/07-http-describedby-citeas-linkset-json/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/08-http-describedby-citeas-linkset-txt/ which has cite-as in a text linkset' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/08-http-describedby-citeas-linkset-txt/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/27-http-linkset-json-only/ which has cite-as ONLY in a json linkset' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/27-http-linkset-json-only/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/28-http-linkset-txt-only/ which has cite-as ONLY in a text linkset' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/28-http-linkset-txt-only/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/17-http-citeas-multiple-rels/ which has three different relationship types in one rel clause' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/17-http-citeas-multiple-rels/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/19-html-citeas-multiple-rels/ which has three different relationship types in one rel clause' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/19-html-citeas-multiple-rels/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should raise a WARN for https://w3id.org/a2a-fair-metrics/21-http-html-citeas-differ/ which has multiple, conflicting cite-as links' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/21-http-html-citeas-differ/"')
      expect(result.match(/WARN:\sConflicting\scite\-as\slinks/).class.to_s).to eq 'MatchData'
    end

  end
end