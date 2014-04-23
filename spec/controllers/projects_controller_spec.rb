require 'spec_helper'

describe ProjectsController do
  before{ login user }
  let(:company) { create :company }
  let(:user) { create :user, is_admin: true, company: company }
  let(:project) { create :project, company: company }



  describe 'POST create' do
      it 'should create a project' do
        params = {
          when_day: '2013-08-20',
          project: { name: '1234' }
        }

        post :create, params
        expect(response).to redirect_to projects_path
      end

      it 'should not create a empty project' do
        params = {
          when_day: '2013-08-20',
          project: { name: '' }
        }

        post :create, params
        expect(response).to render_template :new
      end

    context 'PUT update' do

      context 'when authorize pass' do
        it 'should update a project' do
          params = {
            id: project.id,
            project: {
              name: '3214'
            }
          }

          put :update, params
          expect(response).to redirect_to projects_path
        end

        it 'should not update a project' do
          params = {
            id: project.id,
            project: {
              name: ''
           }
          }

          put :update, params
          expect(response).to render_template :edit
        end
      end
    end
  end
end
