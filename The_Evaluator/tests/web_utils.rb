def fetch(url, headers = ACCEPT_ALL_HEADER)  #we will try to retrieve turtle whenever possible

    $stderr.puts "In fetch routine now.  "
    
    begin
        $stderr.puts "executing call over the Web to #{url.to_s}"
        response = RestClient::Request.execute({
                method: :get,
                url: url.to_s,
                #user: user,
                #password: pass,
                headers: headers})
        if @meta
            @meta.finalURI |= [response.request.url]
        end
        $stderr.puts "There was a response to the call #{url.to_s}"
        $stderr.puts "Response code #{response.code}"
        if response.code == 203 
            @meta.comments << "WARN: Response is non-authoritative (HTTP response code: #{response.code}).  Headers may have been manipulated encountered when trying to resolve #{url.to_s}\n" if @meta
        end
        return [response.headers, response.body]
    rescue RestClient::ExceptionWithResponse => e
        $stderr.puts "EXCEPTION WITH RESPONSE! #{e.response}\n#{e.response.headers}"
        @meta.comments << "WARN: HTTP error #{e} encountered when trying to resolve #{url.to_s}\n" if @meta
        if e.response.code == 500
            response = [false, false]
        else
            response = [e.response.headers, e.response.body]
        end
        return response  # now we are returning the headers and body that were returned
    rescue RestClient::Exception => e
        $stderr.puts "EXCEPTION WITH NO RESPONSE! #{e}"
        @meta.comments << "WARN: HTTP error #{e} encountered when trying to resolve #{url.to_s}\n" if @meta
        response = [false, false]
        return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
    rescue Exception => e
        $stderr.puts "EXCEPTION UNKNOWN! #{e}"
        @meta.comments << "WARN: HTTP error #{e} encountered when trying to resolve #{url.to_s}\n" if @meta
        response = [false, false]
        return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
    end		  # you can capture the Exception and do something useful with it!\n",

end
