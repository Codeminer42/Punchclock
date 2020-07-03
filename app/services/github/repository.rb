module Github
  class Repository
    Result = Struct.new(:success?, :keys) do
      def languages
        keys.join(', ')
      end
    end

    class << self
      def fetch_languages(repository_link)
        repository_name = extract_name(repository_link)
        response = HTTParty.get(url(repository_name), options)
        Result.new(response.success?, response.keys)
      end

      private

      def url(repository_name)
        "#{API_URL}repos#{repository_name}/languages"
      end

      def options
        { headers: { 'Authorization' => "token #{GITHUB_OAUTH_TOKEN}" } }
      end
      
      def extract_name(url)
        name = URI.parse(url).path
  
        # Required if the link comes with a "/" in the end
        # causing problems during the request
        # e.g http://github.com/vuetifyjs/vuetify/ instead of
        # https://github.com/vuetifyjs/vuetify
        name.delete_suffix('/')
      end
    end
  end
end
