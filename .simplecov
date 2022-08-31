SimpleCov.start 'rails' do
  # https://github.com/codeclimate/test-reporter/issues/418
  # enable_coverage :branch
  # maximum_coverage_drop line: 1, branch: 1
  minimum_coverage 89
  add_filter %r{^/(?!app|lib)/}
  add_filter %r{^/app/channels/}
  add_filter %r{^/.gitlab-cache/}
  add_filter '.gems'
  add_group 'Admin', 'app/admin'
  add_group 'Decorators', 'app/decorators'
end
