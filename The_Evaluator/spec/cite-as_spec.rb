
Dir[File.join(__dir__, '../', '*')].each {|file| require_relative file }

describe CiteAs do 
   context "When testing the cite-as metric" do 
      
      it "should return true for https://w3id.org/a2a-fair-metrics/03-http-citeas-only/" do 
         result, error, status = open3('../tests/Apples_cite-as "https://w3id.org/a2a-fair-metrics/03-http-citeas-only/"')
         expect{result.match(/SUCCESS/).class}.to be MatchData
      end
   end

end