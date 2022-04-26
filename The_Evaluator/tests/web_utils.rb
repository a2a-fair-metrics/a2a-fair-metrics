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
        return [response.headers, response.body]
    rescue RestClient::ExceptionWithResponse => e
        $stderr.puts "ERROR! #{e.response}"
        @meta.comments << "WARN: HTTP error #{e} encountered when trying to resolve #{url.to_s}\n" if @meta
        response = false
        return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
    rescue RestClient::Exception => e
        $stderr.puts "ERROR! #{e}"
        @meta.comments << "WARN: HTTP error #{e} encountered when trying to resolve #{url.to_s}\n" if @meta
        response = false
        return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
    rescue Exception => e
        $stderr.puts "ERROR! #{e}"
        @meta.comments << "WARN: HTTP error #{e} encountered when trying to resolve #{url.to_s}\n" if @meta
        response = false
        return response  # now we are returning 'False', and we will check that with an \"if\" statement in our main code
    end		  # you can capture the Exception and do something useful with it!\n",

end
