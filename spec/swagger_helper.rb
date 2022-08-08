# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  config.swagger_root = Rails.root.join('swagger').to_s

  config.swagger_docs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'Punchclock API',
        version: 'v1',
        contact: {
          name: 'Punchclock',
          url: 'https://github.com/Codeminer42/Punchclock'
        }
      },
      paths: {},
      components: {
        securitySchemes: {
          bearer: {
            type: :http,
            scheme: :bearer
          }
        }
      },
      servers: [
        {
          url: 'http://localhost:5000'
        }
      ]
    }
  }

  config.swagger_format = :yaml
end
