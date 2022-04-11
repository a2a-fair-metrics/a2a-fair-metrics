require 'open3'

DescribedBy = String

describe DescribedBy do
  context 'When testing the describedby metric' do
    it 'should fail to find random strings (test of the rspec test) for https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby "https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/"')
      expect(result.match(/SUCCCCESS/).class.to_s).to eq 'NilClass'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/02-html-full/ with link in HTML' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby "https://w3id.org/a2a-fair-metrics/02-html-full/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return FAILURE for https://w3id.org/a2a-fair-metrics/03-http-citeas-only/ with no describedby link' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby "https://w3id.org/a2a-fair-metrics/03-http-citeas-only/"')
      expect(result.match(/FAILURE/).class.to_s).to eq 'MatchData'
    end

    it 'should return FAILURE for https://w3id.org/a2a-fair-metrics/18-html-citeas-only/ with no describedby link' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby "https://w3id.org/a2a-fair-metrics/18-html-citeas-only/"')
      expect(result.match(/FAILURE/).class.to_s).to eq 'MatchData'
    end

    it 'should return FAILURE for https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/ when type is not provided' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby "https://s11.no/2022/a2a-fair-metrics/01-http-describedby-only/"')
      expect(result.match(/FAILURE/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/04-http-described-iri/ where the link is an IRI' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby "https://w3id.org/a2a-fair-metrics/04-http-described-iri/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return FAILURE for https://w3id.org/a2a-fair-metrics/11-http-described-iri-wrong-type/ where the content type doesnt match' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby "https://w3id.org/a2a-fair-metrics/11-http-described-iri-wrong-type/"')
      expect(result.match(/FAILURE/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://s11.no/2022/a2a-fair-metrics/07-http-describedby-citeas-linkset-json/ which has describedby in a json linkset' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby "https://s11.no/2022/a2a-fair-metrics/07-http-describedby-citeas-linkset-json/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end


    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/24-http-linkset-json-only/ which has describedby ONLY in a json linkset' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby-as "https://w3id.org/a2a-fair-metrics/24-http-linkset-json-only/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

    it 'should return SUCCESS for https://w3id.org/a2a-fair-metrics/25-linkset-txt-only/ which has cite-as ONLY in a text linkset' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_describedby-as "https://w3id.org/a2a-fair-metrics/25-linkset-txt-only/"')
      expect(result.match(/SUCCESS/).class.to_s).to eq 'MatchData'
    end

  end
end
