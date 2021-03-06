require 'open3'

PermaCiteAs = String

describe PermaCiteAs do
  context 'When testing the perma-cite-as metric' do
    it 'should fail to find random strings (test of the rspec test) for https://w3id.org/a2a-fair-metrics/03-http-citeas-only/' do
      result, _error, _status = Open3.capture3('ruby Apples_perma-cite-as "https://w3id.org/a2a-fair-metrics/03-http-citeas-only/"')
      expect(result.match(/SUCCCCESS/).class.to_s).to eq 'NilClass'
    end
    it 'should return FAILURE for https://s11.no/2022/a2a-fair-metrics/10-http-citeas-not-perma' do
      result, _error, _status = Open3.capture3('ruby ./tests/Apples_perma-cite-as "https://s11.no/2022/a2a-fair-metrics/10-http-citeas-not-perma/"')
      expect(result.match(/FAILURE/).class.to_s).to eq 'MatchData'
    end
  end
end
