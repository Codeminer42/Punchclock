require 'spec_helper'

describe ProjectsController do
  login_user

  describe 'POST create' do
    let(:user) { double('user') }
    let(:project) { double('project') }
    let(:company) { FactoryGirl.build(:company) }

    before do
      user.stub(company: company)
      controller.stub(current_user: user)
    end

    context 'when authorize pass' do
      before { controller.stub(load_and_authorize_resource: true) }
      before { controller.stub(authorize!: true) }
      it 'should create a project' do
        params = {
          when_day: '2013-08-20',
          project: { name: '1234' }
        }

        Project.should_receive(:new).and_return(project)
        project.should_receive(:company=).with(user.company)
        project.should_receive(:save).and_return(true)
        post :create, params
        expect(response).to redirect_to projects_path
      end

      it 'should not create a empty project' do
        params = {
          when_day: '2013-08-20',
          project: { name: '' }
        }

        Project.should_receive(:new).and_return(project)
        project.should_receive(:company=).with(user.company)
        project.should_receive(:save).and_return(false)
        post :create, params
        expect(response).to render_template :new
      end
    end

    context 'PUT update' do
      let(:user) { double('user') }
      let(:project) { FactoryGirl.create(:project) }

      before do
        Project.stub(:find).with(project.id.to_s) { project }
      end

      context 'when authorize pass' do
        before { controller.stub(load_and_authorize_resource: true) }
        before { controller.stub(authorize!: true) }

        it 'should update a project' do
          params = {
            id: project.id,
            project: {
              name: '3214'
          }
          }

          expect(project).to receive(:update).and_return(true)
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

          expect(project).to receive(:update).and_return(false)
          put :update, params
          expect(response).to render_template :edit
        end
      end
    end
  end
end
