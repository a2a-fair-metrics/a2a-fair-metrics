require 'open3'

Item = String

describe Item do 
   context "When testing the item metric" do 
      
    it "should fail to find random strings (test of the rspec test) for https://s11.no/2022/a2a-fair-metrics/06-http-citeas-describedby-item/" do 
        result, error, status = Open3.capture3('ruby ./tests/Apples_item "https://s11.no/2022/a2a-fair-metrics/06-http-citeas-describedby-item/"')
        expect(result.match(/SUCCCCESS/).class.to_s).to eq "NilClass"
    end

    it "should succeed when item is in the HTTP headers https://s11.no/2022/a2a-fair-metrics/06-http-citeas-describedby-item/" do 
        result, error, status = Open3.capture3('ruby ./tests/Apples_item "https://s11.no/2022/a2a-fair-metrics/06-http-citeas-describedby-item/"')
        expect(result.to_s).to eq "MatchData"
#        expect(result.match(/SUCCESS/).class.to_s).to eq "MatchData"
    end

    it "should succeed when item is in the HTML Link headers https://s11.no/2022/a2a-fair-metrics/02-html-full/" do 
        result, error, status = Open3.capture3('ruby ./tests/Apples_item "https://s11.no/2022/a2a-fair-metrics/02-html-full/"')
        expect(result.match(/SUCCESS/).class.to_s).to eq "MatchData"
    end

    it "should fail when item is not in either HTTP or HTML headers https://w3id.org/a2a-fair-metrics/03-http-citeas-only/" do 
        result, error, status = Open3.capture3('ruby ./tests/Apples_item "https://w3id.org/a2a-fair-metrics/03-http-citeas-only/"')
        expect(result.match(/SUCCESS/).class.to_s).to eq "MatchData"
    end

    it "should fail when item is not in either HTTP or HTML headers https://w3id.org/a2a-fair-metrics/03-http-citeas-only/" do 
        result, error, status = Open3.capture3('ruby ./tests/Apples_item "https://w3id.org/a2a-fair-metrics/03-http-citeas-only/"')
        expect(result.match(/SUCCESS/).class.to_s).to eq "MatchData"
    end

    it "should fail when item does not resolve https://w3id.org/a2a-fair-metrics/12-http-item-does-not-resolve" do 
        result, error, status = Open3.capture3('ruby ./tests/Apples_item "https://w3id.org/a2a-fair-metrics/12-http-item-does-not-resolve"')
        expect(result.match(/FAILURE/).class.to_s).to eq "MatchData"
    end
end

end