module NewAdmin
  module ContributionsHelper
    def contribution_state_options_for_select
      Contribution.aasm.states.map do |state|
        [Contribution.human_attribute_name("state/#{state.name}"), state.name]
      end
    end
  end
end
